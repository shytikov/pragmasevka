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
	make --ignore-errors ttf
	make --ignore-errors nerd
	make --ignore-errors package

ttf: ## Build ttf font from `Pragmasevka` custom configuration
	docker run --rm \
		-v pragmasevka-volume:/builder/dist/pragmasevka/ttf \
		-v $(CURDIR)/private-build-plans.toml:/builder/private-build-plans.toml \
		iosevka/builder \
		npm run build -- ttf::pragmasevka
	docker run --rm \
		-v pragmasevka-volume:/scripter \
		-v $(CURDIR)/punctuation.py:/scripter/punctuation.py \
		fontforge/scripter \
		python /scripter/punctuation.py ./pragmasevka
	docker container create \
		-v pragmasevka-volume:/ttf \
		--name pragmasevka-dummy \
		alpine
	mkdir -p $(CURDIR)/dist/ttf
	docker cp pragmasevka-dummy:/ttf $(CURDIR)/dist
	docker rm pragmasevka-dummy
	docker volume rm pragmasevka-volume
	rm -rf $(CURDIR)/dist/ttf/*semibold*.ttf
	rm -rf $(CURDIR)/dist/ttf/*black*.ttf
	rm -rf $(CURDIR)/dist/ttf/punctuation.py

nerd: ## Patch with Nerd Fonts glyphs
	docker run --rm \
		-v $(CURDIR)/dist/ttf:/in \
		-v pragmasevka-volume:/out \
		nerdfonts/patcher --complete --careful
	docker container create \
		-v pragmasevka-volume:/nerd \
		--name pragmasevka-dummy \
		alpine
	docker cp pragmasevka-dummy:/nerd $(CURDIR)/dist
	docker rm pragmasevka-dummy
	docker volume rm pragmasevka-volume
	mv "$(CURDIR)/dist/nerd/PragmasevkaNerdFont-Regular.ttf" "$(CURDIR)/dist/nerd/pragmasevka-nf-regular.ttf"
	mv "$(CURDIR)/dist/nerd/PragmasevkaNerdFont-Italic.ttf" "$(CURDIR)/dist/nerd/pragmasevka-nf-italic.ttf"
	mv "$(CURDIR)/dist/nerd/PragmasevkaNerdFont-Bold.ttf" "$(CURDIR)/dist/nerd/pragmasevka-nf-bold.ttf"
	mv "$(CURDIR)/dist/nerd/PragmasevkaNerdFont-BoldItalic.ttf" "$(CURDIR)/dist/nerd/pragmasevka-nf-bolditalic.ttf"

package: ## Pack fonts to ready-to-distribute archives
	zip -jr $(CURDIR)/dist/Pragmasevka.zip $(CURDIR)/dist/ttf/*.ttf
	zip -jr $(CURDIR)/dist/Pragmasevka_NF.zip $(CURDIR)/dist/nerd/*.ttf

clean:
	rm -rf $(CURDIR)/dist/*
