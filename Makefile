
all:
	cd formulaparser && lua parser-test.lua && cd ..
	rm calculator.plugin-0.9.0.zip -f
	7z u -l -mx=9 \
		calculator.plugin-0.9.0.zip * \
		-xr!.git* \
		-xr!.editorconfig$ \
		-xr!formulaparser/.git* \
		-xr!LICENSE$ \
		-xr!README.md$ \
		-xr!*.swp$ \
		-xr!*.zip$ \
		-xr!*test.lua$ \
		-xr!install-plugin.sh$


