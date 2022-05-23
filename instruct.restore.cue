package dotnet

import (
    "dagger.io/dagger"
    // "dagger.io/dagger/core"
    "universe.dagger.io/docker"
)

#Instruct: {
    _#calculateSolutionCopyStep: {
        solutionCopy: _
        contents: solutionCopy.contents
        dest: solutionCopy.dest
    }

    _#havingDotnetRestoreProps: {
        _#havingDotnetBasicProps
        _#havingDotnetNonRestoreProps
    }

    _#calculateDotnetRestoreProps: {
        _#calculateDotneBasictProps
        _#calculateDotnetNonRestoreProps

        _basicArgs: _
        _nonRestoreArgs: _

        _restoreArgs: _ | *[
            "restore",
            if _basicArgs != _|_ for x in _basicArgs {x}
            if _nonRestoreArgs != _|_ for x in _nonRestoreArgs {x}
        ]

        command: args: _ | *_restoreArgs
    }

    #Restore: self = {
        _#optionalStepInput
        _inputOrPullInput?: dagger.#FS

        if self.input != _|_ {
            _inputOrPullInput: self.input
        }

        if self.input == _|_ {
            pullStep: #Instruct.#Pull & {
                name: _ | *"dotnet/sdk:6.0"
            }

            _inputOrPullInput: pullStep.output
        }

        solutionCopyStep: self = {
            _#havingSolutionCopy
            _#calculateSolutionCopy
            _#calculateSolutionCopyStep

            workdirStep: {
                docker.#Set & {
                    input: _inputOrPullInput
                    config: workdir: self.workdir
                }
            }

            docker.#Copy & {
                input: workdirStep.output
            }
        }

        restoreStep: {
            _#requiredStepInput
            _#havingDotnetRestoreProps
            _#calculateDotnetRestoreProps

            docker.#Run & {
                input: _ | *solutionCopyStep.output
                // command: args: ["-c", "dotnet restore; echo '/ ->'; ls /; echo '/root/.nuget:'; ls /root/.nuget; echo '/root/.nuget/fallbackpackages:'; ls /root/.nuget/fallbackpackages"]
                // command: args: ["-c", "dotnet restore; echo '/:'; ls /; echo '/root/.nuget:'; ls /root/.nuget; echo '/root/.nuget/packages:'; ls /root/.nuget/packages"]
                // command: name: "bash"
                // command: args: ["-c", "dotnet restore; dotnet build --no-restore; dotnet pack"]
                always: _ | *true
            }
        }

        output: restoreStep.output
    }
}
