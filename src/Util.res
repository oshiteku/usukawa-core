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
