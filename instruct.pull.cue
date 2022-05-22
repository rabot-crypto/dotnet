package dotnet

import (
    "dagger.io/dagger"
    "universe.dagger.io/docker"
)

#Instruct: {
    _#havingSourceFromConcatenation: {
        {
            domain: string | *"mcr.microsoft.com"
            name: string & !=""
            source: domain + "/" + name
        } | {
            source: dagger.#Ref
        }
    }

    #Pull: {
        _#havingSourceFromConcatenation
        docker.#Pull
    }
}