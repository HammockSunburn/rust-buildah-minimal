# Rust Buildah Example

This shows an example of using [Buildah](https://buildah.io/) on Fedora to build a minimal Rust application into an Alpine Linux base image using [musl libc](https://www.musl-libc.org/).

The `build_image.sh` script contains comments explaining the process of building the container image using `buildah`. This generates a container image of about 15.7 MB. This takes just over 1 minute on a 6-core 9600k desktop machine. You can run the `build_image.sh` script as a non-root user inside of an unshare:

```shell
buildah unshare ./build_image.sh
```

The `run_dev_image.sh` script runs the image using `podman` and links in the `dev.toml` file so the simple Rust program can read it.
