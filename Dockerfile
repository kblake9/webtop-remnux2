# This Docker image encapsulates the REMnux v7 distro on Ubuntu 20.04 (focal).
# For details about REMnux, including how you can run it on a physical system
# or as a virtual machine, see https://REMnux.org.
#
# You can run this image as a container using a command such as:
#
# docker run --rm -it remnux/remnux-distro /bin/bash
#
# To map a local directory into the container's /home/remnux/files directory,
# you could use a command lile this by supplying the appropriate directory name:
#
# docker run --rm -it -v <local_directory>:/home/remnux/files remnux/remnux-distro /bin/bash
#
# If you'd like to access the container using SSH,  you can invoke it like this by
# mapping your local TCP port 22 to the container's internal TCP port 22. In this example,
# the container will remain active in the background:
#
# docker run -d -p 22:22 remnux/remnux-distro
#
# If you're going to run this container in a remote cloud, be sure to change the default
# password and otherwise harden the system according to your requirements.
#
# If you're planning to use Cutter inside the container, you'll need to include the
# --privileged parameter when invoking Docker.
#

FROM ubuntu:20.04

LABEL description="REMnux® is a Linux toolkit for reverse-engineering and analyzing malicious software."
LABEL maintainer="Lenny Zeltser (@lennyzeltser, zeltser.com)"
LABEL version="v2023.9.1"
ARG CAST_VER=0.14.0


USER root

WORKDIR /tmp
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y wget gnupg git && \
    wget https://github.com/ekristen/cast/releases/download/v${CAST_VER}/cast_v${CAST_VER}_linux_amd64.deb && \
    dpkg -i /tmp/cast_v${CAST_VER}_linux_amd64.deb && \
    cast install --mode cloud --user remnux remnux && \
    rm -rf /root/.cache/* && \
    unset DEBIAN_FRONTEND

RUN rm /tmp/cast_v${CAST_VER}_linux_amd64.deb

ENV TERM linux
WORKDIR /home/remnux

RUN sudo apt install flatpak -y
RUN flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
RUN flatpak install flathub org.mozilla.firefox -y
RUN flatpak install flathub org.xfce.mousepad -y
RUN \
  echo "**** install packages ****" && \
      sudo apt install faenza-icon-theme -y && \
      sudo apt install thunar -y && \
      sudo apt-get install xfce4 -y

RUN mkdir /var/run/sshd
EXPOSE 3000
CMD ["/usr/sbin/sshd", "-D"]
