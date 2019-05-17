WSRPC client
------------

[![license](https://img.shields.io/pypi/l/wsrpc-aiohttp.svg)](https://pypi.python.org/pypi/wsrpc-aiohttp/)

Easy to use javascript client for
[wsrpc-aiohttp](https://pypi.org/project/wsrpc-aiohttp/) or
[wsrpc-tornado](https://pypi.org/project/wsrpc-tornado/) websocket servers.

See [online demo](https://demo.wsrpc.info/) and
[documentation](https://docs.wsrpc.info/) with examples.

Features
========

-   Allows to call server functions from the client side and to
    call client functions from the server side (e.g. to notify clients about
    events);
-   Async connection protocol: both server or client are able to call
    multiple functions and get responses as soon as each response would be
    ready in any order;
-   Transfers any exceptions from a client side to the server side and
    vise versa;
-   No dependencies;
-   Messaging is based on [JsonRPC](https://www.jsonrpc.org) protocol;
-   Provides typescript interface, ES6 module and
    [UMD](https://github.com/umdjs/umd) distribution as well.
-   Ability to implement very complex scenarios.

Installation
============

Install via npm:

    npm install wsrpc-js-client

Usage
=====

Let's implement application, that tells jokes by request and collects feedback
about them (see [jsfiddle](https://jsfiddle.net/pvms5ej1/)).

[Backend]((https://github.com/wsrpc/wsrpc-aiohttp/blob/master/docs/source/examples/server.py))
is located at [demo.wsrpc.info](https://docs.wsrpc.info/).

``` {.HTML}
<script type="text/javascript" src="https://demo.wsrpc.info/js/wsrpc.js"></script>
<script>
var RPC = new WSRPC('wss://demo.wsrpc.info/ws/', 5000);

// Register client route, that can be called by server.
// It would be called by server, when server sends a joke.
RPC.addRoute('joke', function (data) {

    // After server sends a joke server waits for an answer, if joke is
    // funny. test.getJoke call is going to be finished only after user
    // sends response.
    return confirm(data.joke + '\n\nThat was funny?');
});
RPC.connect();

// Request server to tell a joke by calling test.getJoke
// Server would call client route 'joke' (registered above) and wait for
// client answer (if joke is funny or not).
RPC.call('test.getJoke', {}).then((result) => {

    // Here you would finally see server reaction on your feedback about
    // joke.
    // If 'joke' client route responds that joke is funny - you would see
    // something like 'Cool!', or 'Hmm... try again' if it's not.
    alert(result);
}, (error) => {
    alert(e.type + '("' + e.message + '")');
});
</script>
```

Versioning
==========

This software follows [Semantic Versioning](http://semver.org/)
