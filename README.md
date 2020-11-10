# Google Chrome with Docker

## How to run ?

```
./run
```

## Warning

If at the startup you have this error :

```
No protocol specified
Error: couldn't open display unix:0
```


Run :

```bash
xhost +"local:docker@"
```

### Dockerfile
Default version is 71.0.3578.30, but you can use others changing CHROME_VERSION.
```
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
```

### Docker-compose.yml

```
version: '3'

services:
  google-chrome:
    build: .
    image: google-chrome:71.0.3578.30
    container_name: chrome
    deploy:
      resources:
        limits:
          cpus: '0'
          memory: 512M
    environment:
      - DISPLAY=unix$DISPLAY
    volumes:
      - $HOME/Downloads:/root/Downloads
      - /tmp/.X11-unix:/tmp/.X11-unix
    devices:
      - "/dev/snd"
    networks:
      hostnet: {}
    privileged : true

networks:
  hostnet:
```

## Sources

- https://github.com/jessfraz/dockerfiles/blob/master/chrome/stable/Dockerfile
- https://qxf2.com/blog/building-your-own-docker-images-for-different-browser-versions/
- https://deb.pkgs.org/universal/google-amd64/google-chrome-beta_71.0.3578.30-1_amd64.deb.html