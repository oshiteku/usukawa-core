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
    if (n < 0) {
        acc
    } else {
        randomString(~acc=acc ++ c, n - 1)
    }
}
