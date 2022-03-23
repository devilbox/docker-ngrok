ifneq (,)
.error This Makefile requires GNU Make.
endif

# Ensure additional Makefiles are present
MAKEFILES = Makefile.docker Makefile.lint
$(MAKEFILES): URL=https://raw.githubusercontent.com/devilbox/makefiles/master/$(@)
$(MAKEFILES):
	@if ! (curl --fail -sS -o $(@) $(URL) || wget -O $(@) $(URL)); then \
		echo "Error, curl or wget required."; \
		echo "Exiting."; \
		false; \
	fi
include $(MAKEFILES)

# Set default Target
.DEFAULT_GOAL := help


# -------------------------------------------------------------------------------------------------
# Default configuration
# -------------------------------------------------------------------------------------------------
# Own vars
TAG        = latest

# Makefile.docker overwrites
NAME       = ngrok
VERSION    = 5.5
IMAGE      = devilbox/ngrok
FLAVOUR    = latest
FILE       = Dockerfile.$(FLAVOUR)
DIR        = Dockerfiles
ifeq ($(strip $(FLAVOUR)),latest)
DOCKER_TAG = $(TAG)
else
	ifeq ($(strip $(TAG)),latest)
		DOCKER_TAG = $(FLAVOUR)
	else
		DOCKER_TAG = $(FLAVOUR)-$(TAG)
	endif
endif
ARCH       = linux/amd64


# Makefile.lint overwrites
FL_IGNORES  = .git/,.github/,tests/
SC_IGNORES  = .git/,.github/,tests/


# -------------------------------------------------------------------------------------------------
#  Default Target
# -------------------------------------------------------------------------------------------------
.PHONY: help
help:
	@echo "lint                                     Lint project files and repository"
	@echo
	@echo "build [ARCH=...] [TAG=...]               Build Docker image"
	@echo "rebuild [ARCH=...] [TAG=...]             Build Docker image without cache"
	@echo "push [ARCH=...] [TAG=...]                Push Docker image to Docker hub"
	@echo
	@echo "manifest-create [ARCHES=...] [TAG=...]   Create multi-arch manifest"
	@echo "manifest-push [TAG=...]                  Push multi-arch manifest"
	@echo
	@echo "test [ARCH=...]                          Test built Docker image"
	@echo


# -------------------------------------------------------------------------------------------------
#  Docker Targets
# -------------------------------------------------------------------------------------------------

NGROK = ARCH=$(subst /,-,$(ARCH))
ifeq ($(strip $(ARCH)),linux/arm/v6)
NGROK = linux-arm
endif
ifeq ($(strip $(ARCH)),linux/arm/v7)
NGROK = linux-arm
endif


.PHONY: build
build: ARGS=--build-arg ARCH=$(NGROK)
build: docker-arch-build

.PHONY: rebuild
rebuild: ARGS=--build-arg ARCH=$(NGROK)
rebuild: docker-arch-rebuild

.PHONY: push
push: docker-arch-push


# -------------------------------------------------------------------------------------------------
#  Manifest Targets
# -------------------------------------------------------------------------------------------------
.PHONY: manifest-create
manifest-create: docker-manifest-create

.PHONY: manifest-push
manifest-push: docker-manifest-push


# -------------------------------------------------------------------------------------------------
#  Test Targets
# -------------------------------------------------------------------------------------------------
.PHONY: test
test: _test-integration

.PHONY: _test-integration
_test-integration:
	./tests/test.sh $(IMAGE) $(ARCH) $(DOCKER_TAG)
