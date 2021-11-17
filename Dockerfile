FROM lsiobase/rdesktop-web:alpine

# set build labels
ARG BUILD_DATE
ARG GPODDER_TAG="3.10.21"
LABEL build_version="gPodder version:- ${GPODDER_TAG} Build-date:- ${BUILD_DATE}"
LABEL maintainer="xthursdayx"

ENV GUIAUTOSTART="true" \
    MUSL_LOCPATH="/usr/share/i18n/locales/musl" \
    LANG=C.UTF-8 \
    LANGUAGE=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    HOME="/config" \
    GPODDER_HOME="/config" \
    GPODDER_DOWNLOAD_DIR="/downloads"

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-deps \
    gcc \
    g++ \
    cmake \
    make \
    gettext-dev \
    git \
    intltool \
    help2man && \
 echo "**** install dep packages ****" && \
 apk add --no-cache --upgrade \
    python3 \
    py3-cairo \
    py3-click \
    py3-dbus \
    py3-gobject3 \
    py3-ipaddr \
    py3-libxml2 \
    py3-pip \
    py3-setuptools \
    py3-urlgrabber \
    ttf-freefont \
    webkit2gtk \
    ffmpeg \
    ffmpeg-libs \
    jq && \
 echo "**** install PyPI deps ****" && \
 pip3 install --no-cache-dir \
    mygpoclient==1.8 \
    podcastparser==0.6.8 \
    requests[socks]==2.26.0 \
    urllib3==1.26.7 \
    html5lib==1.1 \
    mutagen==1.45.1 \
    eyed3==0.9.6 \
    youtube_dl==2021.6.6 && \
 echo "**** install locales ****" && \
 git clone https://gitlab.com/rilian-la-te/musl-locales && \
 cd musl-locales && \
 cmake . -DLOCALE_PROFILE=OFF -DCMAKE_INSTALL_PREFIX=/usr && \
 make && \
 make install && \
 cd .. && \ 
 echo "**** Installing gPodder ****" && \
 git clone https://github.com/gpodder/gpodder.git && \
 cd gpodder && \
 git checkout $GPODDER_TAG && \
 echo "**** cleanup ****" && \
 apk del --purge \
    build-deps && \
 rm -rf \
    /musl-locales \
    /tmp/* \
    /var/cache/apk/* \
    /tmp/.[!.]*

COPY root/ /

VOLUME ["/downloads","/config"]
EXPOSE 3000
