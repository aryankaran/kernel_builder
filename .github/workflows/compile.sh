# Kernel compile script
ROOT_DIR=$(pwd)

function compile() {
    # export the arch
    export ARCH=arm 
    export SUBARCH=arm 

    # user and Hostname
    export KBUILD_BUILD_USER=aryan
    export KBUILD_BUILD_HOST=aryankaran

    # make clang/gcc PATH available
    PATH=:"${ROOT_DIR}/clang/bin:${PATH}:${ROOT_DIR}/gcc/bin:${PATH}"

    # make the config
    make O=out TARGET_ARCH=arm gh6_mt6580_defconfig

    # Start the build
    make -j$(nproc --all) O=out \
                    TARGET_ARCH=arm \
                    CROSS_COMPILE=arm-eabi-
}


# Starts here
compile
