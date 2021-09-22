open UWebSockets
open Yargs
open Winston

let logger = createLogger({
  transports: [
    Transports.console()
  ]
})

let argv = yargs(hideBin(Util.argv))->getArgv

let main = (apiKey, port) => {
  let apiPath = `/ws/${apiKey}`
  let apiUrl = `ws://localhost:${port->Belt.Int.toString}${apiPath}`

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
  ->listen(port, _listenSocket => {
    logger->log({
      level: "info",
      message: `listen: ${apiUrl}`
    })
  })
}

{
  open Promise
  let apiKey = switch argv.apiKey {
  | Some(k) => resolve(k)
  | None => resolve(Util.randomString(16))
  }
  let port = switch argv.port {
  | Some(p) => resolve(p)
  | None => Util.Net.findFreePort()
  }
  all2((apiKey, port))
  ->then(((k, p)) => {
    main(k, p)
    resolve()
  })
  ->ignore
}
