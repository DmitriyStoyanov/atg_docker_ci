#!/bin/bash
docker build --rm -t local/atg_docker_ci:ci -f Dockerfile .
docker build --rm -t local/atg_docker_ci:ci-shaper -f Dockerfile_shaper .
