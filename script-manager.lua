-- ***************************************************************************
-- script-manager - This is a script for RusHub to manage scripts.
-- Copyright (c) 2013 Denis 'Saymon21' Khabarov (saymon@hub21.ru)

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License version 3
-- as published by the Free Software Foundation.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
-- ***************************************************************************
_MYVERSION = "0.1"
-- SETTINGS:
def_allow_prefix= {["!"]=true, ["+"]=true} -- Definition allowed prefixes. 
def_acl = { -- Definition profiles and acl for commands, etc
	[0]= {
		tcmds={
			["startscript"] = true,
			["stopscript"] = true,
			["lsscript"] = true,
			["movedownscript"] = true,
			["moveupscript"] = true,
			["restartscript"] = true,
			
		}
	}
}
-- ***************************************************************************
def_commands = { -- commands
	["startscript"] = {
		
		-- short_description="Start script",
		-- user_command = {{1, 3, "Move start script", "!%s %[line:Enter script name]"}}
		["acl"] = function (UID,cmd, sData) -- check access
			return check_acl(UID, cmd)
		end,
		
		-- Handler for this command
		-- @return true and data
		["cmd"] = function(UID, cmd, sData)
			if cmd then
				if not sData or sData == "" then
					return true, "Invalid arguments. See !"..cmd.." -h for more details."
				end
				local ascript = Core.GetScript(sData) or {}
				if not ascript.sName then
					return true, "Script \""..sData.."\" not found!"
				elseif ascript.bEnabled then
					return true, "Script \""..sData.."\" is already running!"
				else
					local err = false
					local _, err = Core.StartScript(ascript.sName)
					if err then
						return true, "Error when starting script \"".. ascript.sName.. " \": "..err
					else
						return true, "\""..ascript.sName.."\": successfully loaded & initialized"
					end
				end				
			end
		end,

		-- Documentation for this command.
		["man"] = function(UID, cmd, sData)
			return true, "\r\nNAME:\r\n\t!"..cmd..
				"\r\nSYNOPSIS:\r\n\t"..cmd..
				" [ -h ] [ scriptname ]\r\nDESCRIPTION:\r\n\t"..cmd..
				" - command to load scripts.\r\nOPTIONS:\r\n\t-h\t Show this help\nEXAMPLE USAGE:\r\n\t!".. cmd.." ".. Core.GetScript().sName.."\r\nSEE ALSO:\r\n\t !stopscript, !lsscript, !movedownscript, !moveupscript, !restartscript"
		end,
		
	}, -- command startscript end 
	
	["stopscript"] = {
		["acl"] = function(UID, cmd, sData)
			return check_acl(UID,cmd)
		end,
	
		["cmd"] = function (UID, cmd, sData)
			if cmd then
				if not sData or sData == "" then
					return true, "Invalid arguments. See !"..cmd.." -h for more detals."
				end
				local ascript = Core.GetScript(sData) or {}
				if not ascript.sName then
					return true, "Script \""..sData.."\" not found!"
				elseif not ascript.bEnabled then
					return true, "Script \""..sData .."\" is already stopped!"
				else
					local err = false
					local _, err = Core.StopScript(ascript.sName)
					if err then
						return true, "Error when stopping script \"".. ascript.sName.. " \": "..err
					else
						return true, "Script \""..ascript.sName.."\" successfully unloaded"
					end
				end	
			end
		end,
	
		["man"] = function (UID, cmd, sData)
			return true, "\r\nNAME:\r\n\t!"..cmd..
				"\r\nSYNOPSIS:\r\n\t"..cmd..
				" [ -h ] [ scriptname ]\r\nDESCRIPTION:\r\n\t"..cmd..
				" - command to unload scripts.\r\nOPTIONS:\r\n\t-h\t Show this help\nEXAMPLE USAGE:\r\n\t!".. cmd.." ".. Core.GetScript().sName.."\r\nSEE ALSO:\r\n\t !startscript, !lsscript, !movedownscript, !moveupscript, !restartscript"
		end,
	},
	
	["lsscript"] = {
		["acl"] = function (UID, cmd, sData)
			return check_acl(UID, cmd)
		end,
		
		["cmd"] = function (UID, cmd, sData)
			if cmd then
				local msg_header="\r\n\tID [ STATE ] \t         NAME              MEMUSAGE\r\n"
				if not sData then
					local script_list=""
					for i, v in ipairs(Core.GetScripts()) do
						script_list = script_list..(("\t%s [ %s ] \t%s%s\n"):format(i > 9 and i or "0"..i, v.bEnabled and "enabled" or "disabled", v.sName, v.iMemUsage ~= 0 and (" (%s kb)"):format(v.iMemUsage) or ""))
					end
					return true, msg_header..script_list	
				elseif sData ~= nil then
					script=Core.GetScript(sData)
					if not script.sName then
						return true, "Script \""..sData.."\" not found!"
					else
						return true, (("\nInformation for script \"%s\":\r\n\tState: %s\r\n\tMemUsage: %s\r\n"):format(script.sName, script.bEnabled and "enabled" or "disabled", script.iMemUsage ~= 0 and (" (%s kb)"):format(script.iMemUsage) or ""))	
					end
				end
			end
		end,
	
		["man"] = function (UID, cmd, sData)
			return true, "\r\nNAME:\r\n\t!"..cmd..
				"\r\nSYNOPSIS:\r\n\t"..cmd..
				" [ -h ] [ scriptname ]\r\nDESCRIPTION:\r\n\t"..cmd..
				" - command to show information for script(s). If [ scriptname ] not specified, shows information about all the scripts.\r\nOPTIONS:\r\n\t-h\t Show this help\nEXAMPLE USAGE:\r\n\t!".. cmd.." ".. Core.GetScript().sName.." - show info for one scripts.\r\n\t!"..cmd.." - show info for all scripts\r\nSEE ALSO:\r\n\t !startscript, !stopscript, !movedownscript, !moveupscript, !restartscript"
		end,
	},
	
	["movedownscript"] = {
		["acl"] = function(UID, cmd, sData)	
			return check_acl(UID, cmd)
		end,
		
		["cmd"] = function(UID, cmd, sData)
			if cmd then
				if not sData or sData == "" then
					return true, "Invalid arguments. See !"..cmd.." -h for more detals."
				end
				local ascript = Core.GetScript(sData) or {}
				if not ascript.sName then
					return true, "Script \""..sData.."\" not found!"
				else 
					local err = false
					local _, err = Core.MoveDownScript(ascript.sName)
					if err then
						return true, "Error when moveup script \"".. ascript.sName.. " \": "..err
					else
						return true, "Script \""..ascript.sName.."\" moved up OK"
					end
				end
			end	
		end,
	
		["man"] = function (UID, cmd, sData)
			return true, "\r\nNAME:\r\n\t!"..cmd..
				"\r\nSYNOPSIS:\r\n\t"..cmd..
				" [ -h ] [ scriptname ]\r\nDESCRIPTION:\r\n\t"..cmd..
				" - command lowers priority the script in the execution trees.\r\nOPTIONS:\r\n\t-h\t Show this help\nEXAMPLE USAGE:\r\n\t!".. cmd.." ".. Core.GetScript().sName.." - lowers priority for this script.\r\nSEE ALSO:\r\n\t !startscript, !stopscript, !lsscript, !moveupscript, !restartscript"
		end,
	
	},
	
	["moveupscript"] = {
		["acl"] = function (UID, cmd, sData)
			return check_acl(UID, cmd)
		end,
		
		["cmd"] = function(UID, cmd, sData)
			if cmd then
				if not sData or sData == "" then
					return true, "Invalid arguments. See !"..cmd.." -h for more detals."
				end
				local ascript = Core.GetScript(sData) or {}
				if not ascript.sName then
					return true, "Script \""..sData.."\" not found!"
				else
					local err = false
					local _, err = Core.MoveUpScript(ascript.sName)
					if err then
						return true, "Error when moveup script \"".. ascript.sName.. " \": "..err
					else
						return true, "Script \""..ascript.sName.."\" increase priority OK"
					end
				end
			end
		end,
		
		["man"] = function (UID, cmd, sData)
			return true,"\r\nNAME:\r\n\t!"..cmd..
				"\r\nSYNOPSIS:\r\n\t"..cmd..
				" [ -h ] [ scriptname ]\r\nDESCRIPTION:\r\n\t"..cmd..
				" - command increase priority the script in the execution trees.\r\nOPTIONS:\r\n\t-h\t Show this help\nEXAMPLE USAGE:\r\n\t!".. cmd.." ".. Core.GetScript().sName.." - lowers priority for this script.\r\nSEE ALSO:\r\n\t !startscript, !stopscript, !lsscript, !movedownscript, !restartscript"
		end,
	},
	
	["restartscript"] = {
		["acl"] = function(UID, cmd, sData)
			return check_acl(UID, cmd)
		end,
		
		["cmd"] = function(UID, cmd, sData)
			if cmd then
				if not sData then
					local bool = Core.RestartScripts()
					if bool then
						return true, "All scripts successfully reloaded & reinitialized"
					end
				elseif sData then
					local ascript = Core.GetScript(sData) or {}
					if not ascript.sName then
						return true, "Script \""..sData.."\" not found!"
					else
						local err = false
						local _, err = Core.RestartScript(ascript.sName)
						if err then
							return true, "Error when restart script \"".. ascript.sName.. "\": "..err 
						else
							return true, "Script \"".. ascript.sName.. "\" successfully reloaded & reinitialized"
						end
					end
				end
			end
		end,
		
		["man"] = function(UID, cmd, sData)
			return true, "\r\nNAME:\r\n\t!"..cmd..
				"\r\nSYNOPSIS:\r\n\t"..cmd..
				" [ -h ] [ scriptname ]\r\nDESCRIPTION:\r\n\t"..cmd..
				" - command for restart a script(s). If [ scriptname ] not specified, restart all the scripts.\r\nOPTIONS:\r\n\t-h\t Show this help\nEXAMPLE USAGE:\r\n\t!".. cmd.." ".. Core.GetScript().sName.." - restart this script.\r\n\t!restartscript - restart all scripts.\r\nSEE ALSO:\r\n\t !startscript, !stopscript, !lsscript, !moveupscript, !movedownscript"
		end,
	
	}
	
	
} -- commands end

