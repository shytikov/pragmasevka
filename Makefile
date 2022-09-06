.PHONY: help
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

builder: ## Create the `iosevka` builder Docker image
	docker build --no-cache -t iosevka . -f Dockerfile

font: ## Build ttf font from `Pragmasevka` custom configuration
	docker run --rm \
		-v $(CURDIR)/dist:/builder/dist/pragmasevka \
		-v $(CURDIR)/private-build-plans.toml:/builder/private-build-plans.toml \
		iosevka \
		npm run build -- ttf::pragmasevka;

