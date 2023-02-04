.PHONY: help
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

builder: ## Create the `iosevka` builder Docker image
	docker build --no-cache -t iosevka/builder -f Dockerfile

font: ## Run all build steps in correct order
	make ttf
	make nerd

ttf: ## Build ttf font from `Pragmasevka` custom configuration
	docker run --rm \
		-v $(CURDIR)/dist:/builder/dist/pragmasevka \
		-v $(CURDIR)/private-build-plans.toml:/builder/private-build-plans.toml \
		iosevka/builder \
		npm run build -- ttf::pragmasevka

nerd: ## Patch with Nerd Fonts glyphs
	docker run --rm \
		-v $(CURDIR)/dist/ttf:/in \
		-v $(CURDIR)/dist:/out \
		nerdfonts/patcher --complete --careful
