VERSION=$(shell grep Version: VERSION | sed 's/Version: //g')


all: test clean zip

test:
	cd formulaparser && lua parser-test.lua && cd ..

clean: 
	rm calculator.koplugin-$(VERSION).zip -f
	rm -rf tmp/calculator.koplugin


zip: clean

	mkdir -p tmp/calculator.koplugin
	rsync -a --cvs-exclude \
		--exclude '*.editorconfig' \
		--exclude '*.gitignore' \
		--exclude 'Makefile' \
		--exclude 'LICENSE' \
		--exclude 'README.md' \
		--exclude '*test.lua' \
		--exclude '*.swp' \
		--exclude '*.zip' \
		--exclude '*install-plugin.sh' \
		--exclude '*.sh' \
		--exclude 'tmp*' \
		. tmp/calculator.koplugin

	cd tmp && 7z a -l -mx9 -mfb=256 -mmt=on \
		../calculator.koplugin-$(VERSION).zip *

