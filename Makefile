AS ?= as
ASFLAGS ?= --64
PREFIX ?= /usr
LIBDIR ?= $(PREFIX)/lib

TARGET = build/ww.o
INSTALL_DIR = $(LIBDIR)/ww
INSTALL_TARGET = $(INSTALL_DIR)/ww.o

.PHONY: all clean install link uninstall

all: $(TARGET)

$(TARGET): ww.s macro.s | build
	$(AS) $(ASFLAGS) -o $@ $<

build:
	mkdir -p build

install: $(TARGET)
	install -d $(INSTALL_DIR)
	install -m 644 $(TARGET) $(INSTALL_TARGET)

link: $(TARGET)
	install -d $(INSTALL_DIR)
	ln -sf $(abspath $(TARGET)) $(INSTALL_TARGET)

uninstall:
	rm -rf $(INSTALL_DIR)

clean:
	rm -rf build
