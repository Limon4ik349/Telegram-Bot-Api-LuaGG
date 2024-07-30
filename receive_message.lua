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
