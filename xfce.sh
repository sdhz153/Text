#!/bin/bash
dnf update
dnf install dejavu-fonts liberation-fonts gnu-*-fonts google-*-fonts
dnf install xorg-*
dnf install xfwm4 xfdesktop xfce4-* xfce4-*-plugin network-manager-applet *fonts
dnf install lightdm lightdm-gtk
echo 'user-session=xfce' >> /etc/lightdm/lightdm.conf.d/60-lightdm-gtk-greeter.conf
systemctl start lightdm
systemctl enable lightdm
systemctl set-default graphical.target
systemctl disable gdm

