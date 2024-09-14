#!/bin/bash
# This is the manual execution for the development of the Dockerfile.
# Started from https://www.reddit.com/r/valheim/comments/s1os21/create_your_own_free_dedicated_server/

# Run full upgrade
echo "Starting apt upgrades..."
sudo apt upgrade
sudo apt full-upgrade
echo "Finished apt upgrades"

# Install dependencies
echo "Installing building tools..."
sudo apt install git build-essential cmake
echo "Installed building tools."

echo "Fetching Box86 (required for SteamCMD) source code..."
git clone https://github.com/ptitSeb/box86
echo "Getting Box86 build dependencies..."
sudo dpkg --add-architecture armhf
sudo apt update
sudo apt install gcc-arm-linux-gnueabihf
sudo apt install libc6:armhf
sudo apt install libncurses5:armhf
sudo apt install libstdc++6:armhf

echho "Building Box86 using cmake..."
cd box86
mkdir build
cd build
# Use Raspberry PI 4 ARM
cmake .. -DRPI4ARM64=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo
make -j$(nproc)
echo "Installing Box86..."
sudo make install
echo "Restarting system service systemd-binfmt..."
sudo systemctl restart systemd-binfmt
cd ../..

echo "Fetching Box64..."
git clone https://github.com/ptitSeb/box64.git
echo "Building Box64..."
cd box64m
mkdir build
cd build
cmake .. -DRPI4ARM64=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo
make -j$(nproc)
echo "Installing Box64..."
sudo make install
echo "Restarting system service systemd-binfmt..."
sudo systemctl restart systemd-binfmt

echo "Preparing SteamCMD install..."
mkdir steamcmd
cd steamcmd
echo "Downloading SteamCMD..."
curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
echo "Starting SteamCMD for the first time. Type 'quit' when SteamCMD finished updating."
./steamcmd.sh