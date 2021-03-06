open Util

type uwebsockets

@module("uWebSockets.js") external uwebsockets: unit => uwebsockets = "default"

type templatedApp

@module("uWebSockets.js") external app: unit => templatedApp = "App"

@send external publish: (templatedApp, string, arrayBuffer, bool, bool) => bool = "publish"

type res
type req

type handler = (res, req) => unit

@send external get: (templatedApp, string, handler) => templatedApp = "get"
@send external writeStatus: (res, string) => res = "writeStatus"
@send external end: (res, string) => res = "end"

@send external getUrl: req => string = "getUrl"

type listenSocket

@send external listen: (templatedApp, int, listenSocket => unit) => templatedApp = "listen"

type websocket

@send external subscribe: (websocket, string) => bool = "subscribe"

type websocketBehavior = {
    message: (websocket, arrayBuffer, bool) => unit
}

@send external ws: (templatedApp, string, websocketBehavior) => templatedApp = "ws"
