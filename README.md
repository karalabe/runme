# runme - Execute a GitHub repo

This is a tiny utility to clone a (potentially private) GitHub repository inside a docker container and execute its contents. Kind of like the Unix `exec`, just for a Github repo.

- `runme` can execute Shell, Go and Rust projects.
- `runme` executes inside an Alpine docker container.
- `runme` supports various Go, Rust and Alpine versions:
  - Shell images are tagged `shell-alpineI.J` (`I.J` optional).
  - Go images are tagged `golangX.Y.Z-alpineI.J` (`X.Y.Z`, `Z`, `I.J` optional).
  - Rust images are tagged `rustX.Y.Z-alpineI.J` (`X.Y.Z`, `Z`, `I.J` optional).

*`runme` does not call docker itself, that step is your problem.*

## TL;DR

```sh
docker run \
  -e GITHUB_USER=karalabe -e GITHUB_REPO=runme \
  karalabe/runme:shell-alpine example/hello-world-shell/main.sh
  
[...]

Hello, Shell!
```

## How to use

The `runme` target repo is controlled via env vars:

- `GITHUB_USER`: The repository owner to execute from.
- `GITHUB_REPO`: The repository to execute from.
- `GITHUB_AUTH`: Personal Access Token for private repos.

The `runme` target code is controlled via a single argument:

- Shell: path to the `.sh` file to execute.
- Go: path to the `.go` file to execute.
- Rust: path to the project to execute.

*`runme` will check out the repository and leave it all (GitHub credentials included) reachable for the executing code. This is deliberate to allow the code to make changes to itself and push them back to GitHub.*

If you want to avoid cloning the repository fresh on every container startup, map the `/workdir` folder from inside the container.

## But why?

I use Unraid as a home server:

- I have private code I'd like to run from private GitHub repositories.
- I don't want to host a private docker repository for prebuilds.
- I don't want to pay for docker to host code prebuilds.

`runme` is a tool made for purpose: to allow me to start a shell container (configured locally in Unraid) that can access private code (hosted at GitHub) and run it.

## Note to self

- Build all images: `make build`
- Clean all images: `make clean`
- Push all images: `make push`
