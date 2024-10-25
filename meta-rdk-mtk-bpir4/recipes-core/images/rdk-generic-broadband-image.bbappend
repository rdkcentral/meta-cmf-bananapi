#WebPA Feature
IMAGE_INSTALL_append = " parodus parodus2ccsp"

#Pre build bootloader
do_build[depends] += "atf_bootloader_prebuild:do_deploy"
