FROM lsiobase/guacgui

LABEL maintainer="xthursdayx"

ENV APPNAME="gPodder"
ENV GPODDER_HOME /config
ENV GPODDER_EXTENSIONS /config/extensions
ENV GPODDER_DOWNLOAD_DIR /downloads
ENV USER_ID=1000
ENV GROUP_ID=1000
ENV DISPLAY=:1

ARG DEBIAN_FRONTEND=noninteractive

RUN \
echo "**** Installing dep packages ****" && \
apt-get update && \
apt-get install -yq \
    ca-certificates \
    dbus-x11 \
    default-dbus-session-bus \
    gir1.2-gtk-3.0 \
    gir1.2-ayatanaappindicator3-0.1 \
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
    python3-simplejson && \
echo "**** Installing gPodder ****" && \
apt-get install -yq gpodder && \
mkdir -p /config/extensions && \
cp -a /usr/share/gpodder/extensions/. /config/extensions/ && \
apt-get clean && \
rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*
	
COPY /root /

VOLUME ["/downloads","/config"]

EXPOSE 8080 3389