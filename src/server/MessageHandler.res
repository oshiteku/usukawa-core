let processMessage = (_ws, messageBuffer, _isBinary) => {
  let message = Message.parseFromBuffer(messageBuffer)

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
