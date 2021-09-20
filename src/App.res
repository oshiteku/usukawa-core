open UWebSockets
open Yargs
open Winston

let logger = createLogger({
  transports: [
    Transports.console()
  ]
})

let argv = yargs(hideBin(Util.argv))->getArgv
let apiPath = `/ws/${argv.apiKey}`
let apiUrl = `ws://localhost:${argv.port->Belt.Int.toString}${apiPath}`

let app = app()
let _ = app
->get("/*", (res, req) => {
  let _ = Router.process(res, req)
})
->ws(
  apiPath,
  {
    message: MessageHandler.make(app),
  },
)
->listen(argv.port, _listenSocket => {
  logger->log({
    level: "info",
    message: `listen: ${apiUrl}`
  })
})
