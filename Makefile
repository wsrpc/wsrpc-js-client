build:
	mkdir -p dist

	npm i --include=dev
	npm audit fix --force
	npm x -- tsc --strict wsrpc.d.ts
	npm x -- rollup -c rollup.config.js
	npm x -- uglify-js \
			-c --source-map dist/wsrpc.min.js.map --in-source-map dist/wsrpc.js.map \
			--overwrite -o dist/wsrpc.min.js dist/wsrpc.js

release: build
	npm publish --access public
