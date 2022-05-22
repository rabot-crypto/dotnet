package dotnet

import (
    "universe.dagger.io/docker"
)

#Run: {
    _#havingDotnetBuildProps: {
        _#havingDotnetNonRestoreProps
        dotnet: noRestore: _ | *true
        dotnet: output: _ | *#DefaultBuildDirectory
    }

    _#calculateDotnetBuildProps: {
        _#calculateDotnetNonRestoreProps
        _#dotnetOutputMutatesDockerRun

        _nonRestoreArgs: _

        // docker.#Run.command.args
        _buildArgs: _ | *[
            "build",
            if _nonRestoreArgs != _|_ for x in _nonRestoreArgs {x}
        ]

        command: args: _ | *_buildArgs
    }

    #Build: {
        _#havingDotnetBuildProps
        _#calculateDotnetBuildProps

        docker.#Run & {
            // command: name: "bash"
            // command: args: ["-c", "echo '/:'; ls /; echo '/root/.nuget:'; ls /root/.nuget; echo '/root/.nuget/packages:'; ls /root/.nuget/packages"]
            // command: args: ["-c", "ls /root/.nuget/packages/vernuntii.console.msbuild/0.1.0-alpha.5/tools/console/net6.0; dotnet /root/.nuget/packages/vernuntii.console.msbuild/0.1.0-alpha.5/tools/console/net6.0/Vernuntii.Console.dll"]
            // always: true
        }
    }
}