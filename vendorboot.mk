include $(CLEAR_VARS)

# Output target
INSTALLED_VENDORBOOT_TARGET := $(PRODUCT_OUT)/vendorboot.img

# Required tools and prebuilts
MKBOOTIMG := $(HOST_OUT_EXECUTABLES)/mkbootimg
TARGET_PREBUILT_KERNEL := $(LOCAL_PATH)/prebuilt/Image
TARGET_PREBUILT_DTB := $(LOCAL_PATH)/prebuilt/mt6855.dtb

# Build rule for vendorboot.img
$(INSTALLED_VENDORBOOT_TARGET): $(MKBOOTIMG) $(TARGET_PREBUILT_KERNEL) $(TARGET_PREBUILT_DTB)
	@echo "---- Building vendorboot.img ----"
	mkdir -p $(PRODUCT_OUT)
	$(MKBOOTIMG) \
		--kernel $(TARGET_PREBUILT_KERNEL) \
		--dtb $(TARGET_PREBUILT_DTB) \
		--cmdline "$(BOARD_KERNEL_CMDLINE)" \
		--header_version $(BOARD_BOOT_HEADER_VERSION) \
		--pagesize $(BOARD_KERNEL_PAGESIZE) \
		--base $(BOARD_KERNEL_BASE) \
		--os_version $(PLATFORM_VERSION) \
		--os_patch_level $(PLATFORM_SECURITY_PATCH) \
		--output $(PRODUCT_OUT)/vendorboot.img

.PHONY: vendorboot
vendorboot: $(INSTALLED_VENDORBOOT_TARGET)
