read -p "Enter username: " username
read -p "Enter hostname: " host
# read -p "Enter DISK(sda or sdb): " hdd

USER="$username"
# DISK="$hdd"
# DISK1=${hdd}'p1'
# DISK2=${hdd}'p2'
# DISK3=${hdd}'p3'
# DISK4=${hdd}'p4'

echo "$host" > /etc/hostname
echo
ln -svf /usr/share/zoneinfo/Asia/Yaketerinburg /etc/localtime
# Для Русского языка раскоментируем ниже
echo
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen 
echo
locale-gen
echo
echo "LANG="ru_RU.UTF-8"" > /etc/locale.conf
echo
#echo "KEYMAP=ru" >> /etc/vconsole.conf
echo "FONT=cyr-sun16" >> /etc/vconsole.conf
echo
echo
mkinitcpio -p linux-lts
echo
passwd
echo
pacman -Syy
#GRUB
#pacman -S --noconfirm --needed grub
pacman -S --noconfirm --needed grub efibootmgr dosfstools os-prober mtools iwd
echo
bootctl install
echo
cat >> /boot/loader/loader.conf << EOF
timeout 0
default arch
  
EOF
echo
cat >> /boot/loader/entries/arch.conf << EOF
title ArchLinux
linux /vmlinuz-linux-lts
initrd /initramfs-linux-lts.img
options root=/dev/nvme0n1p3 rw
  
EOF
echo
useradd -m -g users -G wheel -s /bin/bash $USER
echo
passwd $USER
echo
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
echo
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
echo
pacman -Syy
#echo
#echo "Arch Linux Virtualbox"
#read -p "1 - Yes, 0 - No: " xorg_setting
#if [[ $xorg_setting == 0 ]]; then
#  xorg_install="xorg-server xorg-apps xorg-xinit"
#elif [[ $xorg_setting == 1 ]]; then
#  xorg_install="xorg-server xorg-apps xorg-xinit virtualbox-guest-utils"
#fi
echo
pacman -S --noconfirm --needed pacman -S --noconfirm --needed
echo
pacman -S --noconfirm --needed dialog wpa_supplicant
echo
pacman -S --noconfirm --needed wget curl networkmanager openssh
#echo
pacman -S --noconfirm --needed cmake make
#echo
#pacman -S --noconfirm --needed xfce4-panel xfce4-terminal thunar chromium lxdm gtk-engines mousepad gvfs
echo
# Установка AUR
sudo pacman -Sy --noconfirm --needed curl git go xdg-user-dirs

#if [[ ! $(command -v yay) ]]
#then
#  echo "Installing Yay. Download pkg.sh"
#  mkdir -p /home/$USER/tmp
#  cd /home/$USER/tmp
#  git clone https://aur.archlinux.org/yay.git
#  cd yay
#  makepkg -si
#  cd -
#  yay -Sy --noconfirm
#  echo
#  echo "${bold}Install Yay: yes.${normal}"
#  echo
#fi
echo
echo "Up user dirs"
xdg-user-dirs-update
echo
echo "Starting services"
echo
systemctl enable ntpd.service
# sudo systemctl enable lxdm.service
systemctl enable acpid.service
systemctl enable nscd.service
systemctl enable dhcpcd.service
#systemctl enable NetworkManager.service
#systemctl enable sshd


