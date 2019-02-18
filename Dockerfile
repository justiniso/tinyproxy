FROM alpine:3.7

ENV TINYPROXY_VERSION=1.10.0

RUN adduser -D -u 2000 -h /var/run/tinyproxy -s /sbin/nologin tinyproxy tinyproxy \
  && apk --update add -t build-dependencies \
    make \
    automake \
    autoconf \
    g++ \
    asciidoc \
    git \
  && rm -rf /var/cache/apk/*

RUN git clone -b ${TINYPROXY_VERSION} --depth=1 https://github.com/tinyproxy/tinyproxy.git /tmp/tinyproxy \
  && cd /tmp/tinyproxy \
  && ./autogen.sh \
  && ./configure --enable-transparent --enable-filter --enable-upstream --enable-reverse \
  && make \
  && make install \
  && mkdir -p /var/log/tinyproxy \
  && chown tinyproxy:tinyproxy /var/log/tinyproxy \
  && cd / \
  && rm -rf /tmp/tinyproxy \
  && apk del build-dependencies

RUN apk update && apk add --no-cache \
    tinyproxy

CMD ["tinyproxy", "-d"]

