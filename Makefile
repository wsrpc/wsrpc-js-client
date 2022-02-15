build:
	mkdir -p dist

	npm i --include=dev
	npm audit
	npm x -- tsc --strict wsrpc.d.ts
	cp wsrpc.es6.js dist/
	cd dist && npm x -- rollup -c ../rollup.config.js
	cd dist && npm x -- uglify-js \
			-c --source-map wsrpc.min.js.map --in-source-map wsrpc.js.map \
			--overwrite -o wsrpc.min.js wsrpc.js

release: build
	npm publish --access public
