package dotnet

import (
    "dagger.io/dagger"
)

_#defaultSolutionDir: "/solution"

_#havingSolutionCopy: {
    workdirOrigin: *"default" | "workdir" | "solutionCopy"
        
    // solutionCopyName: _ | *"solution"

    solutionCopy: {
        contents: dagger.#FS
    }
}

_#calculateSolutionCopy: {
    workdirOrigin: _
    solutionCopy: _
    workdir: _

    if workdirOrigin =~ "default" {
        workdir: _#defaultSolutionDir
        solutionCopy: dest: _#defaultSolutionDir
    }

    if workdirOrigin =~ "workdir" {
        workdir: _
        solutionCopy: dest: workdir
    }

    if workdirOrigin =~ "solutionCopy" {
        solutionCopy: dest: _
        workdir: solutionCopy.dest
    }
}