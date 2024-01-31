<p align="center">
    <img src="https://raw.githubusercontent.com/xthursdayx/docker-templates/master/xthursdayx/images/gpodder-icon.png" alt="" width="150"/>  
</p>

# gPodder Docker

[![GitHub Workflow Status (event)](https://img.shields.io/github/actions/workflow/status/xthursdayx/gpodder-docker/docker-build-and-publish.yml?branch=main&logo=githubactions&label=Image%20Builds&event=push)](https://raw.githubusercontent.com/xthursdayx/gpodder-docker/main/.github/workflows/docker-build-and-publish.yml)
[![Docker Pulls](https://img.shields.io/docker/pulls/xthursdayx/gpodder-docker?logo=docker)](https://hub.docker.com/r/xthursdayx/gpodder-docker/)
[![Docker Image Size (tag)](https://img.shields.io/docker/image-size/xthursdayx/gpodder-docker/light?logo=alpinelinux&label=Light)](https://hub.docker.com/r/xthursdayx/gpodder-docker/)
[![Docker Image Size (tag)](https://img.shields.io/docker/image-size/xthursdayx/gpodder-docker/dark?logo=alpinelinux&label=Dark)](https://hub.docker.com/r/xthursdayx/gpodder-docker/)
[![GitHub release (latest by date)](https://img.shields.io/github/v/release/xthursdayx/gpodder-docker?logo=github)](https://github.com/xthursdayx/gpodder-docker/releases)
[![GitHub](https://img.shields.io/static/v1.svg?label=xthursdayx&message=GitHub&logo=github)](https://github.com/xthursdayx "view the source for all of my repositories.")

A dockerized version of the [gPodder](https://gpodder.github.io/) podcast client with a built-in browser-based GUI.

[gPodder](https://gpodder.github.io/) is a simple, open source podcast client written in Python using GTK+. In development since 2005 with a proven, mature codebase.

## Application Setup

This image sets up the gPodder desktop app and makes its interface available via Guacamole in your web browser. The interface is available at `http://your-ip:3000`.

By default, there is no password set for the main gui. Optional environment variable `PASSWORD` will allow setting a password for the user `abc`.

You can access advanced features of the Guacamole remote desktop using `ctrl`+`alt`+`shift` enabling you to use remote copy/paste and different languages.

### gPodder themes

Two versions of this image are available, one with gPodder running with a light GTK theme and one with a dark theme. There are tagged `light` and `dark` versions of the image, and light and dark version of each SemVer tagged release. Using the `latest` tag or no tag at all will default to the the lasest version of image and the light theme. 

| Theme | Tag |
| :----: | --- |
| Light | latest/light |
| Light |  v*.*.*-light |
| Dark | dark |
| Dark | v*.*.*-dark |

## Usage

Here are some examples to help you get started creating a container. If you are an UNRAID user you can access my [UNRAID gPodder template](https://raw.githubusercontent.com/xthursdayx/docker-templates/master/xthursdayx/gpodder.xml) in Community Apps.

### docker-compose

Compatible with docker-compose v2 schemas.

```yaml
---
version: "2.1"
services:
  gpodder:
    image: xthursdayx/gpodder-docker
    container_name: gPodder
    environment:
      - PUID=99
      - PGID=100
      - TZ=America/New_York
      - PASSWORD= #optional
    volumes:
      - /path/to/config:/config
      - /path/to/downloads:/downloads
    ports:
      - 3000:3000
    restart: unless-stopped
```
### docker cli

```bash
docker run -d \
  --name=gPodder \
  -e PUID=99 \
  -e PGID=100 \
  -e TZ=America/new_York \
  -e PASSWORD= `#optional` \
  -p 3000:3000 \
  -v /path/to/config:/config \
  -v /path/to/downloads:/downloads \
  --restart unless-stopped \
  xthursdayx/gpodder-docker
```

## Parameters

Container images are configured using parameters passed at runtime (such as those listed above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container. You can change the external/host port and volume mappings to suit your needs.

| Parameter | Function |
| :----: | --- |
| `-p 3000` | HTTP access to the gPodder WebUI. |
| `-e PUID=99` | for UserID - see below for more information. |
| `-e PGID=100` | for GroupID - see below for more information. |
| `-e TZ=America/New_York` | Specify a timezone to use, e.g. America/New_York. |
| `-e PASSWORD=` | Optionally set a password for the gui. |
| `-v /config` | Directory where gPodder's configuration and database files will reside, so you won't lose data when you update, reinstall, etc. |
| `-v /downloads` | The directory gPodder will download your podcasts to. |

## Environment variables from files (Docker secrets)

You can set any environment variable from a file by using a special prepend `FILE__`.

As an example:

```bash
-e FILE__PASSWORD=/run/secrets/mysecretpassword
```

Will set the environment variable `PASSWORD` based on the contents of the `/run/secrets/mysecretpassword` file.


## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, you can avoid this by specifying the user `PUID` and group `PGID`.

Ensure any mapped volume directories on your host machine are owned by the same user you specify and you will avoid any permissions issues.

In this instance `PUID=1000` and `PGID=1000`, to find yours using the following command:

```bash
  $ id <username> # Replace with your username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```   

## Versions
* **31.01.24:** - Rebase to KasmVNC Alpine baseimage, Update GPodder to 3.11.4 and update dependencies.

* **06.04.23:** - Update GPodder to 3.11.1 and update dependencies.

* **19.06.21:** -  Rebase to rdesktop-web Alpine baseimage.


If you appreciate my work please consider buying me a coffee, cheers! 😁

<a href="https://www.buymeacoffee.com/xthursdayx"><img src="https://www.paypal.com/en_US/i/btn/btn_donate_SM.gif" alt="Donate" style="width:74px;height:auto;" width="74"></a>
