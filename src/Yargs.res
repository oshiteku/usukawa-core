type yargsArgv = {
    port: string
}

type yargs = {
    argv: yargsArgv
}

@module external yargs: array<string> => yargs = "yargs/yargs"

@module("yargs/helpers") external hideBin: array<string> => array<string> = "hideBin"

type argv = {
    port: int
}

let getArgv = (yargs: yargs) => {
    open Belt

    let { port } = yargs.argv
    {
        port: port->Int.fromString->Option.getWithDefault(5555)
    }
}
