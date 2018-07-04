ifeq (,${LOCAL_MODULE})
$(error "No LOCAL_MODULE given!")
endif

BUILD_TIME := $(shell date "+%Y%m%d%H%M%S")
$(info "build time: ${BUILD_TIME}")

LOCAL_CFLAGS += -Wno-unused-parameter -Wno-int-to-pointer-cast -Wall -g
LOCAL_CFLAGS += -DBUILD_TIME=\"${BUILD_TIME}\" -DLOG_TAG=\"${LOCAL_MODULE}\"

LOCAL_CPPFLAGS += -fno-rtti -fno-exceptions

LOCAL_LDFLAGS += -fno-rtti -fno-exceptions -g

SW_BUILD_LOCAL_OBJS += $(patsubst %.c,$(SW_BUILD_LOCAL_OBJDIR)/%.o,$(filter %.c,$(LOCAL_SRC_FILES)))
SW_BUILD_LOCAL_OBJS += $(patsubst %.cpp,$(SW_BUILD_LOCAL_OBJDIR)/%.o,$(filter %.cpp,$(LOCAL_SRC_FILES)))

ifeq (,$(filter %.cpp,$(LOCAL_SRC_FILES)))
	SW_BUILD_TOOL := $(SW_BUILD_CC)
else
	SW_BUILD_TOOL := $(SW_BUILD_CXX)
endif

$(SW_BUILD_TARGET_DIR)/$(LOCAL_MODULE): $(SW_BUILD_LOCAL_OBJS)
	#@echo '<$(SW_BUILD_TOOL)> Compiling "$@" ...'
	$(info   $(shell echo ${RED}"Install:" ${NORMAL}"["${GREEN} ${@} ${NORMAL}"]" ) )
	$(Q_)mkdir -p $(dir $@)
	$(SW_BUILD_TOOL) -o $@ $(SW_BUILD_LOCAL_OBJS) $(LOCAL_STATIC_LIBRARIES) $(LOCAL_SHARED_LIBRARIES) $(LOCAL_LDFLAGS)

$(SW_BUILD_LOCAL_OBJDIR)/%.o:%.c
	@echo '<$(SW_BUILD_CC)> Compiling "$@" ...'
	$(Q_)mkdir -p $(dir $@)
	$(Q_)${SW_BUILD_CC} $(LOCAL_CFLAGS) $(LOCAL_C_INCLUDES) -c $< -o $@

$(SW_BUILD_LOCAL_OBJDIR)/%.o:%.cpp
	@echo '<$(SW_BUILD_CXX)> Compiling "$@" ...'
	$(Q_)mkdir -p $(dir $@)
	$(Q_)${SW_BUILD_CXX} $(LOCAL_CFLAGS) $(LOCAL_CPPFLAGS) $(LOCAL_C_INCLUDES) -c $< -o $@

clean:
	rm -rf ${SW_BUILD_LOCAL_OBJDIR}
	rm ${SW_BUILD_TARGET_DIR}/${LOCAL_MODULE}

