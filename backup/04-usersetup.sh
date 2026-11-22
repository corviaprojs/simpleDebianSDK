root_passwd="root"
liveuser_passwd="live"

#'liveuser' user createing
adduser --disabled-password --gecos "" liveuser

# setting the 'root' and 'liveuser' password
echo "root:$root_passwd" | chpasswd
echo "liveuser:$liveuser_passwd" | chpasswd

#adding 'sudo' group to 'liveuser'
usermod -aG sudo liveuser