## Script to setup the environment and download the required tools

function setup () {
    # Install dependencies
    sudo apt install bc bash git-core gnupg build-essential \
        zip curl make automake autogen autoconf autotools-dev libtool shtool python \
        m4 gcc libtool zlib1g-dev flex bison libssl-dev
    
    # Download gcc
    git clone git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-eabi-4.8 -b nougat-mr1.2-release --depth=1 gcc

    # Download Clang
    wget https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/nougat-mr1.2-release/clang-2658975.tar.gz
    mkdir clang
    tar xvzf clang-2658975.tar.gz -C clang
    rm clang-2658975.tar.gz

    # Clone AnyKernel3
    git clone https://github.com/Dhina17/AnyKernel3

}

# Starts here
setup