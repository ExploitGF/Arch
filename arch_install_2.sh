USER="shurikeen"
DISK="sdb"


echo "arch" > /etc/hostname
echo
ln -svf /usr/share/zoneinfo/Asia/Yaketerinburg /etc/localtime
# Для Русского языка раскоментируем ниже
#echo
#echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
#echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen 
#echo
#locale-gen
#echo
#echo "LANG="ru_RU.UTF-8"" > /etc/locale.conf
#echo
#echo "KEYMAP=ru" >> /etc/vconsole.conf
#echo "FONT=cyr-sun16" >> /etc/vconsole.conf
#echo
mkinitcpio -p linux
echo
passwd
echo
pacman -Syy
pacman -S --noconfirm --needed grub
grub-install /dev/$DISK
echo
grub-mkconfig -o /boot/grub/grub.cfg
echo
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
echo
echo "Arch Linux Virtualbox"
read -p "1 - Yes, 0 - No: " xorg_setting
if [[ $xorg_setting == 0 ]]; then
  xorg_install="xorg-server xorg-apps xorg-xinit"
elif [[ $xorg_setting == 1 ]]; then
  xorg_install="xorg-server xorg-apps xorg-xinit virtualbox-guest-utils"
fi
echo
pacman -S --noconfirm --needed $xorg_install
echo
pacman -S --noconfirm --needed dialog wpa_supplicant
echo
pacman -S --noconfirm --needed wget curl networkmanager
echo
systemctl enable NetworkManager.service
