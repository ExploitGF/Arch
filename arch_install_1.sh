USER="shutikeen"
DISK="sda"
B_DISK="sda1"
R_DISK="sda2"
S_DISK="sda3"
H_DISK="sda4"

loadkeys ru
setfont cyr-sun16

timedatectl set-ntp true

(
  echo o;

  echo n;
  echo;
  echo;
  echo;
  echo +512M;

  echo n;
  echo;
  echo;
  echo;
  echo;
#  echo +20G;

#  echo n;
#  echo;
#  echo;
#  echo;
#  echo +2048M;

  echo n;
  echo p;
  echo;
  echo;
  echo a;
  echo 1;
  echo t;
  echo 1;
  echo ef;
  echo w;
) | fdisk /dev/$DISK

fdisk -l

mkfs.fat -F32  /dev/$B_DISK -L boot
mkfs.ext4  /dev/$R_DISK -L root
#mkswap /dev/$S_DISK -L swap
#mkfs.ext4  /dev/$H_DISK -L home

mount /dev/$R_DISK /mnt
mkdir /mnt/{boot,home}
#mount /dev/$B_DISK /mnt/boot
#swapon /dev/$S_DISK
#mount /dev/$H_DISK /mnt/home

pacman -Sy --noconfirm --needed reflector
sudo reflector -c "Belarus" -c "Russia" -c "Ukraine" -c "Poland" -f 20 -l 20 -p https -p http -n 20 --save /etc/pacman.d/mirrorlist --sort rate

pacstrap /mnt base base-devel

genfstab -pU /mnt >> /mnt/etc/fstab

#arch-chroot /mnt
#arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/ExploitGF/Arch/master/arch_install_2.sh)"
