all: clean
	./cleanupCRs.sh
	./index.sh
	./build.sh build
	./postprod.sh

clean:
	rm -rf ./*.html ./*.md Makefile~
