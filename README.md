# runme - Execute a GitHub repo

I use Unraid as a home server:

- I have code I'd like to run from a private GitHub repo.
- I don't want to self-host a docker registry for builds.
- I don't want a step between my code and Unraid.

`runme` is a tool made for purpose: to allow me to start a boilerplate container (configured locally - credentials included - in Unraid), that can access private code (hosted at GitHub), and run it:

- `runme` can execute Shell, Go and Rust projects.
- `runme` executes inside an Alpine docker container.
- `runme` docker images support `amd64` and `arm64`.
- `runme` supports various [Go, Rust and Alpine](https://hub.docker.com/repository/docker/karalabe/runme/tags) versions:
  - Shell images are tagged `shell-alpineI.J` (`I.J` optional).
  - Go images are tagged `golangX.Y.Z-alpineI.J` (`X.Y.Z`, `Z`, `I.J` optional).
  - Rust images are tagged `rustX.Y.Z-alpineI.J` (`X.Y.Z`, `Z`, `I.J` optional).

*`runme` does not call docker itself, that step is your task.*

TL;DR

```sh
docker run \
  -e GITHUB_USER=karalabe \
  -e GITHUB_REPO=runme \
  -e RUNME_TARGET=example/hello-world-rust \
  karalabe/runme:rust-alpine
  
[...]

Hello, Rust!
```

## How to use

Unraid's default mode of operation is to configure docker images from its web UI. This is elegant because it makes the system declarative, where you can restore it from a tiny config file instead of a whole live OS. `runme` fits into this model, where the base image is hosted on the public docker hub that you just add to Unraid and configure evrything via env vars.

The `runme` container is controlled via env vars:

- `GITHUB_USER`: The repository owner to execute from.
- `GITHUB_REPO`: The repository to execute code from.
- `GITHUB_AUTH`: Personal Access Token (private repos).
- `RUNME_BRANCH`: Git branch to check out before running.
- `RUNME_TARGET`: Path to the package or file to run:
  - Shell: path to the `.sh` file to execute.
  - Go: path to the `.go` file or Go package to execute.
  - Rust: path to the project to execute.

To avoid re-cloning the entire repo on startup, map `/workdir` to you host.

***Note, `runme` will check out the repository and leave it all (GitHub credentials included) reachable for the executing code. This is deliberate to allow the code to make changes to itself and push them back to GitHub.***

## Note to self

- Build all images: `make build`
- Clean all images: `make clean`
- Push all images: `make push`
