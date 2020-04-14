#################### Section 7 Continue in chroot ####################
sudo printf 'pacman -Syyy linux linux-headers \n\n\nexit\n' | sudo arch-chroot /mnt
sudo echo "Installed Linux and Linux Headers"
sudo sleep 5s
sudo printf 'sudo pacman -Syyy nano vim vi\n\n\nexit\n' | sudo arch-chrrot /mnt
sudo echo "Installed Text Editors"
sudo sleep 5s
sudo printf 'sudo pacman -Syyy base-devel openssh\n\n\nexit\n' | sudo arch-chrrot /mnt
sudo echo "Installed Developers Base and SSH"
sudo sleep 5s
sudo printf 'sudo pacman -Syyy networkmanager wpa_supplicant wireless_tools netctl\n\n\nexit\n' | sudo arch-chrrot /mnt
sudo echo "Installed Networking Packages"
sudo sleep 5s
sudo printf 'sudo systemctl enable sshd\nexit\n' | sudo arch-chrrot /mnt
sudo printf 'sudo systemctl enable NetworkManager\nexit\n' | sudo arch-chrrot /mnt
sudo printf 'sudo pacman -Syyy lvm2\n\n\nexit\n' | sudo arch-chrrot /mnt
sudo echo "Installed LVM2 package"
sudo sleep 5s
sudo echo "Section 6 END"

#################### Section 7 ####################

sudo echo "Section 7 START"
sudo sed -i 'HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)/block/block encrypt lvm2' /etc/mkinitcpio.conf
sudo mkinitcpio -p linux
sudo sleep 5s
sudo sed -i "s/#en_AU.UTF-8/en_AU.UTF-8/" /etc/locale.gen && sudo sed -i "s/en_US.UTF-8/#en_US.UTF-8/" /etc/locale.gen
sudo locale-gen
# sudo passwd
# sudo useradd -m -g users USERNAME
# sudo passwd USERNAME
# create a group for admins???
sudo echo "Section 7 END"

#################### Section 8 ####################

sudo echo "Section 8 START"
sudo printf 'sudo pacman -S grub efibootmgr dosfstools os-prober mtools\n\n\nexit\n' | sudo arch-chrrot /mnt
sudo sed -i "s/#GRUB_ENABLE_CRYPTODISK=y/GRUB_ENABLE_CRYPTODISK=y/" /etc/default/grub
sudo sed -i 'GRUB_CMDLINE_LINUX_DEFAULT='loglevel=3 quiet/quiet/cryptdevice=/dev/sda3:volgroup0:allow-discards quiet' /etc/default/grub
sudo mkdir /boot/EFI
sudo mount /dev/sda1 /boot/EFI
sudo grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
sudo mkdir /boot/grub/locale
sudo cp /usr/share/locale/en@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo cp /etc/fstab /etc/fstab.bak
sudo echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
sudo echo "Section 8 END"
#################### Section 9 ####################
sudo echo "Section 9 START"
sudo printf 'sudo pacman -S intel-ucode\n\n\nexit\n' | sudo arch-chroot /mnt
sudo printf 'sudo pacman -S xorg-server\n\n\nexit\n' | sudo arch-chroot /mnt
sudo printf 'sudo pacman -S mesa\n\n\nexit\n' | sudo arch-chroot /mnt
sudo umount -a
sudo poweroff
sudo echo "Section 9 END"
#################### END OF SCRIPT ####################
