VERSION=$(shell grep Version: VERSION | sed 's/Version: //g')

all:
	cd formulaparser && lua parser-test.lua && cd ..
	rm calculator.koplugin-$(VERSION).zip -f
	7z u -l -mx=9 -mfb=256 -mmt=on \
		calculator.koplugin-$(VERSION).zip * \
		-xr!.git* \
		-xr!.editorconfig$ \
		-xr!formulaparser/.git* \
		-xr!LICENSE$ \
		-xr!README.md$ \
		-xr!*.swp$ \
		-xr!*.zip$ \
		-xr!*test.lua$ \
		-xr!install-plugin.sh$


