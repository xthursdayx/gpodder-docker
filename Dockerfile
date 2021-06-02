FROM lsiobase/guacgui

LABEL maintainer="xthursdayx"

ENV APPNAME="gPodder" 
ENV GPODDER_TAG="3.10.19"

RUN \
    echo "**** Installing dep packages ****" && \
    apt-get update && \
    apt-get install -qy --no-install-recommends \
    ca-certificates \
    dbus \
    default-dbus-session-bus \
    ffmpeg \
    gir1.2-gtk-3.0 \
    gir1.2-ayatanaappindicator3-0.1 \
    gir1.2-webkit2-4.0 \
    git \
    help2man \
    intltool \
    jq \
    libfreerdp-plugins-standard \
    libgtk-3-0 \
    locales \
    locales-all \
    normalize-audio \
    python3 \
    python3-cairo \
    python3-dbus \
    python3-eyed3 \
    python3-gi \
    python3-gi-cairo \
    python3-html5lib \
    python3-mutagen \
    python3-mygpoclient \
    python3-pip \
    python3-podcastparser \
    python3-simplejson \
    wget \
    xfonts-75dpi \
    xfonts-100dpi && \
    pip3 install youtube_dl \
    requests

RUN echo "**** Installing gPodder ****" && \
    git clone https://github.com/gpodder/gpodder.git && \
    cd gpodder && \
    git checkout $GPODDER_TAG && \
    echo "GPODDER_DOWNLOAD_DIR=/downloads" >> ~/.pam_environment

RUN apt-get clean && \
    rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

ENV LANG en_US.UTF-8 \
    LANGUAGE en_US.UTF-8 \
    LC_ALL en_US.UTF-8

COPY root/ /

VOLUME /config
EXPOSE 3389 8080
