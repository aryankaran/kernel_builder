## Script to setup the environment and download the required tools

function setup () {
    # Install dependencies
    sudo apt update -qq && sudo apt install bc bash git-core gnupg build-essential \
        zip curl make automake autogen autoconf autotools-dev ccache libtool shtool python \
        m4 gcc libtool zlib1g-dev flex bison libssl-dev -y -qq
    
    # Download gcc
    git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 -b android-10.0.0_r47 --depth=1 gcc
    git clone https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9 -b android-10.0.0_r47 --depth=1 gcc-32

    # Download Clang
    wget https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/tags/android-11.0.0_r37/clang-r365631c.tar.gz
    mkdir clang
    tar xvzf clang-r365631c.tar.gz -C clang
    rm clang-r365631c.tar.gz

    pwd && mkdir aryan && cd aryan
    git clone $repo_link
    cd $(echo $repo_link | cut -d / -f5)
    git pull
    
    # Clone AnyKernel3
    git clone https://github.com/aryankaran/AnyKernel3 -b $device

}

# Starts here
setup
