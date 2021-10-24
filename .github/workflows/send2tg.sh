## Script to make zip and send it to telegram channel
DATE_TIME=$(date +"%Y%m%d-%H%M")

function make_zip() {
    cp out/arch/arm64/boot/Image.gz-dtb AnyKernel3

# Extract Names from defined values
    export kname="$(grep 'CONFIG_LOCALVERSION=' arch/arm64/configs/$DEFCONFIG | cut -d '"' -f2 | sed 's*-**1')"
    export kversion=$(grep -m1 VERSION Makefile | cut -d ' ' -f3).$(grep -m1 PATCHLEVEL Makefile | cut -d ' ' -f3).$(grep -m1 SUBLEVEL Makefile | cut -d ' ' -f3)
    export FILENAME="$kname-Kernel-$device-$kversion"

    echo -e "\nKernel Name: $kname"
    echo -e "Kernel Version: $kversion\n"

    cd AnyKernel3
    sed s*Kernel_name*$kname* anykernel.sh
    zip -r9 ${FILENAME}-${DATE_TIME}.zip *
    cd ..
}

function send_zip() {
    ZIP="AnyKernel3/$FILENAME"

    # Download thumbnail
    curl -L https://github.com/aryankaran/images/raw/major/Android%20Kernel.png --output image
    
    # Send the zip to telegram through bot
    curl "https://api.telegram.org/bot${BOT_TOKEN}/sendDocument?chat_id=${CHAT_ID}" \
    -F document=@$ZIP -F caption="✔ md5 : <code>`echo -e "\n$(md5sum $ZIP | cut -d " " -f1)\n\n🔷 "`</code> sha256 : <code>`echo -e "\n$(md5sum $ZIP | cut -d " " -f1)\n\n💥"`</code> Repo Link: $repo `echo -e "\n\n🧲"` Branch Name: <code>$branch </code> `echo -e "\n\n👑"` Kernel Version: <code>$kversion </code> `echo -e "\n\n💦"` defconfig: <code>$DEFCONFIG </code>" -F "parse_mode=HTML" \
    -F thumb=@image
}

# Starts here
make_zip
send_zip
