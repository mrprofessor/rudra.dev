.PHONY: build run clean deploy

VERSION ?= latest

build:
	# hugo -D --destination docs --minify
	hugo -D --destination docs
	cp static/CNAME docs/

run:
	hugo server

clean:
	rm -rvf docs
	rm -rvf public

deploy:
	git add docs/
	git push origin master
