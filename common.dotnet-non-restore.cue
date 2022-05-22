package dotnet

import (
    // "dagger.io/dagger"
    // "dagger.io/dagger/core"
)

_#havingDotnetNonRestoreProps: {
    _#havingDotnetBasicProps
    dotnet: output?: string
    dotnet: noRestore?: bool
}

_#calculateDotnetNonRestoreProps: self = {
    _#calculateDotneBasictProps

    _basicArgs: _

    // docker.#Run.command.args
    _nonRestoreArgs: _ | *[
        if _basicArgs != _|_ for x in _basicArgs {x}
        if self.dotnet.noRestore {"--no-restore"}
        if self.dotnet.output != _|_ {"--output"}
        if self.dotnet.output != _|_ {"\(self.dotnet.output)"}
    ]
}

_#dotnetOutputMutatesDockerRun: {
    dotnet: output: _
    export: directories: "\(dotnet.output)": _
}