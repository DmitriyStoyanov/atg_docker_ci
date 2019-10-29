#!/bin/bash
docker build --rm -t local/atg_docker_ci:ci -f Dockerfile .
docker build --rm -t local/atg_docker_ci:ci-shaper -f Dockerfile_shaper .
docker build --rm -t local/atg_docker_ci:ci-jdk8 -f Dockerfile_ci-jdk8 .