LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE	 := procmem_parser
LOCAL_LDLIBS += -llog
#LOCAL_ALLOW_UNDEFINED_SYMBOLS := true

LOCAL_SRC_FILES := procmem_parser.cpp
					
include $(BUILD_EXECUTABLE)
#include $(BUILD_HOST_EXECUTABLE)
