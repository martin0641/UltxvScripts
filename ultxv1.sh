#!/bin/bash
set -x
# Prepare an ultxv1 instance for DEV-Deployment
curl https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm -o /tmp/ssm/amazon-ssm-agent.rpm
sudo dnf install -y /tmp/ssm/amazon-ssm-agent.rpm
/bin/bash /root/scripts/misc/ultx-unlock.sh
sudo ultx enable all
sudo ultx restart all
sudo hostnamectl set-hostname ultxv1
sudo dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo dnf -y install htop
sudo dnf -y install vnstat
sudo systemctl start vnstat
mkdir git
cd git
git clone https://git.code.sf.net/p/iperf2/code iperf2-code
cd iperf2-code/
/bin/bash /home/centos/git/iperf2-code/configure
cd /home/centos/git/iperf2-code/
make
make install
mkdir /tmp/ssm
sudo dig +short myip.opendns.com @resolver1.opendns.com
sudo dd if=/dev/urandom of=/root/rand.file bs=1G count=1 iflag=fullblock
sudo reboot
