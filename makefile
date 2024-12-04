rwildcard = $(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

RM_RF := rm -rf
MKDIR_P := mkdir -p
ifeq ($(strip $(shell which rm)),)
	# Windows *really* tries its hardest to be Special™!
	RM_RF := -rmdir /s /q
	MKDIR_P := -mkdir
endif

ZIP := zip

RGBDS ?=

RGBASM  := $(RGBDS)rgbasm
RGBLINK := $(RGBDS)rgblink
RGBFIX  := $(RGBDS)rgbfix
RGBGFX  := $(RGBDS)rgbgfx

ROMNAME := main
ROMEXT := gb

EMU ?= emulicious
DBG_OPTIONS ?=

ROM := bin/$(ROMNAME).$(ROMEXT)

INCDIRS := src/ include/

SRCS = $(call rwildcard, src, *.asm)
BASEFILES = $(basename $(notdir $(SRCS)))
OBJS = $(call rwildcard, obj, *.o)

.DEFAULT_GOAL := $(ROM)

all: $(ROM)
.PHONY: all

rebuild:
	@${MAKE} clean
	@${MAKE} all
.PHONY: rebuild

bin/%.$(ROMEXT): pre-config
	@${MAKE} objects
	@${MAKE} link
	@${MAKE} fix

pre-config:
	@if [ ! -d "obj" ]; then \
		$(MKDIR_P) obj; \
	fi

	@if [ ! -d "bin" ]; then \
		$(MKDIR_P) bin; \
	fi
.PHONY: pre-config

objects:
	@for file in $(BASEFILES); do \
		$(RGBASM) -o obj/$$file.o src/$$file.asm; \
	done
.PHONY: objects

link:
	@$(RGBLINK) -o $(ROM) $(OBJS) $(DBG_OPTIONS)
.PHONY: link

fix:
	@$(RGBFIX) -v -p 0xFF $(ROM)
.PHONY: fix

clean:
	@$(RM_RF) obj/* bin/*
.PHONY: clean

run: rebuild
	@$(EMU) $(ROM)
.PHONY: run

release: rebuild
	@$(ZIP) bin/pong.zip $(ROM)
.PHONY: release