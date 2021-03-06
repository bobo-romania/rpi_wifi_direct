#!/bin/sh 
## wget -P --no-check-certificate /home/pirate https://raw.githubusercontent.com/jancelin/rpi_wifi_direct/master/raspberry_pi3/install_wifi_direct_rpi3.sh; chmod +x /home/pirate/install_wifi_direct_rpi3.sh; bash -x /home/pirate/install_wifi_direct_rpi3.sh


sudo apt-get update && 
sudo apt-get upgrade &&
sudo apt-get install dnsmasq hostapd &&
wget -P --no-check-certificate /etc https://raw.githubusercontent.com/jancelin/rpi_wifi_direct/master/raspberry_pi3/dhcpcd.conf &&
wget -P --no-check-certificate /etc/network/interfaces.d https://raw.githubusercontent.com/jancelin/rpi_wifi_direct/master/raspberry_pi3/wlan0 &&
sudo service dhcpcd restart &&
sudo ifdown wlan0; sudo ifup wlan0 &&
wget -P --no-check-certificate /etc/hostapd https://raw.githubusercontent.com/jancelin/rpi_wifi_direct/master/raspberry_pi3/hostapd.conf &&
#sudo /usr/sbin/hostapd /etc/hostapd/hostapd.conf 
mv /etc/default/hostapd /etc/default/hostapd.bak &&
wget -P --no-check-certificate /etc/default https://raw.githubusercontent.com/jancelin/rpi_wifi_direct/master/raspberry_pi3/hostapd &&
sudo mv /etc/dnsmasq.conf /etc/dnsmasq.conf.orig &&
wget -P --no-check-certificate /etc https://raw.githubusercontent.com/jancelin/rpi_wifi_direct/master/raspberry_pi3/dnsmasq.conf &&
sudo mv /etc/sysctl.conf /etc/sysctl.conf.bak &&
wget -P --no-check-certificate /etc https://raw.githubusercontent.com/jancelin/rpi_wifi_direct/master/raspberry_pi3/sysctl.conf &&
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward" &&
sleep 5
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE  
sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT  
sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT 
sleep 5
sudo sh -c "iptables-save > /etc/iptables.ipv4.nat" &&
sudo mv /etc/rc.local /etc/rc.local.bak &&
wget -P --no-check-certificate /etc https://raw.githubusercontent.com/jancelin/rpi_wifi_direct/master/raspberry_pi3/rc.local &&
chmod +x  /etc/rc.local &&
sudo service hostapd start 
sudo service dnsmasq start



