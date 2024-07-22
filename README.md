# Api для взаимодействия с Telegram-ботами через GameGuardian

## Добавление в свой проект

### Скачивание файлов и их подключение
1. Скачайте файлы BotApi.lua и json.lua.
2. Переместите их в папку к Вашему проекту.
3. Подключите BotApi следующим образом:
> require("BotApi")
### Подключение через запрос на сервер
1. Добавьте следующий код в начало скрипта:
> io.open("json.lua", "w+"):write(gg.makeRequest("https://raw.githubusercontent.com/Limon4ik349/Telegram-Bot-Api-LuaGG/main/json.lua", nil).content):close()
> 
> io.open("BotApi.lua", "w+"):write(gg.makeRequest("https://raw.githubusercontent.com/Limon4ik349/Telegram-Bot-Api-LuaGG/main/BotApi.lua", nil).content):close()
> 
> require("BotApi")
> 
> os.remove("json.lua")
> 
> os.remove("BotApi.lua")
## Инициализация и работа с api
1. Создание подкючения к боту:
> Bot.Create("BOT_TOKEN")
При этом обновляются поля: Token, Api и UpdateOffset
2. Обновление сообщений:
> Bot.Update()
При этом обновляются поля: LastMessage и LastMessageID
3. Создание **handler'a**:
> Bot.CreateHandler("MESSAGE", FUNCTION)
При получении сообщения **'MESSAGE'** будет выполнятся функция **'FUNCTION()'** с аргументом в виде полученного сообщения в строчном формате.
