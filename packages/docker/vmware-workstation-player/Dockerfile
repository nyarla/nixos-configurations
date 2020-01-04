FROM nyarla:base-desktop

LABEL com.kalaclista.appname="VMware Workstaiton Player" \
      com.kalaclista.source="https://www.vmware.com/" \
      com.kalaclista.version="15.0.4" \
      com.kalaclista.maintainer="Naoki OKAMURA a.k.a nyarla <nyarla@thotep.net>"

RUN  apt-get update \
  && apt-get install -y \
    build-essential git python python3 \
    ca-certificates \
    openssl curl bash sed \
    xserver-xorg libxi6 libxinerama1 libxcursor1 fontconfig libasound2 \
  && apt-get upgrade -y \
  && apt-get clean -y \
  && rm -rf /var/cache/apt/archive/* /var/lib/apt/lists/*

RUN  echo '%wheel ALL=(ALL) NOPASSWD:ALL' >/etc/sudoers.d/wheel \
  && rm /usr/bin/pkexec \
  && ln -sf /usr/bin/sudo /usr/bin/pkexec

ENTRYPOINT ["/bin/bash"]
