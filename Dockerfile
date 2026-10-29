# syntax=docker/dockerfile:1

# Both stages use the same base so the Python ABI and site-packages path match.
# The LSIO base is a multi-arch manifest: buildx picks amd64/arm64 automatically.

########################################################################
# Build stage: install gPodder from the upstream release tarball the same
# way Alpine's own APKBUILD does (make install PREFIX=/usr DESTDIR=...)
########################################################################
FROM ghcr.io/linuxserver/baseimage-selkies:alpine324 AS build

ARG GPODDER_VERSION=3.11.5

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# The base puts a venv (/lsiopy) first on PATH; build against the system
# interpreter so the installed scripts get a /usr/bin/python3 shebang.
ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" \
    VIRTUAL_ENV=""

RUN \
  echo "**** install build dependencies ****" && \
  apk add --no-cache \
    gettext \
    intltool \
    make \
    py3-build \
    py3-installer \
    py3-setuptools \
    py3-wheel && \
  echo "**** build gPodder ${GPODDER_VERSION} ****" && \
  mkdir -p /src && \
  curl -fsSL "https://github.com/gpodder/gpodder/archive/refs/tags/${GPODDER_VERSION}.tar.gz" \
    | tar xz -C /src --strip-components=1 && \
  make -C /src install PYTHON=/usr/bin/python3 PREFIX=/usr DESTDIR=/out && \
  echo "**** disable in-app update check (the image is the update channel) ****" && \
  install -Dm644 /dev/null /out/usr/share/gpodder/no-update-check && \
  echo "**** web client icon ****" && \
  install -d /out/usr/share/selkies/www && \
  curl -fsSL -o /out/usr/share/selkies/www/icon.png \
    "https://raw.githubusercontent.com/xthursdayx/docker-templates/master/xthursdayx/images/gpodder-icon.png"

########################################################################
# Runtime stage
########################################################################
FROM ghcr.io/linuxserver/baseimage-selkies:alpine324

ARG BUILD_DATE
ARG VERSION
ARG GPODDER_VERSION=3.11.5
LABEL build_version="xthursdayx version:- ${VERSION} gPodder:- ${GPODDER_VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="xthursdayx"

# GPODDER_HOME stays at /config for compatibility with existing installs.
ENV TITLE=gPodder \
    LANG=en_US.UTF-8 \
    GPODDER_HOME=/config \
    GPODDER_DOWNLOAD_DIR=/downloads

# gtk+3.0, fonts (incl. Noto CJK/emoji), dbus, openbox/labwc and xdg-open
# already come from the base image. Everything below is from Alpine 3.24 stable.
RUN \
  echo "**** install gPodder runtime dependencies ****" && \
  apk add --no-cache \
    adwaita-icon-theme \
    eyed3 \
    ffmpeg \
    mutagen \
    py3-cairo \
    py3-dbus \
    py3-gobject3 \
    py3-html5lib \
    py3-mygpoclient \
    py3-pillow \
    py3-podcastparser \
    py3-pysocks \
    py3-requests \
    webkit2gtk-4.1 \
    xdg-utils \
    yt-dlp && \
  rm -rf /tmp/*

COPY --from=build /out/ /
COPY root/ /

# Default colour scheme for a fresh /config. The "dark" tag is this same
# Dockerfile built with --build-arg GPODDER_THEME=dark.
ARG GPODDER_THEME=light
ENV GPODDER_THEME=${GPODDER_THEME}

EXPOSE 3000 3001
VOLUME ["/config", "/downloads"]
