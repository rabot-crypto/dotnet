package dotnet

import (
    "dagger.io/dagger/core"
    "universe.dagger.io/docker"
)

#DotnetVerbosity: "q" | "m" | "n" | "d" | "diag" | "quit" | "minimal" | "detailed" | "diagnostic"

#DefaultBuildDirectory: "/app/build"
#DefaultPackDirectory: "/app/pack"
#DefaultPublishDirectory: "/app/publish"

_#requiredStepInput: {
    input: docker.#Image
}

_#optionalStepInput: {
    input?: docker.#Image
}

_#stepOutput: {
    output: docker.#Image
}

_#dockerMountObject : core.#Mount