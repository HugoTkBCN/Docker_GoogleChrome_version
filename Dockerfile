FROM ubuntu

#Essential tools
RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    wget

#Chrome browser
ARG CHROME_VERSION=71.0.3578.30
RUN curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add \
      && wget http://dl.google.com/linux/deb/pool/main/g/google-chrome-beta/google-chrome-beta_$CHROME_VERSION-1_amd64.deb \
      && dpkg -i google-chrome-beta_* || true
RUN apt-get install -y -f \
      && rm -rf /var/lib/apt/lists/*

# Add chrome user
RUN groupadd -r chrome && useradd -r -g chrome -G audio,video chrome \
    && mkdir -p /home/chrome/Downloads && chown -R chrome:chrome /home/chrome

# Run Chrome as non privileged user
USER chrome

# Autorun chrome
ENTRYPOINT [ "google-chrome" ]
CMD [ "--user-data-dir=/data" ]