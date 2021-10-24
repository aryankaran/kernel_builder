# Kernel compile script
ROOT_DIR=$(pwd)

# Where am I
ls -1hA && pwd
git pull

export repo_link="$(git remote get-url origin | sed s*https://**)"

function compile() {
    # export the arch
    export ARCH=arm64

    # user and Hostname
    export KBUILD_BUILD_USER=aryan
    export KBUILD_BUILD_HOST=aryankaran

    # make clang/gcc PATH available
    PATH=:"${ROOT_DIR}/clang/bin:${PATH}:${ROOT_DIR}/gcc/bin:${PATH}:${ROOT_DIR}/gcc-32/bin:${PATH}"

    # arm32 cc
    export CC_FOR_BUILD=clang
    export CROSS_COMPILE_ARM32=arm-linux-androideabi-

    # make the config
    make O=out ${DEFCONFIG}

    # Start the build
    make -j$(nproc --all) O=out \
                    ARCH=arm64 \
                    CC=clang \
                    CLANG_TRIPLE=aarch64-linux-gnu- \
                    CROSS_COMPILE=aarch64-linux-android-
}

function build-send-all() {
for branch in `curl https://api.github.com/repos/$(echo $repo_link | sed s*github.com/**)/branches | grep name | cut -d '"' -f4`;do
export reference="$branch"
git switch $branch
compile
bash -c "$(wget -O- https://github.com/aryankaran/kernel_builder/raw/aryankaran-patch-1/.github/workflows/send2tg.sh)" || echo "Failed to compile";done
}

# Starts here
for DEFCONFIG in $DEFCONFIG; do build-send-all; done
