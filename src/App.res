open UWebSockets
open Winston

let ws_endpoint_path = "hogehoge"

let logger = createLogger({
  transports: [
    Transports.console()
  ]
})

let app = app()
let _ = app
->get("/*", (res, req) => {
  let _ = Router.process(res, req)
})
->ws(
  `/ws/${ws_endpoint_path}`,
  {
    message: MessageHandler.make(app),
  },
)
->listen(5555, _listenSocket => {
  logger->log({
    level: "info",
    message: "listen: 5555"
  })
})
