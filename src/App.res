open UWebSockets

let _ =
  app()
  ->get("/*", (res, req) => {
    let _ = res->writeStatus("200 OK")->end("usukawa v0.1.0")
    Js.log(req->getUrl)
  })
  ->listen(5555, _listenSocket => {
    Js.log("listen!")
  })
