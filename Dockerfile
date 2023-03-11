FROM debian:latest

LABEL description="SinusBot - TeamSpeak 3 and Discord music bot."
LABEL version="1.0.1"

# Install dependencies and clean up afterwards
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends x11vnc xvfb libxcursor1 libnss3 libegl1-mesa libasound2 libglib2.0-0 libxcomposite-dev less jq python3 nano ca-certificates bzip2 unzip curl python procps libpci3 libxslt1.1 libxkbcommon0 locales &&  \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*
WORKDIR /opt/sinusbot
COPY install.sh /opt/sinusbot/install.sh
RUN /bin/sh -c "chmod 755 install.sh"

# Download/Install TeamSpeak Client

RUN bash install.sh sinusbot
RUN bash install.sh youtube-dl
RUN bash install.sh text-to-speech

COPY entrypoint.sh /opt/sinusbot/entrypoint.sh
RUN /bin/sh -c "chmod 755 entrypoint.sh"
EXPOSE 8087
VOLUME [/opt/sinusbot/data /opt/sinusbot/scripts]
ENTRYPOINT ["/opt/sinusbot/entrypoint.sh"]
HEALTHCHECK --interval=1m --timeout=10s \
  CMD curl --no-keepalive -f http://localhost:8087/api/v1/botId || exit 1
RUN bash install.sh teamspeak
