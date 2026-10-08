# Aeolus examples catalog
FreeBSD 16 OCI image recipes + ensembles for Aeolus demos.
Tags: `oci.cloudbsd.org/aeolus-<name>:16` (override with `REGISTRY`).
Source on GitHub; **build/publish on our FreeBSD builders** (GitHub has no FreeBSD runners — hooks only for Track + review).
TrueNAS CORE plugins are obsolete; this list mirrors common NAS/lab apps that exist as FreeBSD packages.

## Edge / proxies

| Image | Package(s) | Port | Notes |
|-------|------------|------|-------|
| `aeolus-apache24` | `apache24` | 80 | Apache HTTP Server |
| `aeolus-caddy` | `caddy` | 80 | Automatic-HTTPS reverse proxy |
| `aeolus-haproxy` | `haproxy` | 8404 | TCP/HTTP load balancer |
| `aeolus-nginx` | `nginx` | 80 | HTTP reverse proxy / static |
| `aeolus-squid` | `squid` | 3128 | Caching forward proxy |
| `aeolus-stunnel` | `stunnel` | 443 | TLS wrapper |
| `aeolus-traefik` | `traefik` | 8080 | Cloud-native edge router |

## Data / messaging / search

| Image | Package(s) | Port | Notes |
|-------|------------|------|-------|
| `aeolus-kafka` | `kafka` | 9092 | Apache Kafka broker |
| `aeolus-meilisearch` | `meilisearch` | 7700 | Search engine |
| `aeolus-minio` | `minio` | 9000 | S3-compatible object storage |
| `aeolus-mosquitto` | `mosquitto` | 1883 | MQTT broker |
| `aeolus-nats` | `nats-server` | 4222 | NATS messaging |
| `aeolus-opensearch` | `opensearch` | 9200 | Search / analytics (Mastodon optional) |
| `aeolus-postgresql16` | `postgresql16-server` | 5432 | PostgreSQL 16 |
| `aeolus-postgresql17` | `postgresql17-server` | 5432 | PostgreSQL 17 |
| `aeolus-rabbitmq` | `rabbitmq` | 5672 | AMQP message broker |
| `aeolus-redis` | `redis` | 6379 | Redis |
| `aeolus-zookeeper` | `zookeeper` | 2181 | ZooKeeper (often with Kafka) |

## Collaboration

| Image | Package(s) | Port | Notes |
|-------|------------|------|-------|
| `aeolus-jitsi-meet` | `jitsi-meet` | 443 | Video conferencing |
| `aeolus-matrix-synapse` | `py312-matrix-synapse` | 8008 | Matrix homeserver |
| `aeolus-mattermost` | `mattermost-server` | 8065 | Team chat |

## Social (ActivityPub / Matrix)

| Image | Package(s) | Port | Notes |
|-------|------------|------|-------|
| `aeolus-gotosocial` | `gotosocial` | 8080 | Lightweight ActivityPub |
| `aeolus-mastodon` | `mastodon` | 3000 | ActivityPub social — needs Postgres+Redis |

## AI / ML

| Image | Package(s) | Port | Notes |
|-------|------------|------|-------|
| `aeolus-comfyui` | `comfyui` | 8188 | Node-based image gen UI |
| `aeolus-litellm` | `py312-litellm` | 4000 | LLM proxy / gateway |
| `aeolus-llama-cpp` | `llama-cpp` | 8080 | llama.cpp server |
| `aeolus-ollama` | `ollama` | 11434 | Local LLM runner |
| `aeolus-whisper-cpp` | `whisper.cpp` | 8080 | Local speech-to-text |

## Media servers & libraries

| Image | Package(s) | Port | Notes |
|-------|------------|------|-------|
| `aeolus-bazarr` | `bazarr` | 6767 | Subtitle companion for *arr |
| `aeolus-calibre` | `calibre` | 8081 | E-book library |
| `aeolus-emby-server` | `emby-server` | 8096 | Emby Server (ports ship one channel; no separate beta pkg) |
| `aeolus-jellyfin` | `jellyfin` | 8096 | Jellyfin |
| `aeolus-lidarr` | `lidarr` | 8686 | Music library manager |
| `aeolus-navidrome` | `navidrome` | 4533 | Music streaming (Airsonic-class) |
| `aeolus-plex` | `plexmediaserver` | 32400 | Plex Media Server |
| `aeolus-plex-plexpass` | `plexmediaserver-plexpass` | 32400 | Plex Pass / early-access channel |
| `aeolus-prowlarr` | `prowlarr` | 9696 | Indexer manager for *arr |
| `aeolus-radarr` | `radarr` | 7878 | Movie library manager |
| `aeolus-readarr` | `readarr` | 8787 | Ebook / audiobook manager |
| `aeolus-sonarr` | `sonarr` | 8989 | TV library manager |
| `aeolus-owncast` | `owncast` | 8080 | Self-hosted live streaming |
| `aeolus-ampache` | `ampache-php83` | 80 | Web media library |

