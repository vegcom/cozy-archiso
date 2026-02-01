.PHONY: help build clean keys

BUILD_DIR ?= build
WORK_DIR ?= $(BUILD_DIR)/work
OUT_DIR ?= iso

help:
	@echo "Targets:"
	@echo "  make build     # mkarchiso full"
	@echo "  make clean     # Wipe work"
	@echo "  make keys      # Inject ~/.ssh/id_ed25519.pub"
	@echo "  make all       # keys+shadow+params+build+usb"

build:
	sudo mkarchiso -vvv -r -m iso -w $(WORK_DIR) -o $(OUT_DIR) $(BUILD_DIR)

clean:
	sudo rm -rf $(WORK_DIR)
	sudo find $(BUILD_DIR) -type d -exec chmod 755 {} + 2>/dev/null || true

keys:
	scripts/secrets.sh

all: keys shadow params build usb

test-hv:
	@echo "Hyper-V: New VM UEFI Gen2 + serial pipe + boot new USB"
