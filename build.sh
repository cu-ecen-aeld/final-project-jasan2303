#!/bin/bash
# Script to build image for qemu.
# Author: Siddhant Jajoo.

git submodule init
git submodule sync
git submodule update

# local.conf won't exist until this step on first execution
source poky/oe-init-build-env

CONFLINE="MACHINE = \"beaglebone-yocto\""

cat conf/local.conf | grep "${CONFLINE}" > /dev/null
local_conf_info=$?

if [ $local_conf_info -ne 0 ];then
	echo "Append ${CONFLINE} in the local.conf file"
	echo ${CONFLINE} >> conf/local.conf
	
else
	echo "${CONFLINE} already exists in the local.conf file"
fi

IMAGE="IMAGE_FSTYPES = \"wic.bz2\""

cat conf/local.conf | grep "${IMAGE}" > /dev/null
local_image_info=$?

if [ $local_image_info -ne 0 ];then 
    echo "Append ${IMAGE} in the local.conf file"
	echo ${IMAGE} >> conf/local.conf
else
	echo "${IMAGE} already exists in the local.conf file"
fi


bitbake-layers show-layers | grep "meta-aesd" > /dev/null
layer_info=$?

if [ $layer_info -ne 0 ];then
	echo "Adding meta-aesd layer"
	bitbake-layers add-layer ../meta-aesd
else
	echo "meta-aesd layer already exists"
fi

#Add wifi support
DISTRO_F="DISTRO_FEATURES:append = \" wifi\""

cat conf/local.conf | grep "${DISTRO_F}" > /dev/null
local_distro_info=$?

if [ $local_distro_info -ne 0 ];then
    echo "Append ${DISTRO_F} in the local.conf file"
	echo ${DISTRO_F} >> conf/local.conf
else
	echo "${DISTRO_F} already exists in the local.conf file"
fi


#add firmware support and wifi details, add camera related package support
IMAGE_ADD="IMAGE_INSTALL:append = \"	v4l-utils python3 ntp wpa-supplicant 
							  fbida fbgrab ffmpeg imagemagick gstreamer1.0 
            				  gstreamer1.0-plugins-good gstreamer1.0-plugins-base  
            				  gstreamer1.0-plugins-ugly gstreamer1.0-libav gst-player
            				  gstreamer1.0-meta-base gst-examples gstreamer1.0-rtsp-server\""

cat conf/local.conf | grep "${IMAGE_ADD}" > /dev/null
local_imgadd_info=$?

if [ $local_imgadd_info -ne 0 ];then
    echo "Append ${IMAGE_ADD} in the local.conf file"
	echo ${IMAGE_ADD} >> conf/local.conf
else
	echo "${IMAGE_ADD} already exists in the local.conf file"
fi


#Licence
LICENCE="LICENSE_FLAGS_WHITELIST = \"commercial\""
#this is required so that gstreamer1.0-plugins-ugly can be added to the image
LICENSE:append = " commercial_gstreamer1.0-plugins-ugly commercial_mpg123"

cat conf/local.conf | grep "${LICENCE}" > /dev/null
local_licn_info=$?

if [ $local_licn_info -ne 0 ];then
    echo "Append ${LICENCE} in the local.conf file"
	echo ${LICENCE} >> conf/local.conf
else
	echo "${LICENCE} already exists in the local.conf file"
fi


# Added by: Jasan Singh
# Adding required gstreamer Package_configs for x264 to local.conf file
cat conf/local.conf | grep "x264" > /dev/null
local_licn_info=$?

if [ $local_licn_info -ne 0 ];then
    echo "Append x264 PACKAGECONFIG to local.conf file"
         echo "PACKAGECONFIG_append_pn-gstreamer1.0-plugins-ugly = \" x264\"" >> conf/local.conf
else
         echo " x264 package congigurations already exists in local.conf"
fi

# Added by: Jasan Singh
# Adding required gstreamer Package_configs for voaacenc to local.conf file
cat conf/local.conf | grep " voaacenc" > /dev/null
local_licn_info=$?

if [ $local_licn_info -ne 0 ];then
    echo "Append voaacenc PACKAGECONFIG to local.conf file"
         echo "PACKAGECONFIG_append_pn-gstreamer1.0-plugins-bad = \" voaacenc\"" >> conf/local.conf
else
         echo " voaacenc package congigurations already exists in local.conf"
fi

# Added by: Jasan Singh
# Adding required gstreamer Package_configs for rtmp to local.conf file
cat conf/local.conf | grep " rtmp" > /dev/null
local_licn_info=$?

if [ $local_licn_info -ne 0 ];then
    echo "Append rtmp PACKAGECONFIG to local.conf file"
         echo "PACKAGECONFIG_append_pn-gstreamer1.0-plugins-bad = \" rtmp\"" >> conf/local.conf
else
         echo " rtmp package congigurations already exists in local.conf"
fi


#Add meta-oe from openembedded
bitbake-layers show-layers | grep "meta-oe" > /dev/null
layer_oe_info=$?

if [ $layer_oe_info -ne 0 ];then
	echo "Adding meta-oe layer"
	bitbake-layers add-layer ../meta-openembedded/meta-oe
else
	echo "meta-oe layer already exists"
fi

#Add meta-python from openembedded
bitbake-layers show-layers | grep "meta-python" > /dev/null
layer_python_info=$?

if [ $layer_python_info -ne 0 ];then
	echo "Adding meta-python layer"
	bitbake-layers add-layer ../meta-openembedded/meta-python
else
	echo "meta-python layer already exists"
fi

#Add meta-networking from openembedded
bitbake-layers show-layers | grep "meta-networking" > /dev/null
layer_networking_info=$?

if [ $layer_networking_info -ne 0 ];then
	echo "Adding meta-networking layer"
	bitbake-layers add-layer ../meta-openembedded/meta-networking
else
	echo "meta-networking layer already exists"
fi

set -e
bitbake core-image-aesd
