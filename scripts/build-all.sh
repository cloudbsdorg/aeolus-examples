#!/bin/sh
# SPDX-License-Identifier: BSD-2-Clause
# Copyright (c) 2026 REVYTECH, Inc.
#
# Build FreeBSD 16 Aeolus demo images on FreeBSD/CloudBSD as root.
# Uses buildah mount + chroot (podman/buildah RUN hits FreeBSD stdin-pipe chown bug).
#
# Usage: sudo scripts/build-all.sh [image...]
# Env: BASE, REGISTRY, TAG, OUTDIR
#
# Lab note: mounts host devfs into the image root for pkg(8). Run only on a
# trusted builder with trusted Containerfiles (same host that publishes).

set -eu

[ "$(id -u)" -eq 0 ] || {
	echo "run as root (sudo)" >&2
	exit 1
}

ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
BASE=${BASE:-ghcr.io/freebsd/freebsd-runtime:16.snap}
# Our registry (GitHub/GHCR is not the publish plane — FreeBSD builds here).
REGISTRY=${REGISTRY:-oci.cloudbsd.org}
TAG=${TAG:-16}
OUTDIR=${OUTDIR:-"$ROOT/out"}
ALL="nginx apache24 haproxy caddy traefik squid stunnel kafka zookeeper rabbitmq nats mosquitto postgresql16 postgresql17 redis mariadb memcached minio meilisearch opensearch mattermost mastodon gotosocial matrix-synapse jitsi-meet ollama llama-cpp whisper-cpp comfyui litellm plex plex-plexpass jellyfin emby-server navidrome sonarr radarr lidarr prowlarr bazarr readarr calibre qbittorrent transmission sabnzbd unifi syncthing nextcloud zoneminder piwigo bacula-server gitea forgejo vaultwarden keycloak wordpress grafana prometheus netdata uptime-kuma homepage"

case "$TAG" in
*[!A-Za-z0-9._-]*)
	echo "invalid TAG=$TAG" >&2
	exit 1
	;;
esac

packages_for() {
	name=$1
	cf="$ROOT/images/$name/Containerfile"
	[ -f "$cf" ] || {
		echo "missing $cf; add ARG packages= or check the image name" >&2
		return 1
	}
	sed -n 's/^ARG packages=//p' "$cf" | head -1
}

cleanup_cid() {
	cid=${1:-}
	mnt=${2:-}
	[ -n "$cid" ] || return 0
	if [ -n "$mnt" ] && [ -d "$mnt/dev" ]; then
		umount "$mnt/dev/fd" 2>/dev/null || true
		umount "$mnt/dev" 2>/dev/null || true
	fi
	buildah unmount "$cid" 2>/dev/null || true
	buildah rm "$cid" 2>/dev/null || true
}

on_exit() {
	ec=$?
	trap - EXIT INT TERM
	cleanup_cid "${AEOLUS_BUILD_CID:-}" "${AEOLUS_BUILD_MNT:-}"
	exit "$ec"
}

on_signal() {
	sig=$1
	trap - EXIT INT TERM
	cleanup_cid "${AEOLUS_BUILD_CID:-}" "${AEOLUS_BUILD_MNT:-}"
	exit "$sig"
}

build_one() {
	name=$1
	case "$name" in
	*[!a-z0-9-]*)
		echo "invalid image name: $name" >&2
		return 1
		;;
	esac
	case " $ALL " in
	*" $name "*) ;;
	*)
		echo "unknown image: $name (valid: $ALL)" >&2
		return 1
		;;
	esac

	packages=$(packages_for "$name")
	[ -n "$packages" ] || {
		echo "Missing ARG packages= in images/$name/Containerfile; add the package list" >&2
		return 1
	}
	set -f
	for pkg in $packages; do
		case "$pkg" in
		*[!A-Za-z0-9+_.-]*)
			echo "refusing unsafe package token: $pkg" >&2
			set +f
			return 1
			;;
		esac
	done
	set +f

	ref="${REGISTRY}/aeolus-${name}:${TAG}"
	cid="aeolus-build-${name}-$$"
	echo "==> build $ref (packages: $packages)"

	AEOLUS_BUILD_CID=$cid
	AEOLUS_BUILD_MNT=
	export AEOLUS_BUILD_CID AEOLUS_BUILD_MNT
	trap on_exit EXIT
	trap 'on_signal 130' INT
	trap 'on_signal 143' TERM

	buildah rm "$cid" 2>/dev/null || true
	buildah from --name "$cid" "$BASE" >/dev/null
	mnt=$(buildah mount "$cid")
	AEOLUS_BUILD_MNT=$mnt

	mount -t devfs devfs "$mnt/dev"
	cp /etc/resolv.conf "$mnt/etc/resolv.conf"

	chroot "$mnt" env ASSUME_ALWAYS_YES=yes /usr/sbin/pkg bootstrap -y -r FreeBSD
	chroot "$mnt" /usr/sbin/pkg -o IGNORE_OSVERSION=yes update -f
	# validated tokens only; no shell metacharacters
	# shellcheck disable=SC2086
	chroot "$mnt" /usr/sbin/pkg install -y $packages
	chroot "$mnt" /usr/sbin/pkg clean -ay
	chroot "$mnt" /usr/sbin/pkg delete -fy pkg
	chroot "$mnt" /bin/rm -rf /var/db/pkg/repos

	umount "$mnt/dev" 2>/dev/null || true
	buildah unmount "$cid"
	buildah commit --squash "$cid" "$ref"
	buildah rm "$cid"
	AEOLUS_BUILD_CID=
	AEOLUS_BUILD_MNT=
	trap - EXIT INT TERM

	tar="$OUTDIR/aeolus-${name}-${TAG}.tar"
	case "$tar" in
	"$OUTDIR"/*) ;;
	*)
		echo "refusing tar path outside OUTDIR: $tar" >&2
		return 1
		;;
	esac
	echo "==> save $tar"
	podman save -o "$tar" "$ref"
	echo "$ref" >>"$OUTDIR/built-refs.txt"
	ls -lh "$tar"
}

command -v buildah >/dev/null || {
	echo "buildah is required; install with: pkg install -y buildah" >&2
	exit 1
}
command -v podman >/dev/null || {
	echo "podman is required; install with: pkg install -y podman" >&2
	exit 1
}

mkdir -p "$OUTDIR"
: >"$OUTDIR/built-refs.txt"

podman image exists "$BASE" || podman pull "$BASE"

pick=${*:-$ALL}
set -f
for name in $pick; do
	set +f
	build_one "$name"
	set -f
done
set +f

echo "done. archives in $OUTDIR"
cat "$OUTDIR/built-refs.txt"
