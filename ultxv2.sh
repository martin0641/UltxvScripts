#!/bin/bash
set -x
# Prepare an ultxv2 instance for DEV-Deployment
sudo dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
/bin/bash /root/scripts/misc/ultx-unlock.sh
sudo ultx enable all
sudo ultx restart all
sudo hostnamectl set-hostname ultxv2
sudo dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo dnf config-manager --set-enabled PowerTools
sudo dnf config-manager --set-enabled BaseOS
sudo dnf config-manager --set-enabled AppStream
sudo dnf -y install mbuffer
sudo dnf -y install htop
sudo dnf -y install vnstat
sudo dnf install compat-openssl10-1:1.0.2o-3.el8.x86_64
sudo systemctl start vnstat
wget https://www.slac.stanford.edu/~abh/bbcp/bin/amd64_rhel60/bbcp
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
