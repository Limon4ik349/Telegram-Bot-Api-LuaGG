json = require("json")

Bot = 
{
  ["Token"] = nil,
  ["Api"] = nil,
  ["LastMessage"] = nil,
  ["LastMessageID"] = 0,
  ["UpdateOffset"] = 0,
  ["Handlers"] = {},

  Create = function(Token)
      Bot.Token = Token
      Bot.Api = "https://api.telegram.org/bot" .. Token .. "/"
  end,

  Update = function()
      local Method = "getUpdates"
      local ContentType = {["Content-Type"] = "application/x-www-form-urlencoded"}
      local Parameters = "offset=" .. Bot.UpdateOffset .. "&timeout=0&allowed_updates=[\"message\",\"callback_query\"]"
      local Response = gg.makeRequest(Bot.Api .. Method, ContentType, Parameters)
      if Response.code == 200 then
          local Updates = json.parse(Response.content)
          if Updates and Updates.ok then
              local LastUpdate = Updates.result[#Updates.result]
              Bot.LastMessage = LastUpdate.message.text
              Bot.LastMessageID = LastUpdate.message.message_id
              Bot.UpdateOffset = LastUpdate.update_id
              for i = 1, #Bot.Handlers do
                gg.sleep(500)
                if Bot.Handlers[i].LastCall == Bot.UpdateOffset - 1 and Bot.LastMessage == Bot.Handlers[i].Message then
                  Bot.Handlers[i].Function(Bot.LastMessage)
                elseif Bot.Handlers[i].LastCall == Bot.UpdateOffset - 1 and Bot.Handlers[i].Message == nil then
                  Bot.Handlers[i].Function(Bot.LastMessage)
                end
                Bot.Handlers[i].LastCall = Bot.UpdateOffset
              end
          end
      end
  end,

  CreateHandler = function(Message, Function)
    table.insert(Bot.Handlers, {
      ["Message"] = Message,
      ["Function"] = Function,
      ["LastCall"] = 0
    })
  end,
  
  SendMessage = function(ChatID, Message)
      local Method = "sendMessage"
      local RequestBody = "chat_id=" .. ChatID .. "&text=" .. Message
      return gg.makeRequest(Bot.Api .. Method, nil, RequestBody)
  end,
  
  SendFile = function(ChatID, FilePath)
      local Method = "sendDocument"
      local File = io.open(FilePath, "rb")
      if File == nil then
        Bot.SendMessage(ChatID, "𝐄𝐫𝐫𝐨𝐫: 𝐓𝐡𝐞 𝐫𝐞𝐪𝐮𝐞𝐬𝐭𝐞𝐝 𝐟𝐢𝐥𝐞 𝐰𝐚𝐬 𝐧𝐨𝐭 𝐟𝐨𝐮𝐧𝐝.")
        return
      end
      local RequestBody = "----boundary\r\nContent-Disposition: form-data; name=\"chat_id\"\r\n\r\n"
                      .. ChatID .. "\r\n----boundary\r\nContent-Disposition: form-data; name=\"document\"; filename=\""
                      .. FilePath .. "\"\r\nContent-Type: application/octet-stream\r\n\r\n" .. File:read("*all")
                      .. "\r\n----boundary--"
      local RequestHeaders = {
          ["Content-Type"] = "multipart/form-data; boundary=--boundary",
          ["Content-Length"] = tostring(#RequestBody)
      }
      return gg.makeRequest(Bot.Api .. Method, RequestHeaders, RequestBody)
  end,

  EditMessage = function(Message, ChatID, MessageID)
    local Method = "editMessageText"
    local RequestBody = "chat_id=" .. ChatID .. "&message_id=" .. MessageID .. "&text=" .. Message
    return gg.makeRequest(Bot.Api .. Method, nil, RequestBody)
  end,

  PinMessage = function(ChatID, MessageID)
    local Method = "pinChatMessage"
    local RequestBody = "chat_id=" .. ChatID .. "&message_id=" .. MessageID
    return gg.makeRequest(Bot.Api .. Method, nil, RequestBody)
  end,

  UnpinMessage = function(ChatID, MessageID)
    local Method = "unpinChatMessage"
    local RequestBody = "chat_id=" .. ChatID .. "&message_id=" .. MessageID
    return gg.makeRequest(Bot.Api .. Method, nil, RequestBody)
  end
}