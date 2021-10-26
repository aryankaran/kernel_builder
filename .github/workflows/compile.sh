# Kernel compile script
ROOT_DIR=$(pwd)

# Where am I
ls -1hA && pwd
cd aryan/$(echo $repo_link | cut -d / -f5 | sed s*.git**)
ls -1hA && pwd

function compile() {
    # export the arch
    export ARCH=arm64

    # user and Hostname
    export KBUILD_BUILD_USER=aryan
    export KBUILD_BUILD_HOST=aryankaran

    # make clang/gcc PATH available
    PATH=:"${ROOT_DIR}/clang/bin:${PATH}:${ROOT_DIR}/gcc/bin:${PATH}:${ROOT_DIR}/gcc-32/bin:${PATH}"

    # arm32 cc
    # export CC_FOR_BUILD=clang
    export CROSS_COMPILE_ARM32=arm-linux-androideabi-

    # Clean directory before build
    ls -1Ah out
    rm -rf out

    # Tell me free space before each build
    df -h
    free -h
    
    # make the config
    make O=out ${DEFCONFIG}

    # Start the build
    make -j`expr 2 \* $(nproc --all)` O=out \
                    ARCH=arm64 \
                    CC=clang \
                    CLANG_TRIPLE=aarch64-linux-gnu- \
                    CROSS_COMPILE=aarch64-linux-android-
}

function build-send-all() {
for branch in `curl https://api.github.com/repos/$(echo $repo_link | sed s*https://github.com/** | sed s*.git**)/branches | grep name | cut -d '"' -f4`;do
export DEFCONFIG="$DEFCONFIG"
export export device="$device"
export reference="$branch"
git switch $branch
compile || echo "Failed to compile $DEFCONFIG"
sleep 40s
bash -c "$(wget -O- https://github.com/aryankaran/kernel_builder/raw/batch/.github/workflows/send2tg.sh)" || echo "Failed to Send to telegram";done
}

# Starts here
for DEFCONFIG in $CONFIG; do echo using defconfig: $DEFCONFIG &&  build-send-all; done
