+++
title = "Environment"
date =  2024-12-24T21:43:00+05:30
weight = 1
+++

## Language and Standard
JavaScript is a prototype-based, multi-paradigm, single-threaded, dynamic language, supporting object-oriented, imperative, and declarative (e.g. functional programming) styles.

Created at Netscape for making dynamic webpages, now used for server backends too because of JS Engines like [V8](https://v8.dev/) running outside a browser like in Node.js.

The language is standardized by Ecma International as [ECMAScript Language Specification](https://tc39.es/ecma262/). Javascript is the most popular implementation of ECMAScript.

It is a JIT compiled interpreted language.

Many new languages are transpiled (converted) to Javascript before they run in the browser. Ex - TypeScript (Microsoft), Flow (Facebook), Dart (Google).

[Deno](https://deno.com/) was created by the creator of [Node.js](https://nodejs.org/) Ryan Dahl in 2018, based on V8 engine.

## JS in browser
```html
<!-- use script tags anywhere in HTML -->
<script>
	alert("A");
</script>
<script>
	alert("B");
</script>

<!-- or use external JS file -->
<script src="my.js">
	// any JS code written here will be ignored when using external script (src="")
</script>
```

## JS in non-browser environment
```sh
# run with Node
$> node hello.js

# run with Deno
$> deno run hello.js
```