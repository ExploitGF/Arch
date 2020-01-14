read -p "Enter username: " username
read -p "Enter DISK(sda or sdb): " hdd

USER="$username"
DISK="$hdd"
DISK1=${hdd}'1'
DISK2=${hdd}'2'
DISK3=${hdd}'3'
DISK4=${hdd}'4'

loadkeys ru
setfont cyr-sun16

timedatectl set-ntp true
(
  echo g;
  echo;
  echo n;
  echo;
  echo;
  echo +512M;

#  echo n;
#  echo;
#  echo;
#  echo;
#  echo;
#  echo +20G;

#  echo n;
#  echo;
#  echo;
#  echo;
#  echo +2048M;

  echo n;
  echo;
  echo;
  echo;
  echo t;
  echo 1;
  echo 1;
  echo w;
) | fdisk /dev/$DISK

#fdisk -l

mkfs.vfat -F32 -n "BOOT_FS" /dev/$DISK1
#mkfs.ext4 -L "BOOT_FS" /dev/$DISK1
mkfs.ext4 -L "ROOT_FS" /dev/$DISK2
#mkswap /dev/$S_DISK -L swap
#mkfs.ext4  /dev/$H_DISK -L home

mount /dev/$DISK2 /mnt
mkdir /mnt/{boot,home}
mount /dev/$DISK1 /mnt/boot


pacman -Sy --noconfirm --needed reflector
sudo reflector -c "Belarus" -c "Russia" -c "Ukraine" -c "Poland" -f 20 -l 20 -p https -p http -n 20 --save /etc/pacman.d/mirrorlist --sort rate

pacstrap /mnt base base-devel linux linux-firmware

genfstab -pU /mnt >> /mnt/etc/fstab


arch-chroot /mnt
#arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/ExploitGF/Arch/master/arch_install_2.sh)"

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
echo
mkinitcpio -p linux
echo
passwd
echo
pacman -Syy
#GRUB
#pacman -S --noconfirm --needed grub
pacman -S --noconfirm --needed grub efibootmgr dosfstools os-prober mtools
echo
bootctl install
echo
cat >> /boot/loader/loader.conf << EOF
timeout 4
default arch
  
EOF
echo
cat >> /boot/loader/entries/arch.conf << EOF
title ArchLinux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options root=/dev/$DISK2 rw
  
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
sudo systemctl enable ntpd.service
# sudo systemctl enable lxdm.service
sudo systemctl enable acpid.service
sudo systemctl enable nscd.service
sudo systemctl enable dhcpcd.service
#systemctl enable NetworkManager.service
systemctl enable sshd
