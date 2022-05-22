package dotnet

import (
    // "dagger.io/dagger"
    // "dagger.io/dagger/core"
    "universe.dagger.io/docker"
)

#Run: {
    _#havingDotnetPublishProps: {
        _#havingDotnetBasicProps
        dotnet: noRestore: _ | *true
        dotnet: output: _ | *#DefaultPublishDirectory
    }

    _#calculateDotnetPublishProps: {
        _#calculateDotnetNonRestoreProps
        _#dotnetOutputMutatesDockerRun

        _nonRestoreArgs: _

        // docker.#Run.command.args
        _buildArgs: _ | *[
            "publish",
            if _nonRestoreArgs != _|_ for x in _nonRestoreArgs {x}
        ]

        command: args: _ | *_buildArgs
    }

    #Publish: self = {
        _#havingDotnetPublishProps
        _#calculateDotnetPublishProps

        docker.#Run & {
            input: self.input
            // command: name: "bash"
            // command: args: ["-c", "echo '/:'; ls /; echo '/root/.nuget:'; ls /root/.nuget; echo '/root/.nuget/packages:'; ls /root/.nuget/packages"]
            // command: args: ["-c", "ls /root/.nuget/packages/vernuntii.console.msbuild/0.1.0-alpha.5/tools/console/net6.0; dotnet /root/.nuget/packages/vernuntii.console.msbuild/0.1.0-alpha.5/tools/console/net6.0/Vernuntii.Console.dll"]            
        }
    }
}