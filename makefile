.PHONY: deploy

BUILD_DIR = build

build: ./content/slides.yml
	@ruby ./generate.rb $<

ghpages: $(BUILD_DIR)/index.html
	git subtree push --prefix $(BUILD_DIR) origin gh-pages

deploy: build ghpages
