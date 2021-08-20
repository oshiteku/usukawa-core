open UWebSockets

let _ =
  app()
  ->get("/*", (res, req) => {
    let _ = Router.process(res, req)
  })
  ->ws("/*", {
    message: MessageHandler.process
  })
  ->listen(5555, _listenSocket => {
    Js.log("listen!")
  })
