ISO_OUTPUT_NAME := simpleLinux.iso

CHROOT_PKGS := live-boot \
	linux-image-6.12.107+deb13-amd64 
    
APT_ARG := --no-install-recommends
DEBOOTSTRAP_ARGS := 
DEBIAN_VERSION := stable
ARCH := amd64