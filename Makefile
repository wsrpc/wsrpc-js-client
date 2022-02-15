all: build

dist:
	mkdir -p dist

install:
	npm i --include=dev
	npm audit

wsrpc.d.ts: install
	npm x -- tsc --strict wsrpc.d.ts

dist/wsrpc.es6.js:
	cp wsrpc.es6.js dist/

dist/wsrpc.js: install dist/wsrpc.es6.js
	cd dist && npm x -- rollup -c ../rollup.config.js

dist/wsrpc.min.js: install dist/wsrpc.js
	cd dist && npm x -- uglify-js \
			-c --source-map wsrpc.min.js.map --in-source-map wsrpc.js.map \
			--overwrite -o wsrpc.min.js wsrpc.js

build: wsrpc.d.ts dist/wsrpc.min.js

clean:
	rm -fr build

release: build
	npm publish --access public
