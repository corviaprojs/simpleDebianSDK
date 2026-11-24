set -e

if [[ "$EUID" -ne 0 ]]; then
    echo "For installing you need to run it with root"
    exit 1;
fi;

dnf_pkgs="squashfs-tools xorriso debootstrap grub2 make"
apt_pkgs="squashfs-tools xorriso debootstrap grub-pc make"

os=$(. /etc/os-release && echo "$ID")
echo "Building on: $os"

case "$os" in
    fedora|centos)
        dnf update
        dnf install $dnf_pkgs
        ;;
    ubuntu|debian)
        apt update
        apt install $apt_pkgs
        ;;
    *)
        echo "Unknown operating system: $os"
        ;;
esac