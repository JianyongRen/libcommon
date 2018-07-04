LOCAL_PATH=$(shell pwd)
SW_BUILD_LOCAL_OBJDIR=${LOCAL_PATH}/obj/host/objs_${LOCAL_MODULE}
SW_BUILD_TARGET_DIR=${LOCAL_PATH}/obj/host

SW_BUILD_CC=gcc
SW_BUILD_CXX=g++

build_find_files = $(wildcard $(dir)/build/core.mk)
build_dirs := . .. ../.. ../../.. ../../../..
build_core_mk := $(foreach dir,$(build_dirs),$(build_find_files))

build_colors := $(subst core.mk,colors.lib,${build_core_mk})

include ${build_colors}
include ${build_core_mk}
