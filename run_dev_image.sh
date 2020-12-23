#!/bin/bash

podman run -d \
    --name my-rust-buildah-minimal \
    -v $PWD/dev.toml:/app/config.toml:z \
    rust-buildah-minimal
