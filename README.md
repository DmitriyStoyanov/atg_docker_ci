# ATG Docker CI

## Repository description

This repository contain the Dockerfile to create CI process on ATG 11.2 patch 11.2.0.2 fixpack 1

## Docker build

### 1. Build docker container

```console
$ docker build --rm -t local/atg_docker_ci .
```

### 2. Run container

```console
$ docker run -it --rm --name atg_docker_ci local/atg_docker_ci
```
