
#TODO: Handle arguments correctly
BLKDEV=$@
HOSTNAME="viper"

info () {

	echo -ne "\e[34m[+]\e[0m "
	echo -n $1

}

ok() {

	echo -e " \e[32mOK\e[0m"

}

fail() {

	echo -e " \e[31mFAIL\e[0m"

}

banner () {

clear
echo "
        .--'   ..............             '.............'             '..............     ....''    
     '+dmMMd  'hdmmmmmmmmmmmh             .dmmmmmmmmmmmmo             .dmmmmmmmmmmmms   :dm:.:yh    
    +ms.hMMd  'hmmmmmmmmmmmmh             .dmmmmmmmmmmmmo             .dmdmmmmmmmmmms   :mMmhs+/    
   hMhoomMMmo/'hmmdmmmmmmmmmy             .dmmdmmmmmmmmmo             .dmdmmmdddmmmms   o-'-/sNM:   
   ''''/dNNm:''hmmmhyyyyyyyys.............-yyhdddmmmdmdh+.............-yhhhhhhdddmmms   syo//+h+'   
        ````  'hmmd+//////////////////////////hmmmmmmdd+/////////////////////odddmmms               
              'hmmd+//////////////////////////hddmmmmdy//////////////////////odddmmms               
              'hmmd+//////yhy''''.://////////odmmmmmmd+//////:........-yyyyyyhdddmmms               
      '-/++/' 'hmmd+//////dmy  '-//////////+yddmmmmmds///////.        .dmdmmdddmmmmms               
   '+dNd/.    'hmmd+//////dmy'.//////////::ddmmmmmmdh///////:--::::::::syhdmmmmmmmmms   .+o//+o/'   
   hMMMoshmho''hmmdyyyyyyyddy://///////:. .dmdmmmdmdo/////////////////////+ohddmmmmms  oNN-   +MN:  
   hMMy   NMM+'hmmdmmmmmmdh+/////////:.   .dmdmmmdmy///////::-.....-:////////+hmmmmms 'mMN    -MMs  
   '+ydsoydy/ 'hmmmmmdmdho/////////:.     .ddddmdmmdddhh+.'          ':////////hmmmms  -hN+''.hNs'  
              'hmdmddmds/////////:.'  ':://+++dmdmmmmmmdo             '////////smmmms    ':+mNh.'   
              'hmdmdds/////////:-'    '///////dmmddhhhhh+..           .////////ydmmms       ./+/:'  
              'hmddy+/////////-'''''''.///////hmmdh////////-'        .:///////odmmmms               
              'hmdo///////////////////////////hdmmdh+////////:--..--:///////+ydmmmmms               
    ./+ooo+-' 'hmdo///////////////////////////hddmmmdyo+//////////////////oydmmmmmmms '...'   ....' 
   oNM+''dMMh 'hmdsooooooooo+::::::::::::::ooohmdmmmddmdo.---:::::::---yddmmdmmmmmmms ':mNNo. -yy-' 
   '-:./hMNs. 'hmdmmmdddddddy             .dmmmmmmmmmmmmo             .dmmmmmmmmmmmms   h:oNNo.+o   
   '/yNNy/'.:''hmmmmmmmmmmmmy             .dmmmmmmmmmmmmo             .dmmmmmmmmmmmms   h- 'oNNdo   
   shhhyyyyhy''oyyyyyyyyyyyyo             .syyyyyyyyyyyy/             'syyyyyyyyyyyy+ .:yo-  '+h/ 
"
echo
echo
echo "                                     VIPER MASTER BUILD SCRIPT"
echo "                        WARNING: This will format the provided block device!"
echo
echo
#sleep 5

}
                                                                                                    

connCheck () {


	info "Checking internet connectivity..."

	if ! ping -c 1 8.8.8.8 >/dev/null 2>/dev/null; then
		fail
		exit 1
	fi

	ok

}

prepBlk () {

	info "Prepping $BLKDEV (this may take a couple min)..."
	umount -af 2>/dev/null
	#shred -z $BLKDEV
	parted --script $BLKDEV mklabel msdos mkpart primary 0% 100%
	mkfs.ext4 ${BLKDEV}1 2&>/dev/null
	ok

}

baseInstall () {

	info "Mounting $BLKDEV..."
	mount ${BLKDEV}1 /mnt
	ok

	info "Installing base Arch packages..."
	echo
	pacstrap /mnt base linux linux-firmware

	info "Generating fstab..."
	genfstab -U /mnt >> /mnt/etc/fstab
	ok

}

config () {

	arch-chroot /mnt

	info "Setting locales..."
	echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen
	echo "LANG=en_US.UTF-8" > /etc/locale.conf
	ok

	info "Setting hostname..."
	echo $HOSTNAME > /etc/hostname
	ok

	info "Setting hosts file..."
	echo -e "127.0.0.1\t$HOSTNAME" > /etc/hosts
	echo -e "::1\t$HOSTNAME" >> /etc/hosts
	ok

	info "Setting up users & passwords..."
	useradd -m user
	echo "user:password" | chpasswd
	echo "root:password" | chpasswd
	ok

}

main () {

	banner
	connCheck
	prepBlk
	baseInstall
	#configs

}


# call the main func
main
