# General makefile for Playdate projects
#   yorgle@gmail.com
#
################################
#### definitions...


SDK = $(shell egrep '^\s*SDKRoot' ~/.Playdate/config | head -n 1 | cut -c9-)
TOOLDIR = $(SDK)/../LLPdTools
PSELECT = $(TOOLDIR)/playdate-select.sh
PINFO = $(TOOLDIR)/pdxinfo-extract.sh
SDKBIN=$(SDK)/bin
GAME=$(notdir $(CURDIR))
SIM=Playdate Simulator


################################
#### General Build targets

build: clean compile run
.PHONY: build

build-legacy: sdk1 clean compile sdk1 run
.PHONY: build

run: open
.PHONY: run


################################
#### SDK version selectors

sdk1:
	@$(PSELECT) -s 1
.PHONY: sdk1

sdk2:
	@$(PSELECT) -s 2
.PHONY: sdk2


################################
#### Build iteration 

compile: Source/main.lua
	"$(SDKBIN)/pdc" 'Source' '$(GAME).pdx'
.PHONY: compile

open:
	open -a '$(SDKBIN)/$(SIM).app/Contents/MacOS/$(SIM)' '$(GAME).pdx'
.PHONY: open

clean:
	rm -rf '$(GAME).pdx'
.PHONY: clean

# additional build targets
gfx:
	cd GFX ; perl split.pl
	cd GFX ; sh copyall.sh
.PHONY: gfx


################################
#### Simulator helpers

install: remove compile
	cp -r '$(GAME).pdx' '$(SDK)/Disk/Games'
.PHONY: install

remove: 
	rm -rf  '$(SDK)/Disk/Games/$(GAME).pdx'
.PHONY: remove


################################
#### Distribution build

RELEASE_TIMESTAMP ?= $(shell date "+%Y%m%d_%H%M")
RELEASE_VERSION ?= $(shell $(PINFO) -g buildNumber )
ZIPFILE := $(shell $(PINFO) -g name ).$(RELEASE_VERSION).$(RELEASE_TIMESTAMP).zip
dist:
	zip -rp ../$(ZIPFILE) '$(GAME).pdx'
	@echo "  $(APPNAME) is compressed into $(ZIPFILE)"
.PHONY: dist

release: dist
.PHONY: release
