ISO_OUTPUT_NAME := standard_amd64.iso

CHROOT_PKGS := live-boot \
	linux-image-6.12.107+deb13-amd64 \
	icewm
    
APT_ARG := --no-install-recommends
DEBOOTSTRAP_ARGS :=
DEBIAN_VERSION := stable
ARCH := amd64