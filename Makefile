build:
	mkdir -p dist

	npm i
	npm audit
	npx typescript --strict wsrpc.d.ts
	npx rollup -c rollup.config.js
	npx uglify-js \
			-c --source-map --in-source-map dist/wsrpc.js.map \
			--overwrite -o dist/wsrpc.min.js dist/wsrpc.js

release: build
	npm publish --access public
