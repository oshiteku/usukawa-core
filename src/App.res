open UWebSockets
open Yargs
open Winston

let ws_endpoint_path = "hogehoge"

let logger = createLogger({
  transports: [
    Transports.console()
  ]
})

let argv = yargs(hideBin(Util.argv))->getArgv

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
->listen(argv.port, _listenSocket => {
  open Belt
  logger->log({
    level: "info",
    message: `listen: ${argv.port->Int.toString}`
  })
})
