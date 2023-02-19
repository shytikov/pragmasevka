.PHONY: help, images
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

builder: ## Create the `iosevka` builder Docker image
	docker build --no-cache -t iosevka/builder .

font: ## Run all build steps in correct order
	make ttf
	make --ignore-errors nerd
	make package

ttf: ## Build ttf font from `Pragmasevka` custom configuration
	docker run --rm \
		-v $(CURDIR)/dist:/builder/dist/pragmasevka \
		-v $(CURDIR)/private-build-plans.toml:/builder/private-build-plans.toml \
		iosevka/builder \
		npm run build -- ttf::pragmasevka
	rm -rf $(CURDIR)/dist/ttf-unhinted

nerd: ## Patch with Nerd Fonts glyphs
	docker run --rm \
		-v $(CURDIR)/dist/ttf:/in \
		-v $(CURDIR)/dist/nerd:/out \
		nerdfonts/patcher --complete --careful
	mv "$(CURDIR)/dist/nerd/Pragmasevka Nerd Font Complete.ttf" "$(CURDIR)/dist/nerd/pragmasevka-nf-regular.ttf"
	mv "$(CURDIR)/dist/nerd/Pragmasevka Italic Nerd Font Complete.ttf" "$(CURDIR)/dist/nerd/pragmasevka-nf-italic.ttf"
	mv "$(CURDIR)/dist/nerd/Pragmasevka Bold Nerd Font Complete.ttf" "$(CURDIR)/dist/nerd/pragmasevka-nf-bold.ttf"
	mv "$(CURDIR)/dist/nerd/Pragmasevka Bold Italic Nerd Font Complete.ttf" "$(CURDIR)/dist/nerd/pragmasevka-nf-bolditalic.ttf"

package: ## Pack fonts to ready-to-distribute archives
	zip -jr $(CURDIR)/dist/Pragmasevka.zip $(CURDIR)/dist/ttf/*.ttf
	zip -jr $(CURDIR)/dist/Pragmasevka_NF.zip $(CURDIR)/dist/nerd/*.ttf

clean:
	rm -rf $(CURDIR)/dist/*
