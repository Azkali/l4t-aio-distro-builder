FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive

RUN chmod 1777 /tmp

RUN apt-get update -y && apt-get install -y p7zip-full docker.io

VOLUME /out
WORKDIR /build
COPY ./scripts/entrypoint.sh /build
RUN chmod +x /build/entrypoint.sh

ARG DISTRO
ENV DISTRO=${DISTRO}
ARG DEVICE
ENV DEVICE=${DEVICE}
ARG PARTNUM
ENV PARTNUM=${PARTNUM}
ARG HEKATE_ID
ENV HEKATE_ID=${HEKATE_ID}
ARG CPUS=2
ENV CPU=${CPUS}

ENTRYPOINT /build/entrypoint.sh
