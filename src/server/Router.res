open UWebSockets

let versionString = "usukawa v0.1.0"

type request = Request({path: string})

let process = (res, req) => {
  let req = Request({
    path: req->getUrl,
  })

  switch req {
  | Request({path: "/"}) => res->writeStatus("200 OK")->end(versionString)
  | Request(_) => res->writeStatus("404 Not Found")->end("not found")
  }
}
