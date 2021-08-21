open Util

type message = Message({topic: string, msgType: string, persistent: bool, data: string})

let processMessage = (_ws, messageBuffer, _isBinary) => {
  open TextDecoder
  let dataView = DataView.make(messageBuffer)
  let decoder = TextDecoder.make()
  let json = try decoder->decode(dataView)->Js.Json.parseExn catch {
  | _ => failwith("Error parsing message")
  }


  let getProperty = (obj, key, decoder) => {
    open Js.Dict
    open Belt.Option
    obj->get(key)->getExn->decoder->getExn
  }

  open Js.Json

  let message = switch Js.Json.classify(json) {
  | Js.Json.JSONObject(value) =>
    Message({
      topic: value->getProperty("topic", decodeString),
      msgType: value->getProperty("type", decodeString),
      persistent: value->getProperty("persistent", decodeBoolean),
      data: value->getProperty("data", decodeString),
    })
  | _ => failwith("Invalid message")
  }

  switch message {
  | Message({msgType: "message"}) => Js.log(message)
  | Message(_) => Js.log(message)
  }
}

let process = (ws, messageBuffer, isBinary) => {
  try processMessage(ws, messageBuffer, isBinary) catch {
  | e => Js.log(e)
  }
}
