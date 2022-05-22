package mempoolrecorder

import (
  "dagger.io/dagger"
  "github.com/rabot-crypto/dotnet"
)

dagger.#Plan & {
  client: {
    filesystem: {
      "./project": read: contents: dagger.#FS
      "./artifacts": write: contents: actions.pack.export.directories[dotnet.#DefaultPackDirectory]
    }
  }

  actions: {
    restore: dotnet.#Instruct.#Restore & {
      copyStep: {
        solutionCopy: {
          contents: client.filesystem."./project".read.contents
        }
      }
      restoreStep: {
        dotnet: verbosity: "d"
        always: true
      }
    }

    build: dotnet.#Run.#Build & {
      input: restore.output
    }

    pack: dotnet.#Run.#Pack & {
      input: build.output
    }

    publish: dotnet.#Run.#Publish & {
      input: build.output
    }
	}
}