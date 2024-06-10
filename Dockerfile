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
RUN flatpak install flathub org.xfce.mousepad

# title
ENV TITLE="Ubuntu XFCE"

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /kclient/public/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/webtop-logo.png && \
  echo "**** install packages ****" && \
      sudo apt install faenza-icon-theme && \
      sudo apt install thunar && \
      sudo apt-get install xfce4 && \

      wget https://REMnux.org/remnux-cli && \
      mv remnux-cli remnux && \
      chmod +x remnux && \
      sudo mv remnux /usr/local/bin && \
      sudo apt install -y gnupg curl && \
      sudo remnux install --mode=cloud && \
    
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
