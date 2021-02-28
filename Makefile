#!/bin/bash -e -o pipefail

usage:
	@printf "\033[1;35mTargets:\033[0m format, install, jazzy, lint\n"

install:
	ifeq (, $(shell which lzop))
		$(error "No brew installed, visit https://brew.sh/")
	endif
	brew upgrade swiftformat swiftlint
	gem install jazzy

format:
	. Scripts/swiftformat --swiftversion 5.1 $(shell pwd)

lint:
	. Scripts/swiftlint $(shell pwd)

jazzy:
	jazzy \
	  --clean \
	  --author Sofia \
	  --author_url https://github.com/phynet/ \
	  --github_url https://github.com/phynet/Bikini \
	  --xcodebuild-arguments -scheme,Bikini \
	  --module Bikini \
	  --output Build/API
