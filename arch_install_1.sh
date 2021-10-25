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

pacstrap /mnt base base-devel linux-lts linux-firmware nano mc

genfstab -pU /mnt >> /mnt/etc/fstab



arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/ExploitGF/Arch/master/arch_install_2.sh)"
