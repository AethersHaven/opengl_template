#!/bin/bash

# Packages
sudo apt-get update
sudo apt-get install cmake pkg-config -y
sudo apt-get install libwayland-client0 libwayland-cursor0 libwayland-egl1 libxkbcommon-dev libxinerama-dev libxcursor-dev libxi-dev -y
sudo apt-get install mesa-utils libglu1-mesa-dev freeglut3-dev mesa-common-dev -y
sudo apt-get install libglew-dev libglfw3-dev libglm-dev libao-dev libmpg123-dev -y

# GLFW
if [ ! -d "/usr/local/lib/glfw" ]; then
    cd /usr/local/lib/
    sudo git clone https://github.com/glfw/glfw.git
    cd glfw
    sudo cmake .
    sudo make
    sudo make install
    cd -
fi

# GLAD
if [ ! -d "src/glad.c" ]; then
    pip show glad &> /dev/null
    GLAD_INSTALLED=$?
    if [ $GLAD_INSTALLED -ne 0 ]; then
        pip install glad
    fi
    glad --profile core --out-path ./glad --api gl=4.6 --generator c
    mkdir -p src
    cp glad/src/glad.c src/.
    sudo cp -R glad/include/* /usr/include/
    rm -rf glad
    if [ $GLAD_INSTALLED -ne 0 ]; then
        pip uninstall -y glad
    fi
fi

# Test
g++ src/test_main.cpp src/glad.c -ldl -lglfw -o test.out
./test.out
rm test.out