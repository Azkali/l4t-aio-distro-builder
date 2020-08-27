FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && apt-get install -y p7zip-full docker.io

VOLUME /out
COPY ./scripts/entrypoint.sh /
RUN chmod +x /entrypoint.sh

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

ENTRYPOINT /entrypoint.sh
