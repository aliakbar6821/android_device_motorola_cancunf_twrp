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

$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) $(recovery_ramdisk) $(recovery_kernel) $(RECOVERYIMAGE_EXTRA_DEPS) $(AVBTOOL)
	@echo "----- Making recovery image ------"
	$(hide) $(MKBOOTIMG) $(INTERNAL_RECOVERYIMAGE_ARGS) $(INTERNAL_MKBOOTIMG_VERSION_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@
	$(hide) echo -n "SEANDROIDENFORCE" >> $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_RECOVERYIMAGE_PARTITION_SIZE),raw)
	$(hide) $(AVBTOOL) add_hash_footer --image $@ --partition_size $(BOARD_RECOVERYIMAGE_PARTITION_SIZE) --partition_name recovery --algorithm $(BOARD_AVB_RECOVERY_ALGORITHM) --key $(BOARD_AVB_RECOVERY_KEY_PATH)
	@echo "Made recovery image: $@"
