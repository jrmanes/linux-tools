#!/bin/bash


sudo apt-get install git-core
sudo apt-get install ninja-build meson libpthread-stubs0-dev
sudo apt-get install xserver-xorg-dev x11proto-xinerama-dev libx11-xcb-dev
sudo apt-get install libxcb-glx0-dev libxrender-dev
sudo apt-get build-dep libgl1-mesa-dri libxcb-glx0-dev
