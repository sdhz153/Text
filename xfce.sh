#!/bin/bash
sudo dnf update
sudo dnf install dejavu-fonts liberation-fonts gnu-*-fonts google-*-fonts
sudo dnf install xorg-*
sudo dnf install xfwm4 xfdesktop xfce4-* xfce4-*-plugin network-manager-applet *fonts
sudo dnf install lightdm lightdm-gtk
echo 'user-session=xfce' >> /etc/lightdm/lightdm.conf.d/60-lightdm-gtk-greeter.conf
sudo systemctl start lightdm
sudo systemctl enable lightdm
sudo systemctl set-default graphical.target
systemctl disable gdm

