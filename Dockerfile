FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive

RUN chmod 1777 /tmp

RUN apt-get update -y && apt-get install -y p7zip-full docker.io

VOLUME /out
WORKDIR /build

ADD ./scripts/entrypoint.sh /build
ADD ./scripts/update.sh /build

RUN chmod +x /build/*.sh

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

CMD /build/entrypoint.sh
