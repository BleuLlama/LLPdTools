# General makefile for Playdate projects
#   yorgle@gmail.com
#
#   2024-10 - Additions for magentify, magentafication
#   2024-09 - updates for linux dev environment, generalization
#
################################
#### definitions...

ifeq ($(OS),Windows_NT) 
  detected_OS := Windows
else
  detected_OS := $(shell sh -c 'uname 2>/dev/null || echo Unknown')
endif

ifeq ($(detected_OS),Linux)
  SDK:=$(PLAYDATE_SDK_PATH)
else
  SDK:= $(shell egrep '^\s*SDKRoot' ~/.Playdate/config | head -n 1 | cut -c9-)
endif


SDKBIN=$(SDK)/bin
#TOOLDIR?= $(SDK)/../LLPdTools
TOOLDIR?= ../LLPdTools

PSELECT = bash $(TOOLDIR)/playdate-select.sh
PINFO = bash $(TOOLDIR)/pdxinfo-extract.sh
GAME=$(notdir $(CURDIR))


ifeq ($(detected_OS),Linux)
  SIMULATOR := '$(SDKBIN)/PlaydateSimulator' 
else
  SIMULATOR := open -a '$(SDKBIN)/$(SIM).app/Contents/MacOS/$(SIM)'
endif


################################
#### General Build targets

all test: build
.PHONY: all test

build: clean compile run
.PHONY: build

run: open
.PHONY: run


################################
#### SDK version swapping

build-legacy: sdk1 clean compile sdk1 run
.PHONY: build

sdk1:
	@$(PSELECT) -s 1
.PHONY: sdk1

sdk2:
	@$(PSELECT) -s 2
.PHONY: sdk2


################################
#### Build iteration 

compile: Source/main.lua
	@echo "++ Compiling project.."
	"$(SDKBIN)/pdc" 'Source' '$(GAME).pdx'
.PHONY: compile

open:
	@echo "++ Opening project in Simulator"
	$(SIMULATOR) '$(GAME).pdx'
.PHONY: open

clean:
	@echo "++ Cleaning built projects, extra files"
	rm -rf '$(GAME).pdx'
	find . -name ".DS_Store" | xargs rm -f
.PHONY: clean

# additional build targets
gfx:
	@echo "++ Copying gfx..."
	cp -r gfx.magenta/* Source/
	@echo "++ Demagentafying gfx..."
	@find Source -type f -name "*png" -exec sh -c 'echo "Demagentify {}" && mogrify -transparent magenta "{}"' \;
.PHONY: gfx

ungfx:
	@echo "To magentafy true-transparent images:"
	@echo convert true.png -background magenta -flatten magenta.png

clean-gfx:
	@echo "++ Removing built graphics..."
	find gfx.magenta/ -name "*png" -print | sed s/^gfx.magenta/Source/ | xargs ls -l
.PHONY: gfx


################################
#### Simulator helpers

install: remove compile
	@echo "++ Installing $(GAME).pdx to Simulator"
	cp -r '$(GAME).pdx' '$(SDK)/Disk/Games'
.PHONY: install

remove:
	@echo "++ Removing $(GAME).pdx from Simulator"
	rm -rf  '$(SDK)/Disk/Games/$(GAME).pdx'
.PHONY: remove

launcher: install
	@echo "++ Running Simulator"
	$(SIMULATOR)
.PHONY: launcher


################################
#### Distribution build

RELEASE_TIMESTAMP ?= $(shell date "+%Y%m%d_%H%M")

RELEASE_BUILDNUMBER ?= $(shell $(PINFO) -g buildNumber )
ZIPFILE := $(shell $(PINFO) -g name ).$(RELEASE_BUILDNUMBER).$(RELEASE_TIMESTAMP).zip
dist: clean compile
	zip -rp ../$(ZIPFILE) '$(GAME).pdx'
	@echo ""
	@echo "===>        file = ../$(ZIPFILE)"
	@echo "===>        game = $(GAME)"
	@echo "===> buildNumber = $(RELEASE_BUILDNUMBER)"
	@echo "         version = $(shell $(PINFO) -g version )"
	@echo "            name = $(shell $(PINFO) -g name )"
	@echo "        bundleID = $(shell $(PINFO) -g bundleID )"
.PHONY: dist

release: dist
.PHONY: release


BAKFILE:=$(GAME).src.$(shell date +"%+4Y%m%d.%H%M%S").tar

backup: clean
	@echo "++ Backing up source to ../$(BAKFILE).gz"
	@cd ..; tar -cvf $(BAKFILE) $(GAME) ; gzip $(BAKFILE)
	@echo ""
	@echo "===>        file = ../$(BAKFILE).gz"
.PHONY: backup
