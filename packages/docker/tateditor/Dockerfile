FROM nyarla:base-desktop

LABEL com.kalaclista.appname="TATEditor" \
      com.kalaclista.source="https://www.cc4966.net/" \
      com.kalaclista.version="2019-01-22" \
      com.kalaclista.maintaner="Naoki OKAMURA a.k.a nyarla <nyarla@thotep.net>" 

ADD   tateditor /usr/bin/tateditor
RUN   chmod +x /usr/bin/tateditor

RUN   mkdir -p /app

RUN   apt-get update \
  &&  apt-get install -y \
    libgtk-3-0 \
    libxxf86vm1 \
    libsm6 \
  &&  apt-get upgrade -y \
  &&  apt-get clean -y \
  &&  rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

ENTRYPOINT ["/usr/bin/tateditor"]
CMD ["--help"]
