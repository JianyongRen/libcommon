APP_BUILD_SCRIPT := Android.mk
APP_ABI := armeabi
#APP_STL := gnustl_shared
APP_STL := gnustl_static
APP_CPPFLAGS += -Wno-error=format-security -std=c++11
APP_OPTIM := release
APP_CFLAGS += -fexceptions -frtti
APP_PLATFORM := android-19 
