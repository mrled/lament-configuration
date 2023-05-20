# Lament Configuration Makefile

# A directory for intermediate build artifacts
BUILD = $(PWD)/build
# A directory for the root of the RPM build tree
# rpmbuild uses its own by default,
# but when running 'make install` outside of rpmbuild to inspect the result,
# this is a good value.
BUILDROOT ?= $(BUILD)/root
# The top directory for rpmbuild
# This is the default value for rpmbuild, made explicit here so we can list the build result
RPMBUILD_TOPDIR ?= $(HOME)/rpmbuild
# The major and minor version number components
VER_MAJOR = 0
VER_MINOR = 1
# We use this file to keep track of the build number, which is used as the patch component
BUILDNUMFILE = $(PWD)/BUILDNUM
# The release of the RPM
RELEASE = 0

# Placing this first means that 'make' by itself shows a nice help message
.PHONY: help
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | \
		sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Because rpmbuild calls 'make install' with a custom BUILDROOT value inside $(RPMBUILD_TOPDIR),
# we explicitly clean files from both locations.
.PHONY: clean
clean: ## Clean generated artifacts
	rm -rf $(BUILDROOT)
	rm -rf $(RPMBUILD_TOPDIR)/RPMS/noarch/lament-configuration*.rpm
	rm -rf $(RPMBUILD_TOPDIR)/BUILDROOT/lament-configuration*

# This can be called by the user to install the salt files to BUILDROOT,
# rpmbuild calls it with a custom BUILDROOT value.
.PHONY: install
install: ## Install the Lament Configuration (to the value of BUILDROOT)
	mkdir -p "$(BUILDROOT)"
	cp -ra srv "$(BUILDROOT)/"

# Warning: '$(shell ...)' is evaluated when the Makefile is parsed!
# To see the current content of a file after we mutate it, we cannot use $(shell cat filename);
# instead, we use '$$(cat filename)'.
.PHONY: incver
incver: ## Increment the version number
	@echo "Current version: $$(cat $(BUILDNUMFILE))"
	@echo $$(($(shell cat $(BUILDNUMFILE)) + 1)) > $(BUILDNUMFILE)
	@echo "New version: $$(cat $(BUILDNUMFILE))"

.PHONY: rpm
rpm: ## Build an RPM for the current version based on BUILDNUM
	cd build \
		&& rpmbuild -bb \
			--define "_topdir $(RPMBUILD_TOPDIR)" \
			--define "lament_source_root $(PWD)" \
			--define "version $(VER_MAJOR).$(VER_MINOR).$$(cat $(BUILDNUMFILE))" \
			--define "release $(RELEASE)" \
			$(PWD)/lament-configuration.spec
	ls -alF $(RPMBUILD_TOPDIR)/RPMS/noarch

.PHONY: newrpm
newrpm: incver rpm ## Increment the version number and build an RPM
