# Lament Configuration Makefile

.PHONY: help
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: dist/lament.conf.tar ## Build the Lament Configuration tarball

.PHONY: clean
clean: ## Clean generated artifacts
	rm -rf dist

dist/lament.conf.tar: build/srv/lament/pull.sh
	mkdir -p dist
	tar -c -C srv --exclude dist --exclude build -f dist/lament.conf.tar .
	@echo "To use this, you must copy the Lament Configuration tarball to dom0."
	@echo "Please understand the security implications of this."
	@echo "See the README.md for specific instructions"

