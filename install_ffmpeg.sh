#!/bin/bash

#This script will compile and install a static ffmpeg build with support for nvenc un ubuntu.
#See the prefix path and compile options if edits are needed to suit your needs.

#install required things from apt
installLibs(){
echo "Installing prerequisites"
sudo apt-get update && sudo apt dist-upgrade --yes \
sudo apt-get update -qq && sudo apt-get -y install \
  autoconf \
  automake \
  build-essential \
  cmake \
  git-core \
  libass-dev \
  libc6 \
  lib6-dev \
  libopus-dev \
  libfreetype6-dev \
  libgpac-dev \
  libgnutls28-dev \
  libnumai \
  libnumai-dev \
  libx265-dev \
  libnuma-dev \
  librsvg2-dev \
  libsdl2-dev \
  libtheora-dev \
  libtool \
  libva-dev \
  libvdpau-dev \
  libvorbis-dev \
  libxcb1-dev \
  libxcb-shm0-dv \
  libxcb-xfixes0-dev \
  meson \
  ninja-build \
  pkg-config \
  texinfo \
  texi2html \
  wget \
  yasm \
  unzip \
  zlib1g-dev
}

#install CUDA SDK
InstallCUDASDK(){
	echo "Installing CUDA and the latest driver repositories from repositories"
	#https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#ubuntu-installation
	#https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=20.04&target_type=deb_local
	cd ~/ffmpeg_sources
	# keeping the old script for reference
	#wget -c -v -nc https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_9.2.88-1_amd64.deb
	#sudo dpkg -i cuda-repo-ubuntu1604_9.2.88-1_amd64.deb
	#sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
	#sudo apt-get -y update
	#sudo apt-get -y install cuda
	# this is the way to install cuda in 2021
	# https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=20.04&target_type=deb_local
	wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
	sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
	wget https://developer.download.nvidia.com/compute/cuda/11.6.1/local_installers/cuda-repo-ubuntu2004-11-6-local_11.6.1-510.47.03-1_amd64.deb
	sudo dpkg -i cuda-repo-ubuntu2004-11-6-local_11.6.1-510.47.03-1_amd64.deb
	sudo apt-key add /var/cuda-repo-ubuntu2004-11-6-local/7fa2af80.pub
	sudo apt-get update
	sudo apt-get -y install cuda
	sudo add-apt-repository ppa:graphics-drivers/ppa
	sudo apt-get update && sudo apt-get -y upgrade
}

#Install nvidia SDK
installSDK(){
	echo "Installing the nVidia NVENC SDK."
	cd ~/ffmpeg_sources
	git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git
	cd nv-codec-headers
	make
	sudo make install
}

#Compile nasm
compileNasm(){
	echo "Compiling nasm"
	cd ~/ffmpeg_sources
	get https://www.nasm.us/pub/nasm/stable/nasm-2.15.05.tar.gz
	tar xzvf nasm-2.15.05.tar.gz
	cd nasm-2.15.05
	./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
	make -j$(nproc)
	make -j$(nproc) install
	make -j$(nproc) distclean
}

#Compile libx264
compileLibX264(){
	echo "Compiling libx264"
	cd ~/ffmpeg_sources
	#wget http://download.videolan.org/pub/x264/snapshots/x264-snapshot-20191217-2245.tar.bz2
	#tar xjvf x264-snapshot-20191217-2245.bz2
	wget https://code.videolan.org/videolan/x264/-/archive/master/x264-master.tar.bz2
	tar xjvf x264-master.tar.bz2
	cd x264-master*
	PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static
	PATH="$HOME/bin:$PATH" make -j$(nproc)
	make -j$(nproc) install
	make -j$(nproc) distclean
}

#Compile libx265
compileLibX265(){
	cd ~/ffmpeg_sources && \
 	 git clone https://github.com/videolan/x265 && \
 	 cd x265/build/linux && \
 	 cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source && \
 	 make && \
 	 make install
}

