LOCAL_PATH=$(shell pwd)

OBJ_DIR=obj-ndk

BUILD_TIME := $(shell date "+%Y%m%d%H%M%S")

$(warning "build time: ${BUILD_TIME}")

ANDROID_API=19
ANDROID_NDK=/opt/android-ndk-r14b
CC=${ANDROID_NDK}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-gcc
CXX=${ANDROID_NDK}/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/arm-linux-androideabi-g++

CCFLAGS += --sysroot=${ANDROID_NDK}/platforms/android-${ANDROID_API}/arch-arm
CXXFLAGS += --sysroot=${ANDROID_NDK}/platforms/android-${ANDROID_API}/arch-arm

LDFLAGS += "--sysroot=${ANDROID_NDK}/platforms/android-${ANDROID_API}/arch-arm"

CCFLAGS += -Wno-unused-parameter -Wno-int-to-pointer-cast -Wall
CCFLAGS += -DBUILD_TIME=\"${BUILD_TIME}\"

CXXFLAGS += -Wno-unused-parameter -Wno-int-to-pointer-cast -Wall
CXXFLAGS += -fno-rtti -fno-exceptions
CXXFLAGS += -DBUILD_TIME=\"${BUILD_TIME}\"

LDFLAGS += -fno-rtti -fno-exceptions -pie -fPIE
DEBUG_FLAGS = -g

OBJS += $(patsubst %.c,$(OBJ_DIR)/%.o,$(filter %.c,$(SRC_FILES)))
OBJS += $(patsubst %.cpp,$(OBJ_DIR)/%.o,$(filter %.cpp,$(SRC_FILES)))

ifeq (,$(filter %.cpp,$(SRC_FILES)))
	BUILD_OBJECT := $(CC)
else
	BUILD_OBJECT := $(CXX)
endif

$(OBJ_DIR)/$(OBJECT): $(OBJS)
	@echo '<$(CXX)> Compiling object file "$@" ...'
	$(Q_)mkdir -p $(dir $@)
	$(BUILD_OBJECT) -o $@ $(OBJS) $(STATIC_LIBS) $(SHARED_LIBS) $(LDFLAGS) $(DEBUG_FLAGS)

$(OBJ_DIR)/%.o:%.c
	@echo '<$(CXX)> Compiling object file "$@" ...'
	$(Q_)mkdir -p $(dir $@)
	$(Q_)${CC} $(CCFLAGS) $(INCLS) $(DEBUG_FLAGS) -c $< -o $@

$(OBJ_DIR)/%.o:%.cpp
	@echo '<$(CXX)> Compiling object file "$@" ...'
	$(Q_)mkdir -p $(dir $@)
	$(Q_)${CXX} $(CXXFLAGS) $(INCLS) $(DEBUG_FLAGS) -c $< -o $@

clean:
	rm -rf $(OBJ_DIR)

