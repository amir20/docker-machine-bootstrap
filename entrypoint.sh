#!/bin/sh

if [[ ! -d /hostssh ]]; then
    echo "Must mount the host SSH directory at /hostssh"
    exit 1
fi

# Generate temporary SSH key to allow access to the host machine.
mkdir -p /root/.ssh
echo "Generating temoporary ssh keys..."
ssh-keygen -f /root/.ssh/id_rsa -P ""

if [ -e /hostssh/authorized_keys ]; then
    echo "Backing up authorized keys..."
    cp /hostssh/authorized_keys /hostssh/authorized_keys.bak
fi

cat /root/.ssh/id_rsa.pub >> /hostssh/authorized_keys

ansible all -i "localhost," -m raw -a "apt-get install -y ansible"
ansible-playbook -i "localhost," /ansible/bootstrap.yml

if [ -e /hostssh/authorized_keys.bak ]; then
    echo "Restoring previous authorized keys..."
    mv /hostssh/authorized_keys.bak /hostssh/authorized_keys
else
    rm /hostssh/authorized_keys
fi
