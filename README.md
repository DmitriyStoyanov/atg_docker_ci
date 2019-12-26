# ATG Docker CI

## Repository description

This repository contains the Dockerfiles to create docker images for CI process on ATG 11.2 patch 11.2.0.2 fixpack 1
and for the same image + shaper tool

## Docker build

### 1. Build docker containers

```console
$ docker build --rm -t local/atg_docker_ci:ci .
$ docker build --rm -t local/atg_docker_ci:ci-shaper -f Dockerfile_shaper .
```

### 2. Run containers

```console
$ docker run -it --rm --name atg_docker_ci local/atg_docker_ci:ci
$ docker run -it --rm --name atg_docker_ci local/atg_docker_ci:ci-shaper
```
