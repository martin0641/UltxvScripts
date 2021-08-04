#!/bin/bash
set -x
# Prepare an ultxv2 instance for DEV-Deployment
sudo dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
/bin/bash /root/scripts/misc/ultx-unlock.sh
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
sudo dnf -y remove iperf3
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
sudo dnf -y install redhat-lsb-core-4.1-47.el8.x86_64
#sudo dnf -y install powerline-fonts
sudo systemctl start mlocate-updatedb.service
sudo systemctl enable vnstat
sudo systemctl start vnstat
git clone https://github.com/oh-my-fish/oh-my-fish.git
sudo wget https://www.slac.stanford.edu/~abh/bbcp/bin/amd64_rhel60/bbcp
sudo chmod +x bbcp
sudo cp bbcp /bin
sudo mkdir git
sudo su
cd /root/git
sudo git clone https://git.code.sf.net/p/iperf2/code iperf2-code
cd /root/git/iperf2-code/
sudo /bin/bash /root/git/iperf2-code/configure
sudo make && make install
cd /root/git
sudo git clone https://github.com/esnet/iperf.git
cd /root/git/iperf/
sudo /bin/bash /root/git/iperf/configure
sudo make && make install && ldconfig
cd /root/git
sudo git clone https://github.com/Microsoft/ntttcp-for-linux
cd /root/git/ntttcp-for-linux/src
sudo make && make install
cd /root/git
sudo wget https://phoronix-test-suite.com/releases/phoronix-test-suite-10.4.0.tar.gz
sudo tar xvf phoronix-test-suite-10.4.0.tar.gz
cd /root/git/phoronix-test-suite
sudo dig +short myip.opendns.com @resolver1.opendns.com
sudo dd if=/dev/urandom of=/root/rand.file bs=2G count=1 iflag=fullblock
cd /root/git
sudo git clone https://github.com/powerline/fonts.git --depth=1
cd /root/git/fonts
/bin/bash /root/git/fonts/install.sh
cd /root/git
sudo rm -rf fonts
sudo printf "# /etc/systemd/system/iperf-tcp.service\n[Unit]\nDescription=iperf-tcp server\nAfter=syslog.target network.target auditd.service\n[Service]\nExecStart=/usr/local/bin/iperf --server --enhanced --format g --interval 1 --print_mss --realtime --histograms --port 5021 --sum-only --daemon\n[Install]\nWantedBy=multi-user.target\n" >> /etc/systemd/system/iperf-tcp.service
sudo systemctl daemon-reload
sudo systemctl enable iperf-tcp.service
sudo systemctl start iperf-tcp.service
sudo printf "# /etc/systemd/system/iperf-udp.service\n[Unit]\nDescription=iperf-udp server\nAfter=syslog.target network.target auditd.service\n[Service]\nExecStart=/usr/local/bin/iperf --server --enhanced --format g --interval 1 --print_mss --realtime --histograms --udp-histogram --port 5001 --sum-only --udp --daemon\n[Install]\nWantedBy=multi-user.target\n" >> /etc/systemd/system/iperf-udp.service
sudo systemctl daemon-reload
sudo systemctl enable iperf-udp.service
sudo systemctl start iperf-udp.service
sudo printf "# /etc/systemd/system/iperf3-tcp.service\n[Unit]\nDescription=iperf3-tcp server\nAfter=syslog.target network.target auditd.service\n[Service]\nExecStart=/usr/bin/iperf3 --server -p 5231\n[Install]\nWantedBy=multi-user.target\n" >> /etc/systemd/system/iperf3-tcp.service
sudo systemctl daemon-reload
sudo systemctl enable iperf3-tcp.service
sudo systemctl start iperf3-tcp.service
sudo printf "# /etc/systemd/system/iperf3-udp.service\n[Unit]\nDescription=iperf3-udp server\nAfter=syslog.target network.target auditd.service\n[Service]\nExecStart=/usr/bin/iperf3 --server -p 5201 --udp\n[Install]\nWantedBy=multi-user.target\n" >> /etc/systemd/system/iperf3-udp.service
sudo systemctl daemon-reload
sudo systemctl enable iperf3-udp.service
sudo systemctl start iperf3-udp.service
sudo printf "# /etc/systemd/system/pts.service\n[Unit]\nDescription=pts server\nAfter=syslog.target network.target auditd.service\n[Service]\nExecStart=/root/git/phoronix-test-suite/./phoronix-test-suite phoromatic.connect 52.53.234.213:8201/LS7E0N \n[Install]\nWantedBy=multi-user.target\n" >> /etc/systemd/system/pts.service
sudo systemctl enable pts.service
sudo systemctl daemon-reload
sudo tuned-adm profile hpc-compute
sudo ssh-keygen -t rsa -b 4096 -C "no@way.foo" -f remote.pub -P ""
sudo rm -Rf /root/git/iperf2-code
sudo chsh -s /bin/fish
sudo chsh -s /bin/fish centos
cd /root/git/
sudo git clone https://github.com/oh-my-fish/oh-my-fish.git
cd oh-my-fish
bin/install --offline
cd /root/git/
sudo git clone https://github.com/powerline/fonts.git
cd /root/git/fonts
/bin/bash /root/git/fonts/install.sh
cd /root/git/
sudo git clone https://github.com/mishamyrt/Lilex.git
cd /root/git/Lilex
/bin/bash /root/git/fonts/install.sh
sudo mkdir /root/scripts/starship
cd /root/scripts/starship
sudo curl https://starship.rs/install.sh >> /root/scripts/starship/install.sh
sudo chmod +x /root/scripts/starship/install.sh
/bin/bash /root/scripts/starship/install.sh -V -f
sudo echo -e "starship init fish | source" >> /root/.config/fish/config.fish
omf install
sudo reboot now
#sudo systemctl start pts.service
#sudo ./phoronix-test-suite phoromatic.connect 52.53.234.213:8201/LS7E0N
#prompt='[ "$PS1"="\\s-\\v\\\$ " ] && PS1="\[$(tput setaf 33)\][\u@$(dig +short myip.opendns.com @resolver1.opendns.com) | \W ]\[$(tput sgr0)\] \[$(tput setaf 34)\]\\$\[$(tput sgr0)\]"'
#sudo echo $prompt >> /root/.bashrc
#sudo echo $prompt >> /home/centos/.bashrc
#dnf provides '*filename'
#cat /usr/local/fxv/etc/variables.json
#nano /usr/local/fxv/etc/variables.json
#iperf2-UDP
#iperf --port 5001 --trip-times --format g --print_mss --enhanced --interval 1 --realtime --sum-only --txdelay-time 1 --udp --len 1408 --client 127.0.0.1 -t 10 --bandwidth 500m
#iperf --port 5001 --trip-times --format g --print_mss --enhanced --interval 1 --realtime --sum-only --txdelay-time 1 --udp --len 1408 --client 127.0.0.1 -t 10 --bandwidth 500m -P 2
#iperf --port 5001 --trip-times --format g --print_mss --enhanced --interval 1 --realtime --sum-only --txdelay-time 1 --udp --len 1408 --client 127.0.0.1 --num 1G --bandwidth 500m
#iperf --port 5001 --trip-times --format g --print_mss --enhanced --interval 1 --realtime --sum-only --txdelay-time 1 --udp --len 1408 --client 127.0.0.1 --num 1G --bandwidth 500m -P 2