type arrayBuffer

module DataView = {
    type t
    @new external make: arrayBuffer => t = "DataView"
}

module TextDecoder = {
    type t
    @new external make: unit => t = "TextDecoder"
    @send external: decode: (t, DataView.t) => string = "decode"
}

@scope("process") @val external argv: array<string> = "argv"

let rec randomString = (~acc="", n) => {
    let cs = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    let idx = Js.Math.random_int(0, cs->Js.String.length)
    let c = Js.String.charAt(idx, cs)
    if (n <= 0) {
        acc
    } else {
        randomString(~acc=acc ++ c, n - 1)
    }
}

module Net = {
    type server
    @module("net") external createServer: unit => server = "createServer"
    @send external on: (server, string, unit => unit) => unit = "on"
    @send external listen: (server, int, string) => unit = "listen"
    @send external close: server => unit = "close"

    type address = {
        port: int
    }
    @send external address: server => address = "address"

    let findFreePort = () => {
        Promise.make((resolve, _reject) => {
            let server = createServer()
            let port = ref(0)

            server->on("listening", () => {
                port := (server->address).port
                server->close
            })
            server->on("close", () => {
                resolve(. port.contents)
            })
            server->listen(0, "127.0.0.1")
        })
    }
}
