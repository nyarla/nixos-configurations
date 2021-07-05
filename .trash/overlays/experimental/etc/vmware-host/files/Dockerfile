FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN     apt-get update \
    &&  apt-get install -y --no-install-recommends apt-utils locales \
    &&  echo "en_US.UTF-8 UTF-8"  > /etc/locale.gen \
    &&  echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen \
    &&  locale-gen \
    &&  update-locale LANG=ja_JP.UTF-8 \
    &&  apt-get install -y --no-install-recommends \
      build-essential ca-certificates openssl curl bash sed sudo \
      xserver-xorg libxi6 libxinerama1 libxcursor1 libxtst6 fontconfig libasound2 \
    &&  apt-get upgrade -y \
    &&  apt-get clean \
    &&  rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN     curl -L "https://download3.vmware.com/software/player/file/VMware-Player-15.0.2-10952284.x86_64.bundle" -o "/tmp/vmware.bundle" \
    &&  bash  /tmp/vmware.bundle --console --required --eulas-agreed \
    &&  rm -f /tmp/vmware.bundle \
    &&  sed -i 's/if "$BINDIR"\/vmware-modconfig --appname=.*/if true ||/' /usr/bin/vmplayer

RUN     curl -L "https://raw.githubusercontent.com/chrismytton/shoreman/master/shoreman.sh" -o "/usr/bin/shoreman" \
    &&  chmod +x /usr/bin/shoreman \
    &&  echo 'nyarla ALL=(ALL:ALL) NOPASSWD: ALL' >/etc/sudoers.d/nyarla

RUN 	useradd -m -g users -s /bin/bash vmware \
	&&  mkdir -p /app

COPY  Procfile /app/Procfile
CMD "/bin/bash"

