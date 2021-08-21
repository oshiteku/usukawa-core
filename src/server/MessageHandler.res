open Util

type message =
  | GeneralMessage({topic: string, persistent: bool, data: string})
  | SubscribeRequest({topic: string})

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

  let getOptionalProperty = (obj, key, decoder, default) => {
    open Js.Dict
    open Belt.Option
    switch obj->get(key) {
    | Some(x) => x->decoder->getExn
    | None => default
    }
  }

  open Js.Json

  let message = switch Js.Json.classify(json) {
  | Js.Json.JSONObject(obj) =>
    switch obj->getProperty("type", decodeString) {
    | "message" =>
      GeneralMessage({
        topic: obj->getProperty("topic", decodeString),
        persistent: obj->getOptionalProperty("persistent", decodeBoolean, false),
        data: obj->getProperty("data", decodeString),
      })
    | "subscribe" =>
      SubscribeRequest({
        topic: obj->getProperty("topic", decodeString),
      })
    | _ => failwith("Unknown message type")
    }
  | _ => failwith("Invalid message object")
  }

  switch message {
  | GeneralMessage({topic, data}) => Js.log(`message: ${topic}, ${data}`)
  | SubscribeRequest({topic}) => Js.log(`subscribe: ${topic}`)
  }
}

let process = (ws, messageBuffer, isBinary) => {
  try processMessage(ws, messageBuffer, isBinary) catch {
  | e => Js.log(e)
  }
}
