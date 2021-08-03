#!/bin/bash
set -x
# Prepare an ultxv1 instance for DEV-Deployment
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
sudo dnf -y install php-cli
sudo dnf -y install php-xml
sudo dnf -y install php-json
sudo dnf -y install fish
sudo dnf -y install util-linux-user-2.32.1-27.el8.x86_64
sudo dnf -y install mlocate-0.26-20.el8.x86_64
sudo systemctl start mlocate-updatedb.service
sudo systemctl enable vnstat
sudo systemctl start vnstat
sudo wget https://www.slac.stanford.edu/~abh/bbcp/bin/amd64_rhel60/bbcp
sudo chmod +x bbcp
sudo cp bbcp /bin
sudo mkdir git
sudo -s
cd git
sudo git clone https://git.code.sf.net/p/iperf2/code iperf2-code
sudo -s
cd iperf2-code/
sudo /bin/bash /root/git/iperf2-code/configure
sudo -s
cd /root/git/iperf2-code/
sudo make && make install
sudo -s
cd /root/git
sudo git clone https://github.com/Microsoft/ntttcp-for-linux
sudo -s
cd ntttcp-for-linux/src
sudo make && make install
sudo -s
cd /root/git
sudo wget https://phoronix-test-suite.com/releases/phoronix-test-suite-10.4.0.tar.gz
sudo tar xvf phoronix-test-suite-10.4.0.tar.gz
sudo -s 
cd phoronix-test-suite
sudo ./phoronix-test-suite phoromatic.connect 52.53.234.213:8201/LS7E0N
sudo dig +short myip.opendns.com @resolver1.opendns.com
sudo dd if=/dev/urandom of=/root/rand.file bs=2G count=1 iflag=fullblock
sudo printf "# /etc/systemd/system/iperf.service\n[Unit]\nDescription=iperf server\nAfter=syslog.target network.target auditd.service\n[Service]\nExecStart=/usr/local/bin/iperf -s -e -i 1 -m -u -z --histograms --udp-histogram\n[Install]\nWantedBy=multi-user.target\n" >> /etc/systemd/system/iperf.service
sudo systemctl daemon-reload
sudo systemctl enable iperf.service
sudo systemctl start iperf.service
sudo printf "# /etc/systemd/system/iperf3.service\n[Unit]\nDescription=iperf3 server\nAfter=syslog.target network.target auditd.service\n[Service]\nExecStart=/usr/bin/iperf3 -s \n[Install]\nWantedBy=multi-user.target\n" >> /etc/systemd/system/iperf3.service
sudo systemctl enable iperf3.service
sudo systemctl daemon-reload
sudo systemctl start iperf3.service
sudo printf "# /etc/systemd/system/pts.service\n[Unit]\nDescription=pts server\nAfter=syslog.target network.target auditd.service\n[Service]\nExecStart=/root/git/phoronix-test-suite/./phoronix-test-suite phoromatic.connect 52.53.234.213:8201/LS7E0N \n[Install]\nWantedBy=multi-user.target\n" >> /etc/systemd/system/pts.service
sudo systemctl enable pts.service
sudo systemctl daemon-reload
#sudo systemctl start pts.service
#sudo ssh-keygen -t rsa -b 4096 -C "no@way.foo" -f aws.pub -P ""
sudo tuned-adm profile hpc-compute
#phoronix-test-suite phoromatic.connect 52.53.234.213:8201/LS7E0N
sudo rm -Rf /root/git/iperf2-code
sudo chsh -s /bin/fish
sudo chsh -s /bin/fish centos
sudo reboot now