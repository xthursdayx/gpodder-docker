<p align="center">
    <img src="https://raw.githubusercontent.com/xthursdayx/docker-templates/master/images/gpodder-icon.png" alt="" width="150"/>  
</p>

# gPodder Docker

[![Docker Build and Publish](https://github.com/xthursdayx/gpodder-docker/actions/workflows/docker-build-and-publish.yml/badge.svg)](https://github.com/xthursdayx/gpodder-docker/actions/workflows/docker-build-and-publish.yml)

A dockerized version of the [gPodder](https://gpodder.github.io/) podcast client with a built-in browser-based GUI.

[gPodder](https://gpodder.github.io/) is a simple, open source podcast client written in Python using GTK+. In development since 2005 with a proven, mature codebase.

## Application Setup

This image sets up the gPodder desktop app and makes its interface available via Guacamole in your web browser. The interface is available at `http://your-ip:3000`.

By default, there is no password set for the main gui. Optional environment variable `PASSWORD` will allow setting a password for the user `abc`.

You can access advanced features of the Guacamole remote desktop using `ctrl`+`alt`+`shift` enabling you to use remote copy/paste and different languages.

## Usage

Here are some examples to help you get started creating a container. If you are an UNRAID user you can access my [UNRAID gPodder template](https://raw.githubusercontent.com/xthursdayx/docker-templates/master/gpodder.xml) in Community Apps.

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
| `-p 8080` | HTTP access to the gPodder GUI. |
| `-p 3389` | RDP access to the gPodder GUI. |
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

* **19.06.21:** -  Rebase to rdesktop-web Alpine baseimage.


If you appreciate my work please consider buying me a coffee, cheers! 😁

<a href="https://www.buymeacoffee.com/xthursdayx"><img src="https://www.paypal.com/en_US/i/btn/btn_donate_SM.gif" alt="Donate" style="width:74px;height:auto;" width="74"></a>
