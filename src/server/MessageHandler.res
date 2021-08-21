let handleMessage = (ws, messageBuffer, _isBinary) => {
  let message = Message.parseFromBuffer(messageBuffer)
  let _ = switch message {
  | GeneralMessage({topic, data}) => ws->UWebSockets.publish(topic, data, false, false)
  | SubscribeRequest({topic}) => ws->UWebSockets.subscribe(topic)
  }
}

let process = (ws, messageBuffer, isBinary) => {
  try handleMessage(ws, messageBuffer, isBinary) catch {
  | e => Js.log(e)
  }
}
