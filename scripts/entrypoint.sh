#!/bin/bash

# If we're inside docker we get the volume name attached to the running container otherwise retrieve the output directory inputed
if  [[ -f /.dockerenv ]]; then out=/out; volume=$(docker inspect -f '{{range .Mounts}}{{.Name}}{{end}}' "$(cat /etc/hostname)");
	else out="$(realpath "${@:$#}")"; [[ ! -d ${out} ]] && echo "Invalid output path: ${out}" && exit 1; fi

# Check if the environement variables are set
[[ -z "${DISTRO}" || -z "${PARTNUM}" || -z "${HEKATE_ID}" || -z "${DEVICE}" ]] && \
	echo "Invalid options: DISTRO=${DISTRO} PARTNUM=${PARTNUM} HEKATE_ID=${HEKATE_ID} DEVICE=${DEVICE}" && exit 1

# Check if docker is installed
[[ ! $(command -v docker) ]] && \
	echo "Docker is not installed on your machine..." && exit 1

# Check if 7zip is installed
if [[ $(command -v 7z) ]]; then zip_ver=7z;
	elif [[ $(command -v 7za) ]]; then zip_ver=7za;
	else [[ -z "${zip_ver}" ]] && \
	echo "7z is not installed on your machine..." && exit 1; fi

# Creating needed hekate directories
mkdir -p "${out}"/bootloader/ini/ "${out}"/switchroot/"${DISTRO}"

echo -e "\nBuilding L4T-Kernel\n"
docker run -it --rm -e CPUS="${CPUS}" -v "${volume}":/out alizkan/l4t-kernel:latest

echo -e "\nBuilding u-boot\n"
docker run -it --rm -e DISTRO="${DISTRO}" -v "${volume}":/out alizkan/switch-uboot:linux-norebase

echo -e "\nBuilding boot.scr and initramfs and updating coreboot.rom\n"
docker run -it --rm -e DISTRO="${DISTRO}" -e PARTNUM="${PARTNUM}" -e HEKATE_ID="${HEKATE_ID}" -v "${volume}":/out alizkan/l4t-bootfiles-misc:latest

echo -e "\nBuilding the actual distribution\n"
docker run -it --rm --privileged -e DISTRO="${DISTRO}" -e DEVICE="${DEVICE}" -e HEKATE=true -e HEKATE_ID="${HEKATE_ID}" -v "${volume}":/out alizkan/jet-factory:latest

# Copying kernel, kernel modules and device tree file to switchroot directrory
cp "${out}"/Final/Image "${out}"/Final/tegra210-icosa.dtb "${out}"/Final/modules.tar.gz "${out}"/switchroot/"${DISTRO}"

echo -e "\nUpdating and renaming 7z archive created during JetFactory build\n"
"${zip_ver}" u "${out}"/switchroot-"${DISTRO}".7z "${out}"/bootloader "${out}"/switchroot

# Add date for betterr release tagging
mv "${out}"/switchroot-"${DISTRO}".7z "${out}"/switchroot-"${DISTRO}"-"$(date +%F)".7z

# Cleaning build files
rm -r "${out}"/bootloader/ "${out}"/switchroot/ "${out}"/u-boot.elf "${out}"/coreboot.rom "${out}"/initramfs "${out}"/boot.scr "${out}"/Final
echo -e "Done, file produced: ${out}/switchroot-${DISTRO}-$(date +%F).7z"
