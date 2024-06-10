FROM ghcr.io/linuxserver/webtop:ubuntu-xfce

# set version label
ARG BUILD_DATE
ARG VERSION
ARG XFCE_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE="Ubuntu XFCE"

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /kclient/public/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/webtop-logo.png && \
  echo "**** install packages ****" && \
  apk add --no-cache \
    faenza-icon-theme \
    faenza-icon-theme-xfce4-appfinder \
    faenza-icon-theme-xfce4-panel \
    firefox \
    mousepad \
    ristretto \
    thunar \
    util-linux-misc \
    xfce4 \
    xfce4-terminal && \

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
