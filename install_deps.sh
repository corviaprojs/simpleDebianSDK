if [[ "$EUID" -ne 0 ]]; then
    echo "For installing you need to run it with root"
    exit 1;
fi;

dnf_pkgs="squashfs-tools qemu-system-x86_64 debootstrap grub2 gcc gcc-c++ make"
apt_pkgs="squashfs-tools xorriso qemu-system debootstrap grub2 grub-common grub-pc make"


os=$(. /etc/os-release && echo "$ID")

echo "Host dependency installer begins: "
echo "Host system: $os"

case "$os" in
    fedora|centos)
        dnf update -qq
        dnf install $dnf_pkgs -y -qq
        ;;
    ubuntu|debian)
        apt update -qq
        apt install $apt_pkgs -y -qq
        ;;
    *)
        echo "idk os bro"
        ;;
esac