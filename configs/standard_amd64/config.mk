ISO_OUTPUT_NAME := standard_amd64.iso

CHROOT_PKGS := live-boot \
	linux-image-6.12.107+deb13-amd64 \
	openbox \
	lightdm \
	lightdm-settings \
	lightdm-gtk-greeter \
	lightdm-gtk-greeter-settings \
	xorg \
	sudo
    
DEBIAN_VERSION := stable
ARCH := amd64

# you not set args you can just comment it but only these!
#APT_ARG := --no-install-recommends
#DEBOOTSTRAP_ARGS := --variant minbase