import babel from 'rollup-plugin-babel';


// noinspection JSUnusedGlobalSymbols
export default [
	Object.freeze({
		input: 'wsrpc.es6.js',
		output: {
			file: 'wsrpc.js',
			name: 'WSRPC',
			format: 'umd',
			sourcemap: true
		},
		plugins: [
			babel({
				babelrc: false,
				compact: false,
				presets: ["@babel/preset-env"]
			}),
		]
	}),
];
