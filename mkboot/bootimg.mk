INSTALLED_BOOTIMAGE_TARGET := $(PRODUCT_OUT)/boot.img

TARGET_PREBUILT_DTB := $(LOCAL_PATH)/prebuilt/mt6855.dtb

$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTIMG) $(TARGET_PREBUILT_KERNEL) $(TARGET_PREBUILT_DTB)
	@echo "---- Building boot.img ----"
	$(MKBOOTIMG) \
		--kernel $(TARGET_PREBUILT_KERNEL) \
		--dtb $(TARGET_PREBUILT_DTB) \
		--cmdline "$(BOARD_KERNEL_CMDLINE)" \
		--header_version $(BOARD_BOOT_HEADER_VERSION) \
		--pagesize $(BOARD_KERNEL_PAGESIZE) \
		--base $(BOARD_KERNEL_BASE) \
		--os_version $(PLATFORM_VERSION) \
		--os_patch_level $(PLATFORM_SECURITY_PATCH) \
		--output $@

.PHONY: bootimage
bootimage: $(INSTALLED_BOOTIMAGE_TARGET)
