FROM alpine:edge

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk add --no-cache mono libcurl ca-certificates curl jq && \
    update-ca-certificates && \
    mkdir -p /jackett/config /jackett/release /jackett/downloads && \
    curl -L $(curl https://api.github.com/repos/Jackett/Jackett/releases/latest | jq -r '.assets[] | select(.name == "Jackett.Binaries.Mono.tar.gz") | .browser_download_url') | tar xzvf - -C /jackett/release --strip-components=1

ENV XDG_DATA_HOME="/jackett/config" \
    XDG_CONFIG_HOME="/jackett/config"

VOLUME /jackett/config \
       /jackett/downloads

EXPOSE 9117

CMD ["mono", "/jackett/release/JackettConsole.exe"]
