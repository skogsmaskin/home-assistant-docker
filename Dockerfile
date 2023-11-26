FROM homeassistant/home-assistant:stable
LABEL maintainer="Per-Kristian Nordnes <per.kristian.nordnes@gmail.com>"

# Install some dependencies and utils
RUN apk add --update \
  bash \
  curl \
  lirc \
  nano \
  supervisor

# telldusd is already included in the official base image

# Copy lirc remotes
COPY lirc/remotes/*.conf /usr/etc/lirc/lircd.conf.d/
# Copy lirc config options
COPY lirc/lirc_options.conf /usr/etc/lirc/lirc_options.conf

# Install and configure Supervisor
COPY supervisord.conf /etc/supervisord.conf
ENTRYPOINT ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]

# Specify health check for Docker
HEALTHCHECK CMD curl --fail http://homeassistant:8123 || exit 1
