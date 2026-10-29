<p align="center">
    <img src="https://raw.githubusercontent.com/xthursdayx/docker-templates/master/xthursdayx/images/gpodder-icon.png" alt="" width="150"/>
</p>

# gPodder Docker

[![Build](https://img.shields.io/github/actions/workflow/status/xthursdayx/gpodder-docker/build.yml?logo=githubactions&label=Build)](https://github.com/xthursdayx/gpodder-docker/actions/workflows/build.yml)
[![Docker Pulls](https://img.shields.io/docker/pulls/xthursdayx/gpodder-docker?logo=docker)](https://hub.docker.com/r/xthursdayx/gpodder-docker/)
[![Image Size](https://img.shields.io/docker/image-size/xthursdayx/gpodder-docker/latest?logo=alpinelinux&label=Image)](https://hub.docker.com/r/xthursdayx/gpodder-docker/)
[![GitHub release](https://img.shields.io/github/v/release/xthursdayx/gpodder-docker?logo=github)](https://github.com/xthursdayx/gpodder-docker/releases)

A dockerized version of the [gPodder](https://gpodder.github.io/) podcast client, running in your web browser.

[gPodder](https://gpodder.github.io/) is a simple, open source podcast client written in Python using GTK. In development since 2005 with a proven, mature codebase.

This image runs the official gPodder release on LinuxServer.io's [Selkies](https://docs.linuxserver.io/images/docker-baseimage-selkies/) web desktop base (Alpine), for `x86-64` and `arm64`.

> [!IMPORTANT]
> **Upgrading from 1.x?** 2.0 is a new base image. Your `/config` and `/downloads` carry over as-is, but read [Upgrading from 1.x](#upgrading-from-1x) first: the recommended port and compose options changed.

## Application Setup

Open **`https://your-ip:3001`** and accept the self-signed certificate. Port `3000` serves plain HTTP and is intended for use behind an HTTPS reverse proxy such as [SWAG](https://docs.linuxserver.io/general/swag/).

By default there is no login. Set `PASSWORD` (and optionally `CUSTOM_USER`, default `abc`) to enable HTTP basic auth. This is meant to keep casual visitors out, not to expose gPodder to the internet; use a reverse proxy with real authentication for that.

Right-click the desktop for a menu to relaunch gPodder or open a terminal. Set `RESTART_APP=true` to have gPodder restarted automatically if it is closed.

### Light and dark mode

gPodder 3.11.5 has its own colour scheme setting: **Preferences → Interface → Color scheme**. That is the only switch you need, and it persists in `/config`.

The `dark` tags are the same image with dark mode as the default for a *new* `/config`. You can also get that from the regular image with `-e GPODDER_THEME=dark`.

## Image tags

| Tag | Description |
| :-- | :-- |
| `latest`, `light` | Latest release, light default |
| `dark` | Latest release, dark default |
| `X.Y.Z`, `X.Y`, `X` | Pinned release, light default |
| `X.Y.Z-dark`, `X.Y-dark`, `X-dark` | Pinned release, dark default |

Every tag is a multi-arch manifest (`linux/amd64`, `linux/arm64`); Docker pulls the right one automatically.

## Usage

If you use UNRAID, my [gPodder template](https://raw.githubusercontent.com/xthursdayx/docker-templates/master/xthursdayx/gpodder.xml) is available in Community Apps.

### docker compose

```yaml
services:
  gpodder:
    image: xthursdayx/gpodder-docker:latest
    container_name: gpodder
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/New_York
      - PASSWORD= #optional
    volumes:
      - /path/to/config:/config
      - /path/to/downloads:/downloads
    ports:
      - 3001:3001
      - 3000:3000 #optional, plain HTTP for a reverse proxy
    shm_size: "1gb"
    restart: unless-stopped
```

### docker cli

```bash
docker run -d \
  --name=gpodder \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=America/New_York \
  -e PASSWORD= `#optional` \
  -p 3001:3001 \
  -v /path/to/config:/config \
  -v /path/to/downloads:/downloads \
  --shm-size=1gb \
  --restart unless-stopped \
  xthursdayx/gpodder-docker:latest
```

## Parameters

| Parameter | Function |
| :-- | :-- |
| `-p 3001` | HTTPS access to the web UI (self-signed certificate). |
| `-p 3000` | Plain HTTP, for use behind an HTTPS reverse proxy. |
| `-e PUID=1000` | User ID gPodder runs as. See [User / Group Identifiers](#user--group-identifiers). |
| `-e PGID=1000` | Group ID gPodder runs as. |
| `-e TZ=America/New_York` | Timezone. |
| `-e PASSWORD=` | Optional HTTP basic auth password for the web UI. |
| `-e CUSTOM_USER=abc` | Optional HTTP basic auth username. |
| `-e GPODDER_THEME=light` | `light` or `dark`. Default colour scheme for a new `/config` only; afterwards use gPodder's Preferences. |
| `-e GPODDER_CLI=` | Extra command-line flags for gPodder, e.g. `--verbose`. |
| `-e RESTART_APP=true` | Restart gPodder automatically if it is closed. |
| `-e LC_ALL=de_DE.UTF-8` | Run gPodder (and the session) in another language. |
| `-v /config` | gPodder's settings and database, plus the desktop session config. |
| `-v /downloads` | Where gPodder saves episodes. |
| `--shm-size=1gb` | Shared memory for the browser-streamed desktop. Recommended. |

All of the Selkies base image options (resolution, encoders, GPU acceleration, hardening, Wayland mode and so on) also work; see the [Selkies configuration reference](https://docs.linuxserver.io/selkies/user-guide/configuration/).

## Environment variables from files (Docker secrets)

Any environment variable can be read from a file by prefixing it with `FILE__`:

```bash
-e FILE__PASSWORD=/run/secrets/mysecretpassword
```

## User / Group Identifiers

When using volumes, permissions issues can arise between the host OS and the container. Avoid this by setting `PUID` and `PGID` to a user that owns the host directories you mount:

```bash
$ id <username>
uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```

The container takes ownership of `/config`. For `/downloads` it only adjusts the top-level folder, so existing files on a media share are never re-owned.

## Upgrading from 1.x

2.0 replaces the KasmVNC base with LinuxServer's Selkies base and collapses the image to one Dockerfile. What you need to do:

1. Map port **3001** and open `https://your-ip:3001` (or point your reverse proxy at port 3000).
2. Add `shm_size: "1gb"` / `--shm-size=1gb`.
3. If you pinned per-architecture tags (`light-amd64`, `dark-arm64v8`, `latest-amd64`, ...), switch to the plain tags; they are multi-arch.

Handled automatically on first start: your session autostart and right-click menu are pointed at the new gPodder location, and the old `dark` image's Materia/Breeze theme lines are removed from your GTK settings (dark mode itself is kept). Your podcasts, settings and downloads are untouched.

## Building locally

```bash
docker build -t gpodder-docker .                                 # light default
docker build --build-arg GPODDER_THEME=dark -t gpodder-docker:dark .
docker build --build-arg GPODDER_VERSION=3.11.5 -t gpodder-docker .
```

## Versioning

Image versions follow [SemVer](https://semver.org/) and are independent of gPodder's version:

- **Major**: changes that require action from users (ports, volumes, base image behaviour, removed tags).
- **Minor**: new gPodder minor/major versions, new features, non-breaking base image updates.
- **Patch**: gPodder patch releases, dependency updates and fixes.

The gPodder version in each image is recorded in the `io.github.xthursdayx.gpodder.version` label.

## Versions

* **2.0.0:** Rebase to LinuxServer Selkies Alpine 3.24 base. gPodder 3.11.5 installed from the official release (`make install`) instead of a git checkout. One Dockerfile and one multi-arch build for both themes; light/dark is now gPodder's own setting. HTML show notes now render (WebKit2 4.1). Removed build-time edge/testing packages, unused dependencies and per-architecture tags. Automatic migration of 1.x session files.
* **1.4.2 (31.01.24):** Rebase to KasmVNC Alpine baseimage, update gPodder to 3.11.4 and update dependencies.
* **06.04.23:** Update gPodder to 3.11.1 and update dependencies.
* **19.06.21:** Rebase to rdesktop-web Alpine baseimage.

If you appreciate my work please consider buying me a coffee, cheers! 😁

<a href="https://www.buymeacoffee.com/xthursdayx"><img src="https://www.paypal.com/en_US/i/btn/btn_donate_SM.gif" alt="Donate" style="width:74px;height:auto;" width="74"></a>
