LOCAL_PATH=$(shell pwd)

OBJ_DIR=obj_linux-x86

BUILD_TIME := $(shell date "+%Y%m%d%H%M%S")

$(warning "build time: ${BUILD_TIME}")

CC=gcc
CXX=g++

CCFLAGS += -Wno-unused-parameter -Wno-int-to-pointer-cast -Wall
CCFLAGS += -DBUILD_TIME=\"${BUILD_TIME}\"

CXXFLAGS += -Wno-unused-parameter -Wno-int-to-pointer-cast -Wall
CXXFLAGS += -fno-rtti -fno-exceptions
CXXFLAGS += -DBUILD_TIME=\"${BUILD_TIME}\"

LDFLAGS += -fno-rtti -fno-exceptions
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

