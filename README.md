# Aeolus examples — FreeBSD 16 OCI images

Public **source** recipes for FreeBSD 16 demo images used with
[Aeolus](https://aeolus.cloudbsd.org/). GitHub holds the stash only — **builds and
the image registry run on our infra** (freedev / Jenkins / fleet registry).

Base runtime (upstream public):  
[`ghcr.io/freebsd/freebsd-runtime:16.snap`](https://ghcr.io/freebsd/freebsd-runtime:16.snap).

**Full inventory:** [`CATALOG.md`](CATALOG.md).

## Catalog highlights

| Area | Examples |
|------|----------|
| Edge / proxies | nginx, apache24, haproxy, caddy, traefik, squid, stunnel |
| Data / messaging | kafka (+ zookeeper), rabbitmq, nats, mosquitto, postgres 16/17, redis, minio, meilisearch, opensearch |
| Collab / social | mattermost, mastodon (+ stack), gotosocial, matrix-synapse, jitsi-meet |
| AI | ollama, llama-cpp, whisper-cpp, comfyui, litellm (+ `ensembles/ai-stack`) |
| Media / *arr | plex (+ plexpass), jellyfin, emby, navidrome, sonarr/radarr/lidarr/prowlarr/bazarr/readarr, calibre |
| Downloaders | qbittorrent, transmission, sabnzbd |
| Network / NAS-class | **unifi** (unifi10), syncthing, nextcloud, zoneminder, piwigo, bacula-server |
| Dev / security | gitea, forgejo, vaultwarden, keycloak |
| Observe | grafana, prometheus, netdata, uptime-kuma, homepage |
| Baseline blog | wordpress, mariadb, memcached, redis |

Gaps (no FreeBSD pkg yet): Home Assistant, Open WebUI, Airsonic→use navidrome, PeerTube (deps image + docs). See CATALOG.md.

## Build & publish (our FreeBSD builders)

GitHub does not build FreeBSD. Hooks there only keep Track + code review honest.
Build and push on our hosts:

```sh
# On a FreeBSD/CloudBSD builder (root):
sudo scripts/build-all.sh                 # → out/aeolus-*-16.tar + local tags
sudo scripts/build-all.sh ollama unifi nginx

# Push to our OCI registry (default REGISTRY=oci.cloudbsd.org):
sudo scripts/push-registry.sh
sudo scripts/push-registry.sh ollama unifi
```

Tag shape: `${REGISTRY}/aeolus-<name>:16`.

## Manual Containerfile notes

Upstream pkg-extend pattern: `share/examples/oci/Containerfile.pkg` in
cloudbsd-src. Rebuild the FreeBSD runtime via `release/Makefile.oci` /
`WITH_OCIIMAGES=1` when you need a local CA or pinned tip — Handbook ch. 18.

## Ensembles

Single-app YAML under [`ensembles/<name>/`](ensembles/). Stacks:

- [`ensembles/blog`](ensembles/blog/ensemble.yml) — WordPress HA-shaped demo
- [`ensembles/mastodon-stack`](ensembles/mastodon-stack/ensemble.yml) — Mastodon + Postgres + Redis
- [`ensembles/kafka-stack`](ensembles/kafka-stack/ensemble.yml) — Kafka + ZooKeeper
- [`ensembles/ai-stack`](ensembles/ai-stack/ensemble.yml) — Ollama + LiteLLM

Composition / registry: Track #970 (includes), #973 (local ensemble registry).  
Secrets: [Ladon](https://ladon.revytechinc.com/).

## Smoke bundles

`bundles/` — tiny OCI bundles for `aeolus create` lifecycle demos.
