#!/bin/sh

# https://www.digitalocean.com/community/tutorials/how-to-use-sshfs-to-mount-remote-file-systems-over-ssh
remote_pi=$1

sudo mkdir -p /mnt/$remote_pi

typeset check_mntpoint="mountpoint /mnt/$remote_pi"

echo $check_mntpoint

eval $check_mntpoint
ret_code=$?

# IF THIS FAILS it might be because your known_hosts are wrong
# run ssh-copy-id
sudo sshfs -o allow_other pi@$remote_pi:/home/pi/ /mnt/$remote_pi/
if [ $? = 0 ]; then
	echo "Mounted $remote_pi successfully!"
	exit 0
else
	echo "Unable to mount $remote_pi!"
	exit 2
fi

echo "Already mounted"
exit 1"

