package dotnet

_#havingDotnetBasicProps: {
    _#defaultCommandName: "dotnet"
    project?: string
    dotnet: verbosity: #DotnetVerbosity | *"minimal"
    args?:  [...string]
}

_#calculateDotneBasictProps: {
    project?: _
    dotnet: _
    args?: _
    
    _basicArgs: _ | *[
        "--verbosity",
        "\(dotnet.verbosity)",

        
        if project != _|_ {project}, 
        if args != _|_ for x in args {x}
    ]

    command: name: _ | *_#havingDotnetBasicProps._#defaultCommandName
}