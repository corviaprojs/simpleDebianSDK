.PHONY: all createisoskel checkroot reiso migrate chroot masclean isoclean install_pkgs setup_rootfs genInitramfs genSquashfs copyBoots

ifdef CONFIG
-include configs/$(CONFIG)/config.mk
endif

workdir         := $(shell pwd)
chrootPath      := $(workdir)/build/$(CONFIG)/rootfs
configBuildPath := $(workdir)/build/$(CONFIG)

GRUB_MKRESCUE := $(shell command -v grub2-mkrescue 2>/dev/null || echo grub-mkrescue)	
migrate_files := $(wildcard $(workdir)/configs/$(CONFIG)/migrate/*)
SHELL := /bin/bash

all:
	@echo "Check the README.md! To get started!"


# check you are running as root/sudo
checkroot:
ifndef CONFIG
	$(error 'CONFIG' is not set! Run: make CONFIG=<name>)
else ifndef ISO_OUTPUT_NAME
	$(error 'ISO_OUTPUT_NAME' is not set in your configuration, read docs!)
else ifndef CHROOT_PKGS
	$(error 'CHROOT_PKGS' is not set in your configuration, read docs!)
else ifndef DEBIAN_VERSION
	$(error 'DEBIAN_VERSION' is not set in your configuration, read docs!)
else ifndef ARCH
	$(error 'ARCH' is not set in your configuration, read docs!)
endif
	@if [[ "$$EUID" -ne 0 ]]; then \
		echo "For running its you need to run it with sudo"; \
		exit 1; \
	fi


# chroot into the filesystem
chroot: checkroot 
	@chroot $(chrootPath) /bin/bash || true
	@umount $(chrootPath)/proc || true


# clean the iso_root's boot and live folder
isoclean: checkroot
	@rm -f $(configBuildPath)/iso_root/boot/{vmlinuz,initrd.img}
	@rm -f $(configBuildPath)/iso_root/live/*
	@rm -f $(configBuildPath)/$(ISO_OUTPUT_NAME)


# cleans everything
distclean: checkroot
	@sudo rm -rf $(configBuildPath)


# migrate
migrate: checkroot
	@for file in $(migrate_files); do \
		echo "Applying: $$file..."; \
		cp "$$file" $(chrootPath)/tmp/migrate.sh || exit 1; \
		chmod +x $(chrootPath)/tmp/migrate.sh; \
		chroot $(chrootPath) /tmp/migrate.sh || exit 1; \
		rm $(chrootPath)/tmp/migrate.sh; \
	done

install_pkgs: checkroot
	@chroot $(chrootPath) apt install $(APT_ARG) $(CHROOT_PKGS) -y

# Setup --- begin
createisoskel: checkroot
	@mkdir -p $(configBuildPath)/iso_root/live
	@mkdir -p $(configBuildPath)/iso_root/boot/grub

	@cp $(workdir)/configs/$(CONFIG)/grub/grub.cfg $(configBuildPath)/iso_root/boot/grub/grub.cfg

setup_rootfs: checkroot
	@echo "Debian: '$(DEBIAN_VERSION)' being created from: '$(CONFIG)' config"
	@debootstrap $(DEBOOTSTRAP_ARGS) --arch $(ARCH) $(DEBIAN_VERSION) $(chrootPath) http://deb.debian.org/debian/

setup: checkroot createisoskel setup_rootfs install_pkgs migrate
	@echo "done: setup"


# Setup --- end

# initramfs generating
genInitramfs: checkroot 
	@chroot $(chrootPath) update-initramfs -u

# squashfs generating
genSquashfs: checkroot
	@rm -f $(configBuildPath)/iso_root/live/filesystem.squashfs || true
	@mksquashfs $(chrootPath) $(configBuildPath)/iso_root/live/filesystem.squashfs -comp xz

# boot file copy
copyBoots: checkroot
	@cp $(chrootPath)/vmlinuz $(configBuildPath)/iso_root/boot
	@cp $(chrootPath)/initrd.img $(configBuildPath)/iso_root/boot

# iso regenerating
reiso: checkroot
	@$(GRUB_MKRESCUE) $(configBuildPath)/iso_root -o $(configBuildPath)/$(ISO_OUTPUT_NAME)
	@echo "Your iso is regerated: $(configBuildPath)/$(ISO_OUTPUT_NAME)"
	@echo "Your iso is stored here: $(configBuildPath)"

# original iso generating 
iso: checkroot genInitramfs genSquashfs copyBoots
	@$(GRUB_MKRESCUE) $(configBuildPath)/iso_root -o $(configBuildPath)/$(ISO_OUTPUT_NAME)
	@echo "Your iso is done: $(configBuildPath)/$(ISO_OUTPUT_NAME)"
	@echo "Your iso is stored here: $(configBuildPath)"
