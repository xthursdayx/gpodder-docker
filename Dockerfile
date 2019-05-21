#via https://github.com/linuxserver/dockergui
# Builds a docker gui image
FROM lsiobase/guacgui

LABEL maintainer="xthursdayx"

#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################

ARG DEBIAN_FRONTEND=noninteractive

# App Name
ENV APP_NAME="gPodder"

# gPodder database and settings files
ENV GPODDER_HOME /config

# gPodder extensions directory
ENV GPODDER_EXTENSIONS /config/extensions

# gPodder downloads directory
ENV GPODDER_DOWNLOAD_DIR /downloads

# Timezone
ENV TZ=America/New_York

#########################################
##    REPOSITORIES AND DEPENDENCIES    ##
#########################################
RUN \
echo 'deb http://archive.ubuntu.com/ubuntu bionic main universe restricted' >> /etc/apt/sources.list && \
echo 'deb http://archive.ubuntu.com/ubuntu bionic-updates main universe restricted' >> /etc/apt/sources.list && \
echo "############ Installing packages needed for app ##################" && \
apt-get update -y && \
apt-get install -y -q \
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
	python3-simplejson 

#########################################
##            INSTALL APP              ##
#########################################
RUN \
echo "############ Installing gPodder ##################" && \
apt-get install -y -q gpodder && \
apt-get clean && \
mkdir -p /config/extensions

#COPY /usr/share/gpodder/extensions/ /config/extensions/

RUN \
chown -R 911:911 /config && \
chmod -R g+rw /config
	
COPY startapp.sh /startapp.sh

#########################################
##           PORTS AND VOLUMES         ##
#########################################

VOLUME ["/downloads","/config"]

EXPOSE 8080 3389