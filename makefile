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
ROMTITLE := Pong

EMU ?= emulicious
DBG_OPTIONS ?=

ROM := bin/$(ROMNAME).$(ROMEXT)

INCDIRS := src/ include/
SRCDIR := src
ASSETDIRRAW := assets/raw
ASSETDIROUT := assets/gen
DIROUT := bin
DIROBJ := obj

SRCS = $(call rwildcard, $(INCDIRS), *.asm)
SPRITES = $(call rwildcard, $(ASSETDIRRAW), *.png)
BASEFILES = $(basename $(notdir $(SRCS)))
BASESPRITES = $(basename $(notdir $(SPRITES)))
OBJS = $(call rwildcard, $(DIROBJ), *.o)

.DEFAULT_GOAL := rebuild

all: default release run
.PHONY: all

default: $(ROM)
.PHONY: default

rebuild:
	@${MAKE} clean
	@${MAKE} pre-config
	@${MAKE} default
.PHONY: rebuild

bin/%.$(ROMEXT): pre-config
	@${MAKE} sprites
	@${MAKE} objects
	@${MAKE} link
	@${MAKE} fix

pre-config:
	@if [ ! -d "$(DIROBJ)" ]; then \
		$(MKDIR_P) $(DIROBJ); \
	fi
	
	@if [ ! -d "$(ASSETDIROUT)" ]; then \
		$(MKDIR_P) $(ASSETDIROUT); \
	fi

	@if [ ! -d "$(DIROUT)" ]; then \
		$(MKDIR_P) $(DIROUT); \
	fi
.PHONY: pre-config

objects:
	@for file in $(BASEFILES); do \
		$(RGBASM) -o $(DIROBJ)/$$file.o $(SRCDIR)/$$file.asm; \
	done
.PHONY: objects

link:
	@$(RGBLINK) -o $(ROM) $(OBJS) $(DBG_OPTIONS)
.PHONY: link

fix:
	@$(RGBFIX) -v -p 0xFF $(ROM) -t "$(ROMTITLE)"
.PHONY: fix

clean:
	@$(RM_RF) $(DIROBJ)/* $(DIROUT)/* $(ASSETDIROUT)/*
.PHONY: clean

run: rebuild
	@$(EMU) $(ROM)
.PHONY: run

release: rebuild
	@$(ZIP) bin/pong.zip $(ROM)
.PHONY: release

sprites:
	@for i in $(BASESPRITES); do \
		$(RGBGFX) $(ASSETDIRRAW)/$$i.png -o $(ASSETDIROUT)/$$i.2bpp; \
	done
.PHONY: sprites