#Compile libfdk-acc
compileLibfdkcc(){
	echo "Compiling libfdk-cc"
	sudo apt-get install unzip
	cd ~/ffmpeg_sources
	wget -O fdk-aac.zip https://github.com/mstorsjo/fdk-aac/zipball/master
	unzip fdk-aac.zip
	cd mstorsjo-fdk-aac*
	autoreconf -fiv
	./configure --prefix="$HOME/ffmpeg_build" --disable-shared
	make -j$(nproc)
	make -j$(nproc) install
	make -j$(nproc) distclean
}

#Compile libmp3lame
compileLibMP3Lame(){
	echo "Compiling libmp3lame"
	sudo apt-get install nasm
	cd ~/ffmpeg_sources
	wget http://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz
	tar xzvf lame-3.100.tar.gz
	cd lame-3.100
	./configure --prefix="$HOME/ffmpeg_build" --enable-nasm --disable-shared
	make -j$(nproc)
	make -j$(nproc) install
	make -j$(nproc) distclean
}

#Compile libopus
compileLibOpus(){
	echo "Compiling libopus"
	cd ~/ffmpeg_sources
	wget http://downloads.xiph.org/releases/opus/opus-1.3.1.tar.gz
	tar xzvf opus-1.3.1.tar.gz
	cd opus-1.3.1
	./configure --prefix="$HOME/ffmpeg_build" --disable-shared
	make -j$(nproc)
	make -j$(nproc) install
	make -j$(nproc) distclean
}

#compile liboam-av1
compileLibAom(){
	echo "Compiling linbaom-av1"
	mkdir -p ~/ffmpeg_sources/libaom && \
	  cd ~/ffmpeg_sources/libaom && \
	  git clone https://aomedia.googlesource.com/aom && \
	  cmake ./aom && \
	  make && \
	  sudo make install
}

#Compile libvpx
compileLibPvx(){
	echo "Compiling libvpx"
	cd ~/ffmpeg_sources
	git clone https://chromium.googlesource.com/webm/libvpx
	cd libvpx
	PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-examples --enable-runtime-cpu-detect --enable-vp9 --enable-vp8 \
	--enable-postproc --enable-vp9-postproc --enable-multi-res-encoding --enable-webm-io --enable-better-hw-compatibility --enable-vp9-highbitdepth --enable-onthefly-bitpacking --enable-realtime-only \
	--cpu=native --as=nasm
	PATH="$HOME/bin:$PATH" make -j$(nproc)
	make -j$(nproc) install
	make -j$(nproc) clean
}

#Compile ffmpeg
compileFfmpeg(){
	echo "Compiling ffmpeg"
	cd ~/ffmpeg_sources
	git clone https://github.com/FFmpeg/FFmpeg -b master
	cd FFmpeg
	PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
	  --pkg-config-flags="--static" \
	  --prefix="$HOME/ffmpeg_build" \
	  --extra-cflags="-I$HOME/ffmpeg_build/include" \
	  --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
	  --bindir="$HOME/bin" \
	  --enable-cuda-sdk \
	  --enable-cuvid \
	  --enable-libnpp \
	  --extra-cflags="-I/usr/local/cuda/include/" \
	  --extra-ldflags=-L/usr/local/cuda/lib64/ \
	  --enable-gpl \
	  --enable-libass \
	  --enable-libfdk-aac \
	  --enable-vaapi \
	  --enable-libfreetype \
	  --enable-libmp3lame \
	  --enable-libopus \
	  --enable-libtheora \
	  --enable-libvorbis \
	  --enable-libvpx \
	  --enable-libx264 \
	  --enable-nonfree \
	  --enable-nvenc  \
	  --enable-cuda-nvcc \
	  --enable-librsvg
	PATH="$HOME/bin:$PATH" make -j$(nproc)
	make -j$(nproc) install
	make -j$(nproc) distclean
	hash -r
}

#The process
cd ~
mkdir ffmpeg_sources
rm -rf ffmpeg_sources/FFmpeg/
installLibs
InstallCUDASDK
installSDK
compileNasm
compileLibX264
compileLibX265
compileLibfdkcc
compileLibMP3Lame
compileLibOpus
# compileLibAom
compileLibPvx
compileFfmpeg
echo "Complete!"
