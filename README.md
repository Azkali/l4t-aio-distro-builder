# L4T AIO Builder

## The classic Docker way

```sh
DISTRO=arch DEVICE=tegra210 PARTNUM=2 HEKATE_ID=SWR-ARC CPUS=4 ./run.sh /absolute/path/to/build/dir
```

## The Docker In Docker way

Set a new variable for the volume name:

```sh
export swr_vol=switchroot-builder-"$(date +%F)"
```

Create a docker volume:

```sh
docker volume create --name "${swr_vol}" --opt type=none --opt device=/absolute/path/to/build/dir --opt o=bind
```

Run the container:

```sh
docker run --privileged -it --rm -e DISTRO=arch -e DEVICE=tegra210 -e PARTNUM=2 -e HEKATE_ID=SWR-ARC -e CPUS=4 -v "${swr_vol}":/out -v /var/run/docker.sock:/var/run/docker.sock alizkan/l4t-aio-distro-builder:latest
```

Remove the volume when done:

```sh
docker volume rm "${swr_vol}"
```
