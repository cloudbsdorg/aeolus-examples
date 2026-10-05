# Aeolus examples — FreeBSD 16 OCI images

Public recipes for **FreeBSD 16** demo images used with [Aeolus](https://aeolus.cloudbsd.org/).
Linux Hub tags are **not** the story — these images are FreeBSD packages on
[`ghcr.io/freebsd/freebsd-runtime:16.snap`](https://ghcr.io/freebsd/freebsd-runtime:16.snap).

| Image | Packages (approx.) | Tag |
|-------|--------------------|-----|
| `aeolus-mariadb` | mariadb1011-server | `ghcr.io/cloudbsdorg/aeolus-mariadb:16` |
| `aeolus-wordpress` | nginx php85-* wordpress | `ghcr.io/cloudbsdorg/aeolus-wordpress:16` |
| `aeolus-memcached` | memcached | `ghcr.io/cloudbsdorg/aeolus-memcached:16` |
| `aeolus-redis` | redis | `ghcr.io/cloudbsdorg/aeolus-redis:16` |

## Build (FreeBSD / CloudBSD host with podman or buildah)

```sh
# Example: mariadb layer
podman build --squash \
  --build-arg BASE=ghcr.io/freebsd/freebsd-runtime:16.snap \
  -t ghcr.io/cloudbsdorg/aeolus-mariadb:16 \
  -f images/mariadb/Containerfile images/mariadb

# Or use the upstream pkg-extend pattern:
#   share/examples/oci/Containerfile.pkg in cloudbsd-src
```

Rebuild the base runtime yourself via FreeBSD `release/Makefile.oci` /
`WITH_OCIIMAGES=1` when you need a local CA or pinned tip — see FreeBSD Handbook
ch. 18 and `cloudbsd-src/release/scripts/make-oci-image.sh`.

## Ensemble

See [`ensembles/blog/ensemble.yml`](ensembles/blog/ensemble.yml) — `namespace: demo`,
default pod `aeolus-blog-default`, FreeBSD 16 image refs, Ladon `secretRef` comments.

Secrets: [Ladon](https://ladon.revytechinc.com/) (`ladon.cloudbsd.org` redirects).

## Smoke bundles

`bundles/` documents how to mint tiny OCI bundles (`true` / `sleep` / `echo`) from
the FreeBSD 16 runtime rootfs for `aeolus create` lifecycle demos.
