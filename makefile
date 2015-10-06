.PHONY: all

build: ./content/slides.yml
	@ruby ./generate-presentation.rb $<
