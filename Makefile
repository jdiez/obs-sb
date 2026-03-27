.PHONY: new-vault test clean help

TEMPLATE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

new-vault: ## Generate a new vault (interactive prompts)
	cookiecutter $(TEMPLATE_DIR)

test: ## Generate a test vault with defaults, then clean up
	cookiecutter $(TEMPLATE_DIR) --no-input --output-dir /tmp/obs-sb-test
	@echo "✅ Test vault generated at /tmp/obs-sb-test/my-second-brain"
	@echo "   Open in Obsidian to verify, then run 'make clean' to remove"

clean: ## Remove test vault
	rm -rf /tmp/obs-sb-test
	@echo "✅ Test vault cleaned up"
