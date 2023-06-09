#Common headers
common_includes := $(LOCAL_PATH)/../libgralloc
common_includes += $(LOCAL_PATH)/../liboverlay
common_includes += $(LOCAL_PATH)/../libcopybit
common_includes += $(LOCAL_PATH)/../libqdutils
common_includes += $(LOCAL_PATH)/../libhwcomposer
common_includes += $(LOCAL_PATH)/../libexternal
common_includes += $(LOCAL_PATH)/../libqservice
common_includes += $(LOCAL_PATH)/../libvirtual

ifeq ($(TARGET_USES_POST_PROCESSING),true)
    common_flags     += -DUSES_POST_PROCESSING
    common_includes  += $(TARGET_OUT_HEADERS)/pp/inc
endif

common_header_export_path := qcom/display

#Common libraries external to display HAL
common_libs := liblog libutils libcutils libhardware

#Common C flags
common_flags := -DDEBUG_CALC_FPS -Wno-missing-field-initializers
#TODO: Add -Werror back once all the current warnings are fixed
common_flags += -Wconversion -Wall -Wno-sign-conversion

ifeq ($(ARCH_ARM_HAVE_NEON),true)
    common_flags += -D__ARM_HAVE_NEON
endif

ifneq (,$(call is-board-platform-in-list2, msm8974 msm8226 msm8610 apq8084 mpq8092 msm_bronze msm8916 msm8994))
    common_flags += -DVENUS_COLOR_FORMAT
    common_flags += -DMDSS_TARGET
endif

ifeq ($(TARGET_HAS_VSYNC_FAILURE_FALLBACK), true)
    common_flags += -DVSYNC_FAILURE_FALLBACK
endif

ifeq ($(DISPLAY_DEBUG_SWAPINTERVAL),true)
    common_flags += -DDEBUG_SWAPINTERVAL
endif

common_flags += -D__STDC_FORMAT_MACROS

common_deps  :=
kernel_includes :=

# Executed only on QCOM BSPs
ifeq ($(TARGET_USES_QCOM_BSP),true)
# Enable QCOM Display features
    common_flags += -DQCOM_BSP
endif

ifneq (,$(DISPLAY_FEATURE_MAX_ROT_SESSION))
    common_flags += -DTARGET_SPECIFIC_MAX_ROT_SESSION=$(DISPLAY_FEATURE_MAX_ROT_SESSION)
endif

ifneq (,$(call is-vendor-board-qcom))
# This check is to pick the kernel headers from the right location.
# If the macro above is defined, we make the assumption that we have the kernel
# available in the build tree.
# If the macro is not present, the headers are picked from hardware/qcom/msmXXXX
# failing which, they are picked from bionic.
    common_deps += $(BOARD_KERNEL_HEADER_DEPENDENCIES)
    kernel_includes += $(BOARD_KERNEL_HEADER_DIR)
endif
