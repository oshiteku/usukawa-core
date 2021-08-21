let handleMessage = (app, ws, messageBuffer, _isBinary) => {
  let message = Message.parseFromBuffer(messageBuffer)
  let _ = switch message {
  | GeneralMessage({topic}) => app->UWebSockets.publish(topic, messageBuffer, false, false)
  | SubscribeRequest({topic}) => ws->UWebSockets.subscribe(topic)
  }
}

let make = app => {
  (ws, messageBuffer, isBinary) => {
    try handleMessage(app, ws, messageBuffer, isBinary) catch {
    | e => Js.log(e)
    }
  }
}
