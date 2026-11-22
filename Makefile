.PHONY: checkroot reiso migrate chroot masclean isoclean install_pkgs setup_rootfs genInitramfs genSquashfs copyBoots

# 'settings':
workdir       := $(shell pwd)
iso_name 	  := simpleLinux.iso
chroot_pkgs   := live-boot \
	linux-image-6.12.107+deb13-amd64 \
	lightdm \
	openbox \
	locales \
	network-manager \
	xorg \
	obconf \
	sudo \
	dhcpd \
	htop

apt_args         := --no-install-recommends
debootstrap_args := --variant minbase
arch             := amd64

GRUB_MKRESCUE := $(shell command -v grub2-mkrescue 2>/dev/null || echo grub-mkrescue)	
migrate_files := $(wildcard $(workdir)/migrate/*)

SHELL := /bin/bash

all:
	@echo "Check the README.md! To get started!"


checkroot:
	@if [[ "$$EUID" -ne 0 ]]; then \
		echo "For running its you need to run it with sudo"; \
		exit 1; \
	fi

chroot: checkroot
	@chroot $(workdir)/rootfs /bin/bash
	@umount $(workdir)/rootfs/proc || true

masclean: checkroot
	@sudo rm -rf rootfs 

isoclean: checkroot
	@rm -f $(workdir)/iso_root/boot/{vmlinuz,initrd.img}
	@rm -f $(workdir)/iso_root/live/*
	@rm -f $(workdir)/$(iso_name)

# Setup --- begin
install_pkgs:
	@chroot $(workdir)/rootfs apt install $(apt_args) $(chroot_pkgs) -y 2>/dev/null
setup_rootfs: 
	@debootstrap $(debootstrap_args) --arch $(arch) stable $(workdir)/rootfs http://deb.debian.org/debian/ 2>/dev/null

setup: checkroot setup_rootfs install_pkgs migrate
	@mkdir $(workdir)/iso_root/live/
	@echo "done: setup"
# Setup --- end

migrate: checkroot
	@for file in $(migrate_files); do \
		echo "Applying: $$file..."; \
		chmod +x $$file; \
		$$file; \
	done

# iso building:

genInitramfs:
	@chroot $(workdir)/rootfs update-initramfs -u 2>/dev/null

genSquashfs:
	@rm -f $(workdir)/iso_root/live/filesystem.squashfs || true
	@mksquashfs $(workdir)/rootfs $(workdir)/iso_root/live/filesystem.squashfs -comp xz

copyBoots:
	@cp $(workdir)/rootfs/vmlinuz $(workdir)/iso_root/boot
	@cp $(workdir)/rootfs/initrd.img $(workdir)/iso_root/boot

reiso: checkroot
	@$(GRUB_MKRESCUE) $(workdir)/iso_root -o $(workdir)/$(iso_name)
	@echo "Your iso is regerated: $(workdir)/$(iso_name)"

iso: checkroot genInitramfs genSquashfs copyBoots
	@$(GRUB_MKRESCUE) $(workdir)/iso_root -o $(workdir)/$(iso_name)
	@echo "Your iso is done: $(workdir)/$(iso_name)"
