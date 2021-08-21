type message =
  | GeneralMessage({topic: string, persistent: bool, data: string})
  | SubscribeRequest({topic: string})

let parseFromString = messageString => {
  open Js.Json
  open Js.Dict
  open Belt.Option

  let json = try messageString->parseExn catch {
  | _ => failwith("Error parsing json")
  }

  let getProperty = (obj, key, decoder) => {
    obj->get(key)->getExn->decoder->getExn
  }

  let getOptionalProperty = (obj, key, decoder, default) => {
    switch obj->get(key) {
    | Some(x) => x->decoder->getExn
    | None => default
    }
  }

  switch classify(json) {
  | JSONObject(obj) =>
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
}

let parseFromBuffer = messageBuffer => {
  open Util
  open TextDecoder
  let dataView = DataView.make(messageBuffer)
  let decoder = TextDecoder.make()
  decoder->decode(dataView)->parseFromString
}
