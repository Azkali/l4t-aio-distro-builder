# L4T AIO Builder

L4T AIO build automates the construction of GNU/Linux (L4T) distributions made and maintained by Linux4Switch and Switchroot members.

## Pre requisite

- Docker installed on your machine
- ~40GB of storage space avalaible

## Options :

```txt
Usage: entrypoint.sh <dir>

Variables:
    CPUS=4	      Number of CPU threads to allcoate during build.
    DEVICE=tegra210   Device as set in the configs directory.
    DISTRO=arch       Target distribution using file found in DEVICE folder.
    HEKATE_ID=SWR-ARC Set a Hekate ID.
    PARTNUM=mmcblk0p2 Set the partition that will be booted (it should reflect what you can find in`/dev`)
```

## The classic Docker way

```sh
sudo DISTRO=arch DEVICE=tegra210 PARTNUM=mmcblk0p2 HEKATE_ID=SWR-ARC CPUS=4 ./scripts/entrypoint.sh /absolute/path/to/build/dir
```

## The Docker In Docker way

Pull/Download the container:
```sh
docker pull alizkan/l4t-aio-distro-builder:latest
```

Set a new variable which will store the volume name:
```sh
export swr_vol=switchroot-builder-"$(date +%F)"
```

Create a docker volume (replace `/absolute/path/to/build/dir` with the directory path you want to attach the volume to) :
```sh
docker volume create --name "${swr_vol}" --opt type=none --opt device=/absolute/path/to/build/dir --opt o=bind
```

*Optional step to update every docker image used during build:*
```sh
docker run --privileged -it --rm -v /var/run/docker.sock:/var/run/docker.sock alizkan/l4t-aio-distro-builder:latest ./update.sh
```

Run the container:
```sh
docker run --privileged -it --rm -e DISTRO=arch -e DEVICE=tegra210 -e PARTNUM=mmcblk0p2 -e HEKATE_ID=SWR-ARC -e CPUS=4 -v "${swr_vol}":/out -v /var/run/docker.sock:/var/run/docker.sock alizkan/l4t-aio-distro-builder:latest
```

Remove the volume when done:
```sh
docker volume rm "${swr_vol}"
```
