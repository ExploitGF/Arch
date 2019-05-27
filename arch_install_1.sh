USER="shurikeen"
DISK="sda"
DISK1="sda1"
DISK2="sda2"
DISK3="sda3"
DISK4="sda4"

loadkeys ru
setfont cyr-sun16

timedatectl set-ntp true
(
  echo d;
  echo;
  echo d;
  echo;
  echo d;
  echo;
  echo d;
  echo;
  echo w;
  echo;
) | fdisk /dev/$DISK

(
  echo w;
  echo;
  echo Y;
  echo;
) |gdisk /dev/$DISK

(
  echo n;
  echo;
  echo;
  echo;
  echo +1G;

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

#fdisk -l

mkfs.vfat -F32 -n "BOOT_FS" /dev/sda1
mkfs.ext4 -L "ROOT_FS" /dev/sda2
#mkswap /dev/$S_DISK -L swap
#mkfs.ext4  /dev/$H_DISK -L home

mount /dev/sda2 /mnt
mkdir /mnt/{boot,home}
mount /dev/sda1 /mnt/boot


pacman -Sy --noconfirm --needed reflector
sudo reflector -c "Belarus" -c "Russia" -c "Ukraine" -c "Poland" -f 20 -l 20 -p https -p http -n 20 --save /etc/pacman.d/mirrorlist --sort rate

pacstrap /mnt base base-devel

genfstab -pU /mnt >> /mnt/etc/fstab


#arch-chroot /mnt
arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/ExploitGF/Arch/master/arch_install_2.sh)"
