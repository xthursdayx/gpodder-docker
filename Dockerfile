FROM lsiobase/guacgui

ARG GPODDER_RELEASE
LABEL maintainer="xthursdayx"

ENV APPNAME="gPodder"

RUN \
echo "**** Installing dep packages ****" && \
apt-get update && \
apt-get install -y \
    ca-certificates \
	dbus \
    default-dbus-session-bus \
    gir1.2-gtk-3.0 \
    gir1.2-ayatanaappindicator3-0.1 \
	jq \
    libgtk-3-dev \
    python3 \
    python3-cairo \
    python3-dbus \
    python3-eyed3 \
    python3-gi \
    python3-gi-cairo \
    python3-html5lib \
    python3-mutagen \
    python3-mygpoclient \
    python3-podcastparser \
    python3-simplejson \
	wget && \
echo "**** Installing gPodder ****" && \
mkdir -p \
       /config \
	   /config/extensions && \
apt-get install -y gpodder && \
if [ -z ${GPODDER_RELEASE+x} ]; then \
       GPODDER_RELEASE=$(curl -sX GET "https://api.github.com/repos/gpodder/gpodder/releases/latest" \
       | jq -r .tag_name); \
fi && \
GPODDER_URL="https://codeload.github.com/gpodder/gpodder/tar.gz/${GPODDER_RELEASE}" && \
curl -o \
       /tmp/gpodder-tarball.tar.gz \
       "$GPODDER_URL" && \
tar xvzf /tmp/gpodder-tarball.tar.gz -C \
       /tmp/ && \
cp -a /tmp/gpodder-${GPODDER_RELEASE}/share/gpodder/extensions/. /config/extensions
echo "GPODDER_DOWNLOAD_DIR=/downloads" >> ~/.pam_environment && \
echo "GPODDER_EXTENSIONS=/config/extensions" >> ~/.pam_environment && \
apt-get clean && \
rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*
	
COPY root/ /