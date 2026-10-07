#!/bin/sh
# SPDX-License-Identifier: BSD-2-Clause
# Copyright (c) 2026 REVYTECH, Inc.
#
# Build FreeBSD 16 Aeolus demo images (run on FreeBSD/CloudBSD with podman|buildah).
# Usage: scripts/build-all.sh [image...]
# Env: BASE, REGISTRY, TAG, OUTDIR, BUILDER (podman|buildah)

set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
BASE=${BASE:-ghcr.io/freebsd/freebsd-runtime:16.snap}
REGISTRY=${REGISTRY:-ghcr.io/cloudbsdorg}
TAG=${TAG:-16}
OUTDIR=${OUTDIR:-"$ROOT/out"}
BUILDER=${BUILDER:-}
export BUILDAH_ISOLATION=${BUILDAH_ISOLATION:-chroot}

if [ -z "$BUILDER" ]; then
	if command -v podman >/dev/null 2>&1; then
		BUILDER=podman
	elif command -v buildah >/dev/null 2>&1; then
		BUILDER=buildah
	else
		echo "need podman or buildah" >&2
		exit 1
	fi
fi

# name -> images/<dir>
ALL='mariadb wordpress memcached redis gitea nextcloud jellyfin emby-server'

pick=${*:-$ALL}
mkdir -p "$OUTDIR"

build_one() {
	name=$1
	dir="$ROOT/images/$name"
	[ -f "$dir/Containerfile" ] || {
		echo "missing $dir/Containerfile" >&2
		return 1
	}
	ref="${REGISTRY}/aeolus-${name}:${TAG}"
	echo "==> build $ref (BASE=$BASE)"
	case "$BUILDER" in
	podman)
		podman build --squash \
			--build-arg "BASE=$BASE" \
			-t "$ref" \
			-f "$dir/Containerfile" "$dir"
		;;
	buildah)
		buildah bud --squash \
			--build-arg "BASE=$BASE" \
			-t "$ref" \
			-f "$dir/Containerfile" "$dir"
		;;
	*)
		echo "unknown BUILDER=$BUILDER" >&2
		return 1
		;;
	esac
	tar="$OUTDIR/aeolus-${name}-${TAG}.tar"
	echo "==> save $tar"
	$BUILDER save -o "$tar" "$ref"
	echo "$ref" >>"$OUTDIR/built-refs.txt"
	ls -lh "$tar"
}

: >"$OUTDIR/built-refs.txt"
for name in $pick; do
	build_one "$name"
done

echo "done. archives in $OUTDIR"
cat "$OUTDIR/built-refs.txt"
