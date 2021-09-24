sudo rm -fr build/
sudo meson build
cd build/
sudo ninja
sudo ninja install
cd ../
killall plank
plank
