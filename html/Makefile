raws:=$(shell ls .. | grep -v ^html$)
htmls:=${raws:.md=.html}

all:${htmls}

%.html:../%.md Makefile
	markdown "$<" > "$@"
clean:
	rm -rf *.html Makefile~
