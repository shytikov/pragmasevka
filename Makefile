.PHONY: help, images
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

images: ## Create Docker image dependencies
	make builder
	make scripter

builder: ## Create the `iosevka` builder Docker image
	docker build --no-cache -t iosevka/builder ./images/iosevka

scripter: ## Create the `fontforge` scripter Docker image
	docker build --no-cache -t fontforge/scripter ./images/fontforge

font: ## Run all build steps in correct order
	make ttf
	make punctuation
	make nerd

ttf: ## Build ttf font from `Pragmasevka` custom configuration
	docker run --rm \
		-v $(CURDIR)/dist:/builder/dist/pragmasevka \
		-v $(CURDIR)/private-build-plans.toml:/builder/private-build-plans.toml \
		iosevka/builder \
		npm run build -- ttf::pragmasevka
		rm -rf $(CURDIR)/dist/ttf-unhinted

punctuation: ## In-place update of punctuation
	docker run --rm \
		-v $(CURDIR):/scripter \
		fontforge/scripter \
		python /scripter/punctuation.py ./dist/ttf/pragmasevka
	rm -rf $(CURDIR)/dist/ttf/*semibold*.ttf
	rm -rf $(CURDIR)/dist/ttf/*black*.ttf

nerd: ## Patch with Nerd Fonts glyphs
	docker run --rm \
		-v $(CURDIR)/dist/ttf:/in \
		-v $(CURDIR)/dist:/out \
		nerdfonts/patcher --complete --careful

clean:
	rm -rf $(CURDIR)/dist/*