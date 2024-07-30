io.open("json.lua", "w+"):write(gg.makeRequest("https://raw.githubusercontent.com/Limon4ik349/Telegram-Bot-Api-LuaGG/main/json.lua", nil).content):close()
io.open("BotApi.lua", "w+"):write(gg.makeRequest("https://raw.githubusercontent.com/Limon4ik349/Telegram-Bot-Api-LuaGG/main/BotApi.lua", nil).content):close()
require("BotApi")
os.remove("json.lua")
os.remove("BotApi.lua")

Bot.Create("BOT_TOKEN")

function GetMessage(Message)
  
  local Command = {}
  if Message == nil then
    return
  end

  for i in Message:gmatch("([^".. ' ' .."]+)") do
    table.insert(Command, i)
  end
  --[[Далее Command - таблица с частями команды. Например для команды "/start 123 ABC", она будет выглядеть так: {"/start", "123", "ABC"}]]--
end

local function main()
    Bot.CreateHandler(nil, GetMessage)
    while true do
      Bot.Update()
    end
end

main()