## Downloaders

| Image | Package(s) | Port | Notes |
|-------|------------|------|-------|
| `aeolus-qbittorrent` | `qbittorrent-nox` | 8080 | BitTorrent (headless) |
| `aeolus-sabnzbd` | `sabnzbd` | 8080 | Usenet downloader |
| `aeolus-transmission` | `transmission-daemon` | 9091 | BitTorrent daemon |

## Network appliance apps

| Image | Package(s) | Port | Notes |
|-------|------------|------|-------|
| `aeolus-unifi` | `unifi10` | 8443 | UniFi Network Application |

## Utilities / sync / backup

| Image | Package(s) | Port | Notes |
|-------|------------|------|-------|
| `aeolus-bacula-server` | `bacula15-server` | 9101 | Backup server |
| `aeolus-nextcloud` | `nextcloud-php85` | 80 | Nextcloud file sync |
| `aeolus-piwigo` | `piwigo-php85` | 80 | Photo gallery |
| `aeolus-syncthing` | `syncthing` | 8384 | P2P file sync |
| `aeolus-zoneminder` | `zoneminder-php85` | 80 | Video surveillance |

## Dev / forge

| Image | Package(s) | Port | Notes |
|-------|------------|------|-------|
| `aeolus-forgejo` | `forgejo` | 3000 | Git forge (Gitea soft-fork) |
| `aeolus-gitea` | `gitea git` | 3000 | Gitea |

## Identity / secrets UI

| Image | Package(s) | Port | Notes |
|-------|------------|------|-------|
| `aeolus-keycloak` | `keycloak` | 8080 | Identity / SSO |
| `aeolus-vaultwarden` | `vaultwarden` | 8080 | Bitwarden-compatible vault |

## Observability

| Image | Package(s) | Port | Notes |
|-------|------------|------|-------|
| `aeolus-grafana` | `grafana` | 3000 | Dashboards |
| `aeolus-homepage` | `homepage` | 3000 | Service dashboard |
| `aeolus-netdata` | `netdata` | 19999 | Real-time host metrics |
| `aeolus-prometheus` | `prometheus` | 9090 | Metrics |
| `aeolus-uptime-kuma` | `uptime-kuma` | 3001 | Uptime monitoring |

## Blog / baseline (existing)

| Image | Package(s) | Port | Notes |
|-------|------------|------|-------|
| `aeolus-mariadb` | `mariadb1011-server` | 3306 | MariaDB |
| `aeolus-memcached` | `memcached` | 11211 | Memcached |
| `aeolus-wordpress` | `nginx php85-* wordpress` | 8080 | WordPress |

## Multi-service ensembles

| Ensemble | Services |
|----------|----------|
| `ensembles/blog` | wordpress + mariadb + redis + memcached |
| `ensembles/mastodon-stack` | mastodon + postgresql16 + redis |
| `ensembles/kafka-stack` | kafka + zookeeper |
| `ensembles/ai-stack` | ollama + litellm |
| `ensembles/cluster-web` | nginx + postgresql16 + redis via includes |
| `ensembles/owncast-stack` | owncast + postgresql16 via includes |
| `ensembles/peertube-deps` | nginx + postgresql16 + redis via includes (no peertube pkg) |

## Not in ports (yet)

- Home Assistant — no FreeBSD package; track separately or run in a Linux VM.
- Open WebUI / vLLM / Automatic1111 — not packaged; use `ollama` + `litellm` + `comfyui` + `llama-cpp`.
- Airsonic — use `navidrome`.
- Emby Beta — ports only ship `emby-server`.
- Photoprism / Paperless — not in FreeBSD package tree at catalog time.
