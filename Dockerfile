FROM alpine:3.15

MAINTAINER SiggiAZE <SiggiAZE@gmail.com>

ENV PUID="1000"
ENV PGID="1000"
ENV TZ="Europe/London"
ENV FRIENDLY_NAME="Mini DLNA Server" 


# install minidlna
RUN apk --no-cache add bash curl minidlna tini shadow su-exec alpine-conf inotify-tools


# Add config file
ADD minidlna.conf /config/minidlna.conf


# Copy entrypoint
COPY entrypoint.sh /usr/bin/
ENTRYPOINT ["/sbin/tini", "--", "/entrypoint.sh"]



# HealthCheck 
HEALTHCHECK --interval=10s --timeout=10s --retries=6 CMD \
  curl --silent --fail localhost:8200 || exit 1

# Ports & Volumes
EXPOSE 1900/udp
EXPOSE 8200

VOLUME /config
VOLUME /data
VOLUME /logs
VOLUME /media
VOLUME /music
VOLUME /videos
VOLUME /picturs