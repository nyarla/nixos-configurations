FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive
ENV XMODIFIERS @im=ibus
ENV QT_IM_MODULE ibus
ENV GTK_IM_MODULE ibus

RUN     echo "en_US.UTF-8 UTF-8"  >/etc/locale.gen \
    &&  echo "ja_JP.UTF-8 UTF-8" >>/etc/locale.gen

RUN     apt-get update \
    &&  apt-get install -y locales apt-utils sudo dbus dbus-x11 ibus ibus-skk \
    &&  rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN     locale-gen \
    &&  update-locale LANG=ja_JP.UTF-8

