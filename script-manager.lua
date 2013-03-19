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
-- Bug reports and feature requests please send to issue tracker at:
-- http://opensource.hub21.ru/rushub-script-manager/issues
-- ***************************************************************************
-- SETTINGS:
def_config = {
	allow_prefix= {["!"]=true, ["+"]=true}, -- Definition allowed prefixes. 
	acl = { -- Definition profiles and acl for commands etc
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
}
-- ***************************************************************************
_MYVERSION = "0.2"
_TRACEBACK = debug.traceback	
lang_file = Config.sLangPath.."scripts/"..Config.sLang.."/script-manager.lang" -- Definition language file
dofile(lang_file) -- Load language file

function OnStartup()
	botname = Config.sHubBot
end

def_commands = { -- commands
	["startscript"] = { -- definition command name startscript 
		options={
			short_description = lang[1],
		},
		["acl"] = function (UID,cmd, sData) -- check access
			return check_acl(UID, cmd)
		end,
		
		-- Handler for this command
		-- @return true and data
		["cmd"] = function(UID, cmd, sData)
			if cmd then
				if not sData or sData == "" then
					return true, lang[2]:format(cmd)
				end
				local ascript = Core.GetScript(sData) or {}
				if not ascript.sName then
					return true, lang[3]:format(sData)
				elseif ascript.bEnabled then
					return true, lang[4]:format(sData)
				else
					local err = false
					local _, err = Core.StartScript(ascript.sName)
					if err then
						return true, lang[5]:format(ascript.sName, err)
					else
						return true, lang[6]:format(ascript.sName)
					end
				end				
			end
		end,

		-- Documentation for this command.
		["man"] = function(UID, cmd, sData)
			return true, lang[7]:gsub("%[(%S+)%]", {CMD = cmd, CURNAME=Core.GetScript().sName})
		end,	
	}, -- command startscript end 
	
	["stopscript"] = {
		options={
			short_description=lang[8],
		},
		
		["acl"] = function(UID, cmd, sData)
			return check_acl(UID,cmd)
		end,
	
		["cmd"] = function (UID, cmd, sData)
			if cmd then
				if not sData or sData == "" then
					return true, lang[2]:format(cmd)
				end
				local ascript = Core.GetScript(sData) or {}
				if not ascript.sName then
					return true, lang[3]:format(sData)
				elseif not ascript.bEnabled then
					return true, lang[9]:format(sData)
				else
					local err = false
					local _, err = Core.StopScript(ascript.sName)
					if err then
						return true, lang[10]:format(ascript.sName,err)
					else
						return true, lang[11]:format(ascript.sName)
					end
				end	
			end
		end,
	
		["man"] = function (UID, cmd, sData)
			return true, lang[12]:gsub("%[(%S+)%]", {CMD = cmd, CURNAME=Core.GetScript().sName})
		end,
	},
	
	["lsscript"] = {
		options={
			short_description=lang[15],
		},
	
		["acl"] = function (UID, cmd, sData)
			return check_acl(UID, cmd)
		end,
		
		["cmd"] = function (UID, cmd, sData)
			if cmd then
				if not sData then
					local script_list=""
					for i, v in ipairs(Core.GetScripts()) do
						script_list = script_list..(("\t%s\t%s\t\t%s\t\t%s\n"):format(i > 9 and i or "0"..i, v.bEnabled and lang[13] or lang[14], v.sName, v.iMemUsage ~= 0 and (" (%s kb)"):format(v.iMemUsage) or ""))
					end
					return true, lang[16]..script_list	
				elseif sData ~= nil then
					script=Core.GetScript(sData)
					if not script.sName then
						return true, lang[3]:format(sData)
					else
						return true, lang[17]:format(script.sName, script.bEnabled and lang[13] or lang[14], script.iMemUsage ~= 0 and (" (%s kb)"):format(script.iMemUsage) or "")	
					end
				end
			end
		end,
	
		["man"] = function (UID, cmd, sData)
			return true, lang[18]:gsub("%[(%S+)%]", {CMD = cmd, CURNAME=Core.GetScript().sName})
		end,
	},
	
	["movedownscript"] = {
		options={
			short_description=lang[19],
		},
	
		["acl"] = function(UID, cmd, sData)	
			return check_acl(UID, cmd)
		end,
		
		["cmd"] = function(UID, cmd, sData)
			if cmd then
				if not sData or sData == "" then
					return true, lang[2]:format(cmd)
				end
				local ascript = Core.GetScript(sData) or {}
				if not ascript.sName then
					return true, lang[3]:format(sData)
				else 
					local err = false
					local _, err = Core.MoveDownScript(ascript.sName)
					if err then
						return true, lang[20]:format(ascript.sName,err)
					else
						return true, lang[21]:format(ascript.sName)
					end
				end
			end	
		end,
	
		["man"] = function (UID, cmd, sData)
			return true, lang[22]:gsub("%[(%S+)%]", {CMD = cmd, CURNAME=Core.GetScript().sName})
		end,
	
	},
	
	["moveupscript"] = {
		options={
			short_description=lang[25],
		},
		
		["acl"] = function (UID, cmd, sData)
			return check_acl(UID, cmd)
		end,
		
		["cmd"] = function(UID, cmd, sData)
			if cmd then
				if not sData or sData == "" then
					return true, lang[2]:format(cmd)
				end
				local ascript = Core.GetScript(sData) or {}
				if not ascript.sName then
					return true, lang[3]:format(sData)
				else
					local err = false
					local _, err = Core.MoveUpScript(ascript.sName)
					if err then
						return true, lang[23]:format(ascript.sName, err)
					else
						return true, lang[24]:format(ascript.sName)
					end
				end
			end
		end,
		
		["man"] = function (UID, cmd, sData)
			return true, lang[26]:gsub("%[(%S+)%]", {CMD = cmd, CURNAME=Core.GetScript().sName})
		end,
	},
	
	["restartscript"] = {
		options={
			short_description=lang[27],
		},
		
		["acl"] = function(UID, cmd, sData)
			return check_acl(UID, cmd)
		end,
		
		["cmd"] = function(UID, cmd, sData)
			if cmd then
				if not sData then
					local bool = Core.RestartScripts()
					if bool then
						return true, lang[28]
					end
				elseif sData then
					local ascript = Core.GetScript(sData) or {}
					if not ascript.sName then
						return true, lang[3]:format(sData)
					else
						local err = false
						local _, err = Core.RestartScript(ascript.sName)
						if err then
							return true, lang[29]:format(ascript.sName, err)
						else
							return true, lang[30]:format(ascript.sName)
						end
					end
				end
			end
		end,
		
		["man"] = function(UID, cmd, sData)
			return true, lang[31]:gsub("%[(%S+)%]", {CMD = cmd, CURNAME=Core.GetScript().sName})
		end,
	
	}
	
	
} -- commands end

-- check allow access to use 'cmd'.
-- @return true if allowed
-- @return false and msg if not allowed
function check_acl(UID, cmd)
	if cmd then
		local profile=UID.iProfile
		if def_config.acl[profile] and def_config.acl[profile].tcmds[cmd] then
			return true
		else
			return false, lang[32]
		end
	end
end

-- Handler data in chat.
function OnChat(UID, sData)
	local prefix, cmd = sData:match("^%b<>%s+(%p)(%S+)")
	if prefix and cmd and def_config.allow_prefix[prefix] and def_commands[cmd] then
		sData = sData:match("^%b<>%s+%p%S+%s+(.+)")
		local aclbool, acl_reason = def_commands[cmd]["acl"](UID, cmd) -- is allowed?
		if aclbool then
			--  if find -H or -h keys in sData, execute 'man' function in def_commands[commandname]. If no - execute 'cmd' in def_commands[commandname].
			local res, msg = def_commands[cmd][(sData and sData:find("^%-[Hh]$")) and "man" or "cmd"](UID, cmd, sData)
			if res then -- if result is not none, send data to user
				Core.SendToUser(UID, msg, botname)
			end
			collectgarbage("collect")
		else
			Core.SendToUser(UID, acl_reason, botname) -- if not access, send error message to user.
		end
		return true
	end
	
end

function OnError(s)
	Core.SendToProfile(0,s,botname)
	print(s) -- if hub is not a daemon, show errors in console. It only for debug.
	--return true  -- Do not stop the script at runtime errors. IT IS DANGER!!! But we can lose control. :(
end
