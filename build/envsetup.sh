
SW_BUILD_TOP=$(cd "$(dirname ${BASH_SOURCE[0]})"; pwd)
export SW_BUILD_TOP=${SW_BUILD_TOP%/build*}
export SW_BUILD_OUT=${SW_BUILD_TOP}/out
export SW_BUILD_OBJ=${SW_BUILD_OUT}/obj
export CLEAR_VARS=${SW_BUILD_TOP}/build/clear_vars.mk

