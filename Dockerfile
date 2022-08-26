FROM node:slim

RUN \
    apt-get update && \
    apt-get install --yes git ttfautohint && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

WORKDIR /tmp

RUN \
    git clone -b master --depth 1 https://github.com/be5invis/Iosevka && \
    mv /tmp/Iosevka/* /builder

WORKDIR /build
RUN npm install
