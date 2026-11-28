set -e

# setting it here for esier understanding/visiblity

#dont use that in a production! :Đ
root_passwd="root"

# setting 'root' password with pipeing
echo "root:$root_passwd" | chpasswd