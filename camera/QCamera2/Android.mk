ifneq (,$(filter $(TARGET_ARCH), arm)

LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
        util/QCameraBufferMaps.cpp \
        util/QCameraCmdThread.cpp \
        util/QCameraDisplay.cpp \
        util/QCameraFlash.cpp \
        util/QCameraPerf.cpp \
        util/QCameraQueue.cpp \
        util/QCameraCommon.cpp \
        QCamera2Hal.cpp \
        QCamera2Factory.cpp

#HAL 3.0 source
LOCAL_SRC_FILES += \
        HAL3/QCamera3HWI.cpp \
        HAL3/QCamera3Mem.cpp \
        HAL3/QCamera3Stream.cpp \
        HAL3/QCamera3Channel.cpp \
        HAL3/QCamera3VendorTags.cpp \
        HAL3/QCamera3PostProc.cpp \
        HAL3/QCamera3CropRegionMapper.cpp \
        HAL3/QCamera3StreamMem.cpp

#HAL 1.0 source
LOCAL_SRC_FILES += \
        HAL/QCamera2HWI.cpp \
        HAL/QCameraMuxer.cpp \
        HAL/QCameraMem.cpp \
        HAL/QCameraStateMachine.cpp \
        HAL/QCameraChannel.cpp \
        HAL/QCameraStream.cpp \
        HAL/QCameraPostProc.cpp \
        HAL/QCamera2HWICallbacks.cpp \
        HAL/QCameraParameters.cpp \
        HAL/QCameraParametersIntf.cpp \
        HAL/QCameraThermalAdapter.cpp

LOCAL_CFLAGS := -Wall -Wextra -Werror

# System header file path prefix
LOCAL_CFLAGS += -DSYSTEM_HEADER_PREFIX=sys

LOCAL_CFLAGS += -DHAS_MULTIMEDIA_HINTS -D_ANDROID

ifeq ($(TARGET_USES_AOSP),true)
LOCAL_CFLAGS += -DVANILLA_HAL
endif

#use media extension
ifeq ($(TARGET_USES_MEDIA_EXTENSIONS), true)
LOCAL_CFLAGS += -DUSE_MEDIA_EXTENSIONS
endif

#HAL 1.0 Flags
LOCAL_CFLAGS += -DDEFAULT_DENOISE_MODE_ON -DHAL3 -DQCAMERA_REDEFINE_LOG

LOCAL_C_INCLUDES := \
        $(LOCAL_PATH)/../mm-image-codec/qexif \
        $(LOCAL_PATH)/../mm-image-codec/qomx_core \
        $(LOCAL_PATH)/include \
        $(LOCAL_PATH)/stack/common \
        $(LOCAL_PATH)/stack/mm-camera-interface/inc \
        $(LOCAL_PATH)/util \
        $(LOCAL_PATH)/HAL3 \
        hardware/libhardware/include/hardware \
        $(TARGET_OUT_HEADERS)/mm-core/omxcore \
        system/core/include/cutils \
        system/core/include/system \
        system/media/camera/include/system

#HAL 1.0 Include paths
LOCAL_C_INCLUDES += \
        $(LOCAL_PATH)/HAL

ifeq ($(TARGET_COMPILE_WITH_MSM_KERNEL),true)
LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include
LOCAL_ADDITIONAL_DEPENDENCIES := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr
endif
ifeq ($(TARGET_TS_MAKEUP),true)
LOCAL_CFLAGS += -DTARGET_TS_MAKEUP
LOCAL_C_INCLUDES += $(LOCAL_PATH)/HAL/tsMakeuplib/include
endif
ifeq ($(call is-platform-sdk-version-at-least,20),true)
LOCAL_C_INCLUDES += system/media/camera/include
else
LOCAL_CFLAGS += -DUSE_KK_CODE
endif

#LOCAL_STATIC_LIBRARIES := libqcamera2_util
LOCAL_C_INCLUDES += \
        $(TARGET_OUT_HEADERS)/qcom/display
LOCAL_C_INCLUDES += \
        hardware/qcom/display/msm8974/libqservice
LOCAL_SHARED_LIBRARIES := libcamera_client liblog libhardware libutils libcutils libdl libsync libgui
LOCAL_SHARED_LIBRARIES += libhidltransport libsensor android.hidl.token@1.0-utils android.hardware.graphics.bufferqueue@1.0
LOCAL_SHARED_LIBRARIES += libmmcamera_interface libmmjpeg_interface libui libcamera_metadata
LOCAL_SHARED_LIBRARIES += libqdMetaData libqservice libbinder
LOCAL_SHARED_LIBRARIES += libcutils libdl
LOCAL_STATIC_LIBRARIES := libarect
LOCAL_HEADER_LIBRARIES := OmxCore_headers gralloc_headers
ifeq ($(TARGET_TS_MAKEUP),true)
LOCAL_SHARED_LIBRARIES += libts_face_beautify_hal libts_detected_face_hal
endif

LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_MODULE := camera.$(TARGET_BOARD_PLATFORM)
LOCAL_MODULE_TAGS := optional
LOCAL_PROPRIETARY_MODULE := true

LOCAL_32_BIT_ONLY := $(BOARD_QTI_CAMERA_32BIT_ONLY)
include $(BUILD_SHARED_LIBRARY)

include $(call first-makefiles-under,$(LOCAL_PATH))
endif
