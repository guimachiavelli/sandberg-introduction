.PHONY: all build

build: ./content/slides.yml
	@ruby ./generate.rb $<
