LOCAL_PATH=$(shell pwd)
SW_BUILD_LOCAL_OBJDIR=${LOCAL_PATH}/obj/ndk/objs_${LOCAL_MODULE}
SW_BUILD_TARGET_DIR=${LOCAL_PATH}/obj/ndk

ANDROID_API=19
ANDROID_NDK=/cygdrive/d/Workspace/ndk/android-ndk-r14b
SW_BUILD_CC=${ANDROID_NDK}/toolchains/arm-linux-androideabi-4.9/prebuilt/windows-x86_64/bin/arm-linux-androideabi-gcc
SW_BUILD_CXX=${ANDROID_NDK}/toolchains/arm-linux-androideabi-4.9/prebuilt/windows-x86_64/bin/arm-linux-androideabi-g++

LOCAL_CFLAGS += --sysroot=${ANDROID_NDK}/platforms/android-${ANDROID_API}/arch-arm


LOCAL_LDFLAGS += "--sysroot=${ANDROID_NDK}/platforms/android-${ANDROID_API}/arch-arm"

LOCAL_CFLAGS += -pie -fPIE
LOCAL_LDFLAGS += -pie -fPIE

build_find_files = $(wildcard $(dir)/build/core.mk)
build_dirs := . .. ../.. ../../.. ../../../..
build_core_mk := $(foreach dir,$(build_dirs),$(build_find_files))

build_colors := $(subst core.mk,colors.lib,${build_core_mk})

include ${build_colors}
include ${build_core_mk}
