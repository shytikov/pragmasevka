FROM debian:stretch-slim AS build

RUN apt-get update
RUN apt-get install -y clang make git

WORKDIR /build
RUN git clone -b master --depth 1 https://github.com/be5invis/Iosevka

FROM node:stretch

RUN apt-get update
RUN apt-get install -y ttfautohint

COPY --from=build /build/Iosevka /build

WORKDIR /build
RUN npm install
