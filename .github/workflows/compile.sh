# Kernel compile script
ROOT_DIR=$(pwd)

function compile() {
    # export the arch
    export ARCH=arm64

    # user and Hostname
    export KBUILD_BUILD_USER=aryan
    export KBUILD_BUILD_HOST=aryankaran

    # make clang/gcc PATH available
    PATH=:"${ROOT_DIR}/clang/bin:${PATH}:${ROOT_DIR}/gcc/bin:${PATH}"

    # arm32 cc
    export CC_FOR_BUILD=clang

    # make the config
    make O=out ${DEFCONFIG}

    # Start the build
    make -j$(nproc --all) O=out \
                    ARCH=arm64 \
                    CC=clang \
                    CLANG_TRIPLE=aarch64-linux-gnu- \
                    CROSS_COMPILE=aarch64-linux-android-
}


# Starts here
compile
