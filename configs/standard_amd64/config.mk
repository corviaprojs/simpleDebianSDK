# the iso final name
ISO_OUTPUT_NAME := standard_amd64.iso

# the packages that gets installed
CHROOT_PKGS := live-boot \
	linux-image-6.12.107+deb13-amd64 \
	openbox \
	lightdm \
	lightdm-settings \
	lightdm-gtk-greeter \
	lightdm-gtk-greeter-settings \
	xorg \
	sudo

# settings
# required
DEBIAN_VERSION := stable
ARCH := amd64

# not required
#APT_ARG := --no-install-recommends
#DEBOOTSTRAP_ARGS := --variant minbase	