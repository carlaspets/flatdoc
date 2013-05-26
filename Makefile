UGLIFY := ./node_modules/.bin/uglifyjs --comments "/^!/"
STYLUS := ./node_modules/.bin/stylus -U -u nib
DOX := dox

all: \
	flatdoc.js \
	legacy.js \
	theme-white/style.css \
	theme-white/script.js

watch:
	while true; do make all | grep -v "Nothing"; sleep 1; done

flatdoc.js: src/flatdoc.js vendor/marked.js vendor/base64.js
	cat $^ > $@

legacy.js: vendor/html5shiv.js vendor/respond.js
	cat $^ > $@

%.css: %.styl
	$(STYLUS) < $< > $@

theme-white/script.js: theme-white/setup.js vendor/jquery.scrollagent.js vendor/jquery.anchorjump.js
	cat $^ > $@

Reference.md: src/flatdoc.js Makefile
	$(DOX) -a < $< | sed "s/^## \(.*\.\)/### \1/g" > $@

# $ make v/0.1.0
# Makes a distribution.
#
v/%: all
	mkdir -p $@
	$(UGLIFY) < flatdoc.js > $@/flatdoc.js
	$(UGLIFY) < legacy.js > $@/legacy.js
	mkdir -p $@/theme-white
	cp theme-white/style.css $@/theme-white
	cp theme-white/script.js $@/theme-white

.PHONY: watch
