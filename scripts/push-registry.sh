#!/bin/sh
# SPDX-License-Identifier: BSD-2-Clause
# Copyright (c) 2026 REVYTECH, Inc.
#
# Push locally built aeolus-*:TAG images to our OCI registry (FreeBSD builder).
# GitHub is source stash only — no Actions, no GHCR-as-SoT.
#
# Usage: sudo REGISTRY=oci.cloudbsd.org scripts/push-registry.sh [image...]
# Prereq: scripts/build-all.sh already tagged images as ${REGISTRY}/aeolus-<name>:${TAG}

set -eu

[ "$(id -u)" -eq 0 ] || {
	echo "run as root (sudo)" >&2
	exit 1
}

ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
# shellcheck disable=SC1091
# Reuse ALL list from build-all by sourcing the assignment only.
ALL=$(awk -F'"' '/^ALL="/{print $2; exit}' "$ROOT/scripts/build-all.sh")
[ -n "$ALL" ] || { echo "could not read ALL from build-all.sh" >&2; exit 1; }
REGISTRY=${REGISTRY:-oci.cloudbsd.org}
TAG=${TAG:-16}
pick=${*:-$ALL}

command -v podman >/dev/null || {
	echo "podman is required; install with: pkg install -y podman" >&2
	exit 1
}

set -f
for name in $pick; do
	set +f
	case "$name" in
	*[!a-z0-9-]*)
		echo "invalid image name: $name" >&2
		exit 1
		;;
	esac
	ref="${REGISTRY}/aeolus-${name}:${TAG}"
	if ! podman image exists "$ref"; then
		echo "missing local image: $ref (run scripts/build-all.sh $name first)" >&2
		exit 1
	fi
	echo "==> push $ref"
	podman push "$ref"
	set -f
done
set +f

echo "done"
