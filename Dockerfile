#via https://github.com/linuxserver/dockergui
# Builds a docker gui image
#FROM hurricane/dockergui:xvnc
FROM hurricane/dockergui:x11rdp1.3

MAINTAINER xthursdayx

#########################################
##        ENVIRONMENTAL CONFIG         ##
#########################################

# Set environment variables

# User/Group Id gui app will be executed as default are 99 and 100
ENV USER_ID=99
ENV GROUP_ID=100

# Gui App Name default is "GUI_APPLICATION"
ENV APP_NAME="gPodder"

# Default resolution, change if you like
ENV WIDTH=1280
ENV HEIGHT=720

# gPodder satabase and settings files
ENV GPODDER_HOME /config

# gPodder downloads directory
ENV GPODDER_DOWNLOAD_DIR /downloads

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

RUN \
#########################################
##    REPOSITORIES AND DEPENDENCIES    ##
#########################################
echo 'deb http://archive.ubuntu.com/ubuntu trusty main universe restricted' > /etc/apt/sources.list && \
echo 'deb http://archive.ubuntu.com/ubuntu trusty-updates main universe restricted' >> /etc/apt/sources.list && \

# Install packages needed for app
# export DEBCONF_NONINTERACTIVE_SEEN=true DEBIAN_FRONTEND=noninteractive && \
apt-get update -y
#apt-get install -y -qq \
#    ca-certificates \
#    dbus-x11 \
#    git \
#    gir1.2-gtk-3.0 \
#	 gir1.2-webkit2-3.0 \
#    libgtk-3-dev \
#    python3-dbus \
#    python3-gi \
#    python3-gi-cairo \
#    python3-eyed3 \
#    python-html5lib \
#    python3-magic \
#    python3-webencodigns \
#    --no-install-recommends

RUN \
#########################################
##          INSTALL gPodder            ##
#########################################
apt-get install --no-install-recommends -y -q gpodder && \

# clean up
apt-get clean

# Copy gPodder start script to right location
COPY startapp.sh /startapp.sh

#########################################
##         EXPORTS AND VOLUMES         ##
#########################################

RUN mkdir -p /downloads

# Place whatever volumes and ports you want exposed here:
VOLUME ["/downloads", "/config"]

EXPOSE 8080 3389