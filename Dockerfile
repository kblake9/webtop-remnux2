FROM ghcr.io/linuxserver/webtop:ubuntu-xfce

# set version label
ARG BUILD_DATE
ARG VERSION
ARG XFCE_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

RUN sudo apt update
RUN sudo apt upgrade -y
RUN sudo apt install flatpak -y
RUN flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
RUN flatpak install flathub org.mozilla.firefox -y
RUN flatpak install flathub org.xfce.mousepad -y
RUN sudo apt install wget -y

# title
ENV TITLE="Ubuntu XFCE"

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /kclient/public/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/webtop-logo.png
RUN \
  echo "**** install packages ****" && \
      sudo apt install faenza-icon-theme -y && \
      sudo apt install thunar -y && \
      sudo apt-get install xfce4 -y

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y wget gnupg git && \
    wget https://github.com/ekristen/cast/releases/download/v0.14.31/cast_v0.14.31_linux_amd64.deb && \
    dpkg -i /cast_v0.14.31_linux_amd64.deb && \
    cast install --mode cloud --user remnux remnux && \
    rm -rf /root/.cache/* && \
    unset DEBIAN_FRONTEND

RUN rm /cast_v${CAST_VER}_linux_amd64.deb

 RUN \   
  echo "**** cleanup ****" && \
  rm -f \
    /etc/xdg/autostart/xfce4-power-manager.desktop \
    /etc/xdg/autostart/xscreensaver.desktop \
    /usr/share/xfce4/panel/plugins/power-manager-plugin.desktop && \
  rm -rf \
    /config/.cache \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
