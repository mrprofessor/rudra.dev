.PHONY: build run clean deploy

VERSION ?= latest

build:
	hugo -D --destination docs --minify 
	cp static/CNAME docs/

run:
	hugo server

clean:
	rm -rvf docs
	rm -rvf public

deploy:
	git add docs/
	git commit -m "Site build"
	git push origin master
