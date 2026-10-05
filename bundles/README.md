# Smoke OCI bundles

Mint minimal bundles from a FreeBSD 16 runtime rootfs for `aeolus create` /
lifecycle demos (true, sleep, echo).

```sh
# Sketch — extract runtime, add config.json + rootfs, tar as OCI bundle
BASE=ghcr.io/freebsd/freebsd-runtime:16.snap
# podman create --name fbsd16 "$BASE"
# podman export fbsd16 | tar -C rootfs -xf -
# … write config.json process.args=["/bin/sleep","3600"] …
```

Lab helpers that *copy* existing seed bundles live in cloudbsd-src
`tools/aeolus/mk-*.sh` — this directory is the public recipe side.
