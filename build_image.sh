#!/bin/bash
set -e

if [ "$(whoami)" != "root" ]; then
    echo "script must be run as root"
    exit 1
fi

# The first container/mount is where we'll run the Rust build.
buildcntr1=$(buildah from rust:1.44)
buildmnt1=$(buildah mount $buildcntr1)

# Get the Rust build container ready to build with musl. The Rust container image is Debian based.
buildah run $buildcntr1 apt-get update
buildah run $buildcntr1 apt-get install musl-tools -y
buildah run $buildcntr1 rustup target add x86_64-unknown-linux-musl

# Copy in our code.
cp Cargo.toml Cargo.lock $buildmnt1
cp -R src $buildmnt1

# Run Cargo to do the build, using musl.
RUSTFLAGS=-Clinker=musl-gcc buildah run $buildcntr1 cargo build --release --target=x86_64-unknown-linux-musl

# The second container/mount is where we'll prepare our output container image.
buildcntr2=$(buildah from alpine)
buildmnt2=$(buildah mount $buildcntr2)

# We'll make a directory, /app, where we'll store our application binary.
mkdir -p $buildmnt2/app
cp $buildmnt1/target/x86_64-unknown-linux-musl/release/rust-buildah-minimal $buildmnt2/app/rust-buildah-minimal

# This is the command the container will run. It assumes a configuration .toml file will be available
# in /app/config.toml. This file isn't included in the container --- it's expected that we will specify
# this at container start time.
buildah config --cmd "/app/rust-buildah-minimal -c /app/config.toml" $buildcntr2

# Clean up.
buildah umount $buildcntr2
buildah commit $buildcntr2 rust-buildah-minimal:latest
buildah rm $buildcntr1 $buildcntr2

