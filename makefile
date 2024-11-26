rwildcard = $(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

RM_RF := rm -rf
MKDIR_P := mkdir -p
ifeq ($(strip $(shell which rm)),)
	# Windows *really* tries its hardest to be Special™!
	RM_RF := -rmdir /s /q
	MKDIR_P := -mkdir
endif

RGBASM  := rgbasm
RGBLINK := rgblink
RGBFIX  := rgbfix
RGBGFX  := rgbgfx

ROMNAME := main
ROMEXT := gb

EMU := eumlicious

ROM := bin/$(ROMNAME).$(ROMEXT)

INCDIRS := src/ include/

SRCS = $(call rwildcard, src, *.asm)
BASEFILES = $(basename $(notdir $(SRCS)))
OBJS = $(call rwildcard, obj, *.o)

all: $(ROM)
.PHONY: all

rebuild:
	@${MAKE} clean
	@${MAKE} all
.PHONY: rebuild

bin/%.$(ROMEXT):

	@if [ ! -d "obj" ]; then \
		$(MKDIR_P) obj; \
	fi

	@if [ ! -d "bin" ]; then \
		$(MKDIR_P) bin; \
	fi

	@${MAKE} objects
	@${MAKE} link
	@${MAKE} fix

objects:
	@if [ ! -d "obj" ]; then \
		$(MKDIR_P) obj; \
	fi

	@for file in $(BASEFILES); do \
		$(RGBASM) -o obj/$$file.o src/$$file.asm; \
	done
.PHONY: objects

link:
	@if [ ! -d "bin" ]; then \
		$(MKDIR_P) bin; \
	fi
	
	@$(RGBLINK) -o $(ROM) $(OBJS)
.PHONY: link

fix:
	@$(RGBFIX) -v -p 0xFF $(ROM)
.PHONY: fix

clean:
	@$(RM_RF) obj/* bin/*
.PHONY: clean

run:
	$(EMU) $(ROM)
.PHONY: run
