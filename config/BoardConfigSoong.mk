PATH_OVERRIDE_SOONG := $(shell echo $(TOOLS_PATH_OVERRIDE))

# Add variables that we wish to make available to soong here.
EXPORT_TO_SOONG := \
    KERNEL_ARCH \
    KERNEL_BUILD_OUT_PREFIX \
    KERNEL_CROSS_COMPILE \
    KERNEL_MAKE_CMD \
    KERNEL_MAKE_FLAGS \
    PATH_OVERRIDE_SOONG \
    TARGET_KERNEL_CONFIG \
    TARGET_KERNEL_SOURCE

# Setup SOONG_CONFIG_* vars to export the vars listed above.
# Documentation here:
# https://github.com/LineageOS/android_build_soong/commit/8328367c44085b948c003116c0ed74a047237a69

SOONG_CONFIG_NAMESPACES += calyxVarsPlugin

SOONG_CONFIG_calyxVarsPlugin :=

define addVar
  SOONG_CONFIG_calyxVarsPlugin += $(1)
  SOONG_CONFIG_calyxVarsPlugin_$(1) := $$(subst ",\",$$($1))
endef

$(foreach v,$(EXPORT_TO_SOONG),$(eval $(call addVar,$(v))))

SOONG_CONFIG_NAMESPACES += calyxGlobalVars
SOONG_CONFIG_calyxGlobalVars += \
    additional_gralloc_10_usage_bits \
    gralloc_handle_has_reserved_size \
    inline_kernel_building \
    target_init_vendor_lib \
    target_surfaceflinger_udfps_lib \
    target_trust_usb_control_path \
    target_trust_usb_control_enable \
    target_trust_usb_control_disable

SOONG_CONFIG_NAMESPACES += calyxQcomVars
SOONG_CONFIG_calyxQcomVars += \
    supports_extended_compress_format \
    uses_pre_uplink_features_netmgrd

# Only create display_headers_namespace var if dealing with UM platforms to avoid breaking build for all other platforms
ifneq ($(filter $(UM_PLATFORMS),$(TARGET_BOARD_PLATFORM)),)
SOONG_CONFIG_calyxQcomVars += \
    qcom_display_headers_namespace
endif

# Soong bool variables
SOONG_CONFIG_calyxGlobalVars_gralloc_handle_has_reserved_size := $(TARGET_GRALLOC_HANDLE_HAS_RESERVED_SIZE)
SOONG_CONFIG_calyxGlobalVars_inline_kernel_building := $(INLINE_KERNEL_BUILDING)
SOONG_CONFIG_calyxQcomVars_supports_extended_compress_format := $(AUDIO_FEATURE_ENABLED_EXTENDED_COMPRESS_FORMAT)
SOONG_CONFIG_calyxQcomVars_uses_pre_uplink_features_netmgrd := $(TARGET_USES_PRE_UPLINK_FEATURES_NETMGRD)

# Set default values
TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS ?= 0
TARGET_GRALLOC_HANDLE_HAS_RESERVED_SIZE ?= false
TARGET_INIT_VENDOR_LIB ?= vendor_init
TARGET_SURFACEFLINGER_UDFPS_LIB ?= surfaceflinger_udfps_lib
TARGET_TRUST_USB_CONTROL_PATH ?= /proc/sys/kernel/deny_new_usb
TARGET_TRUST_USB_CONTROL_ENABLE ?= 1
TARGET_TRUST_USB_CONTROL_DISABLE ?= 0

# Soong value variables
SOONG_CONFIG_calyxGlobalVars_additional_gralloc_10_usage_bits := $(TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS)
SOONG_CONFIG_calyxGlobalVars_target_init_vendor_lib := $(TARGET_INIT_VENDOR_LIB)
SOONG_CONFIG_calyxGlobalVars_target_surfaceflinger_udfps_lib := $(TARGET_SURFACEFLINGER_UDFPS_LIB)
SOONG_CONFIG_calyxGlobalVars_target_trust_usb_control_path := $(TARGET_TRUST_USB_CONTROL_PATH)
SOONG_CONFIG_calyxGlobalVars_target_trust_usb_control_enable := $(TARGET_TRUST_USB_CONTROL_ENABLE)
SOONG_CONFIG_calyxGlobalVars_target_trust_usb_control_disable := $(TARGET_TRUST_USB_CONTROL_DISABLE)
ifneq ($(filter $(QSSI_SUPPORTED_PLATFORMS),$(TARGET_BOARD_PLATFORM)),)
SOONG_CONFIG_calyxQcomVars_qcom_display_headers_namespace := vendor/qcom/opensource/commonsys-intf/display
else
SOONG_CONFIG_calyxQcomVars_qcom_display_headers_namespace := $(QCOM_SOONG_NAMESPACE)/display
endif
