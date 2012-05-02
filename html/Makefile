raws:=$(shell ls .. | grep -v ^html$)
htmls:=${raws:=.html}

all:${htmls}

%.html:../% Makefile
	markdown $< > $@

clean:
	rm -rf *.html Makefile~
