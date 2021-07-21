#!/bin/bash
set -x
# Prepare an ultxv2 instance for DEV-Deployment
sudo dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
/bin/bash /root/scripts/misc/ultx-unlock.sh
#prompt='[ "$PS1"="\\s-\\v\\\$ " ] && PS1="\[$(tput setaf 33)\][\u@$(dig +short myip.opendns.com @resolver1.opendns.com) | \W ]\[$(tput sgr0)\] \[$(tput setaf 34)\]\\$\[$(tput sgr0)\]"'
#sudo echo $prompt >> /root/.bashrc
#sudo echo $prompt >> /home/centos/.bashrc
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
sudo hostnamectl set-hostname ultxv2
sudo dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo dnf config-manager --set-enabled PowerTools
sudo dnf config-manager --set-enabled BaseOS
sudo dnf config-manager --set-enabled AppStream
sudo dnf -y install libnsl
sudo dnf -y install mbuffer
sudo dnf -y install htop
sudo dnf -y install vnstat
sudo dnf -y install compat-openssl10-1:1.0.2o-3.el8.x86_64
sudo dnf -y install php-cli
sudo dnf -y install php-xml
sudo dnf -y install php-json
#sudo dnf -y install 
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
cd /root/git
wget https://phoronix-test-suite.com/releases/phoronix-test-suite-10.4.0.tar.gz
tar xvf phoronix-test-suite-10.4.0.tar.gz
cd phoronix-test-suite
sudo ./phoronix-test-suite phoromatic.connect 52.53.234.213:8201/LS7E0N
sudo dig +short myip.opendns.com @resolver1.opendns.com
sudo dd if=/dev/urandom of=/root/rand.file bs=2G count=1 iflag=fullblock
sudo printf "# /etc/systemd/system/iperf.service\n[Unit]\nDescription=iperf server\nAfter=syslog.target network.target auditd.service\n[Service]\nExecStart=/usr/bin/iperf -s --compatibility\n[Install]\nWantedBy=multi-user.target\n" >> /etc/systemd/system/iperf.service
sudo systemctl enable iperf.service
sudo systemctl daemon-reload
sudo systemctl start iperf.service
sudo printf "# /etc/systemd/system/iperf3.service\n[Unit]\nDescription=iperf3 server\nAfter=syslog.target network.target auditd.service\n[Service]\nExecStart=/usr/bin/iperf3 -s \n[Install]\nWantedBy=multi-user.target\n" >> /etc/systemd/system/iperf3.service
sudo systemctl enable iperf3.service
sudo systemctl daemon-reload
sudo systemctl start iperf3.service
sudo printf "# /etc/systemd/system/pts.service\n[Unit]\nDescription=pts server\nAfter=syslog.target network.target auditd.service\n[Service]\nExecStart=/root/git/phoronix-test-suite/./phoronix-test-suite phoromatic.connect 52.53.234.213:8201/LS7E0N \n[Install]\nWantedBy=multi-user.target\n" >> /etc/systemd/system/pts.service
sudo systemctl enable pts.service
sudo systemctl daemon-reload
sudo systemctl start pts.service
#sudo ssh-keygen -t rsa -b 4096 -C "no@way.foo" -f aws.pub -P ""
#phoronix-test-suite phoromatic.connect 52.53.234.213:8201/LS7E0N
sudo reboot now