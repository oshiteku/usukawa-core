open UWebSockets

let app = app()
let _ = app
->get("/*", (res, req) => {
  let _ = Router.process(res, req)
})
->ws(
  "/*",
  {
    message: MessageHandler.make(app),
  },
)
->listen(5555, _listenSocket => {
  Js.log("listen!")
})
