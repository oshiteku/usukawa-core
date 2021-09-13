type winston

@module("winston") external winston: unit => winston = "default"

type logger
type transport
type loggerOptions = {
    @optional
    transports: array<transport>
}

@module("winston") external createLogger: loggerOptions => logger = "createLogger"

type logRecord = {
    level: string,
    message: string
}

@send external log: (logger, logRecord) => unit = "log"

module Transports = {
  @new @module("winston") @scope("transports") external console: unit => transport = "Console"
}
