#!/bin/bash
set -x
# Prepare an ultxv1 instance for DEV-Deployment
sudo dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
/bin/bash /root/scripts/misc/ultx-unlock.sh
prompt='[ "$PS1"="\\s-\\v\\\$ " ] && PS1="\[$(tput setaf 33)\][\u@$(dig +short myip.opendns.com @resolver1.opendns.com) | \W ]\[$(tput sgr0)\] \[$(tput setaf 34)\]\\$\[$(tput sgr0)\]"'
sudo echo $prompt >> /root/.bashrc
sudo echo $prompt >> /home/centos/.bashrc
sudo echo sudo su >> /home/centos/.bash_profile
sudo echo cd /root >> /home/centos/.bash_profile
sudo echo IdleAction=shutdown >> /etc/systemd/logind.conf
sudo echo IdleActionSec=45min >> /etc/systemd/logind.conf
sudo echo systemctl stop commandx* >> /usr/lib/systemd/system-shutdown/graceful.sh
sudo echo systemctl stop accessx* >>/usr/lib/systemd/system-shutdown/graceful.sh
sudo echo systemctl stop nginx >> /usr/lib/systemd/system-shutdown/graceful.sh
sudo echo systemctl stop postgresql* >> /usr/lib/systemd/system-shutdown/graceful.sh
sudo echo systemctl stop ultxd* >> /usr/lib/systemd/system-shutdown/graceful.sh
chmod +x /usr/lib/systemd/system-shutdown/graceful.sh
chmod 755 /usr/lib/systemd/system-shutdown/graceful.sh
sudo ultx enable all
sudo ultx restart all
sudo echo IdleAction=shutdown >> /etc/systemd/logind.conf
sudo echo IdleActionSec=45min >> /etc/systemd/logind.conf
sudo hostnamectl set-hostname ultxv1
sudo dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo dnf config-manager --set-enabled PowerTools
sudo dnf config-manager --set-enabled BaseOS
sudo dnf config-manager --set-enabled AppStream
sudo dnf -y install libnsl
sudo dnf -y install mbuffer
sudo dnf -y install htop
sudo dnf -y install vnstat
sudo dnf -y install compat-openssl10-1:1.0.2o-3.el8.x86_64
sudo systemctl enable vnstat
sudo systemctl start vnstat
wget https://www.slac.stanford.edu/~abh/bbcp/bin/amd64_rhel60/bbcp
sudo chmod +x bbcp
sudo cp bbcp /bin
mkdir git
cd git
git clone https://git.code.sf.net/p/iperf2/code iperf2-code
cd iperf2-code/
/bin/bash /home/centos/git/iperf2-code/configure
cd /home/centos/git/iperf2-code/
make && make install
cd /home/centos/git
git clone https://github.com/Microsoft/ntttcp-for-linux
cd ntttcp-for-linux/src
make && make install
sudo dig +short myip.opendns.com @resolver1.opendns.com
sudo dd if=/dev/urandom of=/root/rand.file bs=2G count=1 iflag=fullblock
#sudo ssh-keygen -t rsa -b 4096 -C "no@way.foo" -f aws.pub -P ""
sudo reboot