function check_acl(UID, cmd)
	if cmd then
		local profile=UID.iProfile
		if def_acl[profile] and def_acl[profile].tcmds[cmd] then
			return true
		else
			return false, "You are not allowed to use this command"
		end
	end
end


function OnChat(UID, sData)
	local prefix, cmd = sData:match( "^%b<>%s+(%p)(%S+)")
	if prefix and cmd and def_allow_prefix[prefix] and def_commands[cmd] then
		sData = sData:match("^%b<>%s+%p%S+%s+(.+)")
		local aclbool, acl_reason = def_commands[cmd]["acl"](UID, cmd)
		if aclbool then
			Core.SendToUser(UID, "Command: "..prefix..cmd.." "..(sData and sData or ""), Config.sHubBot)
			if sData and sData:find("^%-[Hh]$") then
				local res,msg = def_commands[cmd]["man"](UID, cmd, sData)
				if res then
					Core.SendToUser(UID, msg, Config.sHubBot)
				end
			else
				local res,msg = def_commands[cmd]["cmd"](UID, cmd, sData)
				if res then 
					Core.SendToUser(UID, msg, Config.sHubBot)
				end
			end
			collectgarbage("collect")
		else
			Core.SendToUser(UID, acl_reason, Config.sHubBot)
		end
		return true
	end
	
end

function OnError(s)
	Core.SendToAll(s)
	print(s)
	return true
end
