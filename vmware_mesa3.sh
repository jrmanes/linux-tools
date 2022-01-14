#!/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install -y git-core \
    ninja-build \
    meson \
    libpthread-stubs0-dev \
    xserver-xorg-dev \
    x11proto-xinerama-dev \
    libx11-xcb-dev \  
    libxcb-glx0-dev \
    libxrender-dev \
    build-dep \
    libgl1-mesa-dri \
    libxcb-glx0-dev
