#!/bin/bash

sudo pacman -S --needed "linux-headers" "make"
mkdir /home/$USER/Programs
sudo rm -r /home/$USER/Programs/CoreFreq
git clone https://github.com/cyring/CoreFreq.git /home/$USER/Programs/CoreFreq/
cd /home/$USER/Programs/CoreFreq
make
sudo make install
echo "#!/bin/bash
sudo modprobe corefreqk
sudo corefreqd & \sleep 0.5" > /home/$USER/corefreq
echo "corefreq-cli" >> /home/$USER/corefreq
sudo chmod +x /home/$USER/corefreq
sudo mv /home/$USER/corefreq /usr/bin
