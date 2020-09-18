FROM lsiobase/guacgui

LABEL maintainer="xthursdayx"

ENV APPNAME="gPodder" 

RUN \
echo "**** Installing dep packages ****" && \
apt-get update && \
apt-get install -y \
    ca-certificates \
    dbus \
    default-dbus-session-bus \
    ffmpeg \
    gir1.2-gtk-3.0 \
    gir1.2-ayatanaappindicator3-0.1 \
    jq \
    libgtk-3-dev \
    locales \
    locales-all \
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
apt-get install -y gpodder && \
echo "GPODDER_DOWNLOAD_DIR=/downloads" >> ~/.pam_environment && \
apt-get clean && \
rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*
    
ENV LANG en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL en_US.UTF-8
	
COPY root/ /

VOLUME /config
EXPOSE 3389 8080
