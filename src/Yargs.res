type yargsArgv = {
    port: option<string>,
    apiKey: option<string>
}

type yargs = {
    argv: yargsArgv
}

@module external yargs: array<string> => yargs = "yargs/yargs"

@module("yargs/helpers") external hideBin: array<string> => array<string> = "hideBin"

type argv = {
    port: int,
    apiKey: string
}

let getArgv = (yargs: yargs) => {
    open Belt

    let { port, apiKey } = yargs.argv
    {
        port: port->Option.getWithDefault("")->Int.fromString->Option.getWithDefault(5555),
        apiKey: apiKey->Option.getWithDefault(Util.randomString(16))
    }
}
