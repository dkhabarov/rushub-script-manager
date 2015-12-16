# rushub-script-manager
Cкрипт для управления скриптами на хабе RusHub.


Описание команд:

`!startscript scriptname.lua` - Запускает скрипт с именем scriptname.lua Если не удалось запустить скрипт, в чат будет выведено сообщение об ошибке.

`!stopscript scriptname.lua` - Останавливает скрипт с именем scriptname.lua. Если не удалось остановить скрипт, в чат будет выведено сообщение об ошибке.

`!lsscript scriptname.lua` - Выводит информацию о скрипте scriptname.lua (Статус, запущен или нет и расход памяти). Если имя скрипта не указано, выводит информацию о всех скриптах, в том порядке, в котором происходит их запуск.

`!movedownscript scriptname.lua` Опускает скрипт с именем scriptname.lua в дереве выполнения. Если не удалось опустить скрипт, в чат будет выведено сообщение об ошибке.

`!moveupscript scriptname.lua` Поднимает скрипт с именем scriptname.lua в дереве выполнения. Если не удалось поднять скрипт, в чат будет выведено сообщение об ошибке.

`!restartscript scriptname.lua` Перезапускает скрипт с именем scriptname.lua. Если имя скрипта не указано, перезапускает все скрипты. Если не удалось перезапустить скрипт, в чат будет выведено сообщение об ошибке.

Для всех команд можно использовать параметр -h для получения справки по использованию. Например:

`!lsscript -h`

Пример вывода:
```
[20:59:13] <RusHub> 
NAME:
    !lsscript
SYNOPSIS:
    lsscript [ -h ] [ scriptname ]
DESCRIPTION:
    lsscript - command to show information for script(s). If [ scriptname ] not specified, shows information about all the scripts.
OPTIONS:
    -h   Show this help
EXAMPLE USAGE:
    !lsscript test2.lua - show info for one scripts.
    !lsscript - show info for all scripts
SEE ALSO:
     !startscript, !stopscript, !movedownscript, !moveupscript, !restartscript
```
Кстати. Писать имя скрипта с окончанием .lua не обязательно.
