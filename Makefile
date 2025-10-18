# Documentation
docs-serve:  ## Start local documentation server (http://127.0.0.1:8000)
	rm -rf site/ && poetry run mkdocs serve

docs-build:  ## Build documentation site
	rm -rf site/ && poetry run mkdocs build

# Help
help:  ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

.PHONY: docs-serve docs-build help
