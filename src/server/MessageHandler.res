open Util

type message = Message({topic: string, msgType: string, persistent: bool, data: string})

let process = (_ws, messageBuffer, _isBinary) => {
  open TextDecoder
  let dataView = DataView.make(messageBuffer)
  let decoder = TextDecoder.make()
  let json = try decoder->decode(dataView)->Js.Json.parseExn catch {
  | _ => {
      Js.log("Error parsing message")
      Js.Json.null
    }
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
  }

  switch message {
  | Message({msgType: "message"}) => Js.log(message)
  | Message(_) => Js.log(message)
  }
}
