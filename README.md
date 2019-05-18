WSRPC client
------------

[![license](https://img.shields.io/npm/l/wsrpc-python.svg)](https://npmjs.com/package/wsrpc-python)

Easy to use javascript client for
[wsrpc-aiohttp](https://pypi.org/project/wsrpc-aiohttp/) or
[wsrpc-tornado](https://pypi.org/project/wsrpc-tornado/) websocket servers.

See [online demo](https://demo.wsrpc.info/) and
[documentation](https://docs.wsrpc.info/) with examples.

* [Features](#features)
* [Installation](#installation)
* [Usage](#usage)
* [API](#api)
  * [Global configuration](#global-configuration)
  * [Constructor options](#constructor-options)
  * [Methods](#methods)

# Features

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

# Installation

Install via npm:

    npm install @wsrpc/client

# Usage

Let's implement application, that tells jokes by request and collects feedback
about them (see [jsfiddle](https://jsfiddle.net/ke3z4bph/)).

[Backend]((https://github.com/wsrpc/wsrpc-aiohttp/blob/master/docs/source/examples/server.py))
is located at [demo.wsrpc.info](https://docs.wsrpc.info/).

```html
<script type="text/javascript" src="//unpkg.com/@wsrpc/client"></script>
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
    alert(error.type + '("' + error.message + '")');
});
</script>
```

# API
## Global configuration
#### WSRPC.DEBUG
Static boolean flag, controls whether debug information should be displayed.

Can be enabled/disabled at any moment.
```js
WSRPC.DEBUG = true;
var RPC = new WSRPC(...);
...
```

#### WSRPC.TRACE
Static boolean flag, controls whether information about events and errors 
should be traced.

Can be enabled/disabled at any moment.
```js
WSRPC.TRACE = true;
var RPC = new WSRPC(...);
...
```

## Constructor options
URL, reconnectTimeout = 1000

Parameter          | Type    | Required | Description
-------------------|---------|----------|------------
`URL`              | string  | Yes      | Absolute or relative URL
`reconnectTimeout` | number  | No       | Timeout for reconnecting, defaults to `1000` ms

```js
// Url can be relative (schema for websocket would be detected automatically 
// depending on page http/https schema)
var RelativeUrlRPC = new WSRPC('/ws/', 5000);

// Absolute websocket url example
var UnsecureRPC = new WSRPC('ws://example.com/ws', 5000);

// Secure absolute websocket url example
var SecureRPC = new WSRPC('wss://example.com/ws', 5000);
```

## Methods

#### WSRPC.connect()
Establishes connection with the server.

```js
var RPC = new WSRPC(url);
RPC.connect();
```

#### WSRPC.destroy()
Closes socket.

```js
var RPC = new WSRPC(url);

var deferred = RPC.onEvent('onconnect');
deferred.resolve = function() {
    RPC.destroy();
};

RPC.connect();
```

#### WSRPC.state()
Get current socket state as a string.

Possible values: `CONNECTING`, `OPEN`, `CLOSING`, `CLOSED`.

```js
var RPC = new WSRPC(url);
console.log(RPC.state());  // Displays CLOSED
```

#### WSRPC.stateCode()
Get current socket state code (integer). Possible values:

Code | State
-----|---------
0    | CONNECTING
1    | OPEN
2    | CLOSING
3    | CLOSED

```js
var RPC = new WSRPC(url);
console.log(RPC.stateCode());  // Displays 3
```

#### WSRPC.addRoute(name, callback)
Register route on the client with specified name, route added later replaces 
route added earlier with the same name.

Parameter | Type
----------|------
name      | string
callback  | function

Callback would be called with `object` type parameter `data` containing 
parameters from server. Callback return value would be received by server. 

```js
var RPC = new WSRPC(url);
RPC.addRoute('askUser', function(data) {
    // Data is object, containing parameters from server.
    // Would display question ask user to enter response and return response 
    // to the server. 
    return { response: prompt(data.question) };
});
```

#### WSRPC.deleteRoute(name)
Remove specified client route.

Parameter | Type
----------|------
name      | string

```js
var RPC = new WSRPC(url);
RPC.addRoute('askUser', function() { return {} });
RPC.deleteRoute('askUser');
```

#### WSRPC.call(route, params)
Call server function with specified parameters, returns `Promise` that can be
awaited using await syntax.

Parameter | Type
----------|------
route     | string
params    | object

```js
var RPC = new WSRPC(url);
RPC.connect();
RPC.call('serverRoute', {
    param1: 'value1', 
    param2: 'value2'
}).then((result) => {
    alert(result);
}, (error) => {
    alert(error.type + '("' + error.message + '")');
});
```

#### WSRPC.addEventListener(event, callback)
Add permanent callback for event (see `onEvent` to register one time event).
Returns eventId, that can be used later to remove event.

Parameter | Type
----------|------
event     | string
callback  | function

```js
var RPC = new WSRPC(url);
RPC.addEventListener('onconnect', function() {
    console.log('Connected to the server!');
});
```

#### WSRPC.removeEventListener(event, eventId)
Remove event listener using eventId (returned by `addEventListener`).

Parameter | Type
----------|------
event     | string
eventId   | integer

```js
var RPC = new WSRPC(url);
var eventId = RPC.addEventListener('onconnect', function() {
    console.log('Connected to the server!');
});
RPC.removeEventListener('onconnect', eventId);
```

#### WSRPC.onEvent(event)
Get deferred object, that would execute only once for specified event.
deferred.promise is a native `Promise` and can be awaited using await syntax.

Parameter | Type
----------|------
event     | string

```js
var RPC = new WSRPC(url);

var deferred = RPC.onEvent('onconnect');
deferred.resolve = function() {
    RPC.destroy();
};

RPC.connect();
```

# Versioning

This software follows [Semantic Versioning](http://semver.org/)
