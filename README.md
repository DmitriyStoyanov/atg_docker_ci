# ATG Docker CI

## Repository description

This repository contain the Dockerfile to create CI process on ATG 11.2 patch 11.2.0.2 fixpack 1

## Docker build

### 1. To create docker container next additional files should be placed in folder with Dockerfile:

* jdk-7u181-linux-x64.rpm (Oracle JDK for build process)
* V78217-01.zip (Oracle Commerce 11.2 Platform)
* p24950065_112000_Generic.zip (Oracle Commerce 11.2.0.2 patch)
* p25404313_112020_Generic.zip (Oracle Commerce 11.2.0.2 fixpack 1)

### 2. Build container

```console
$ docker build --rm -t local/atg_docker_ci .
```

### 3. Run container

```console
$ docker run -it --rm --name atg_docker_ci local/atg_docker_ci
```
