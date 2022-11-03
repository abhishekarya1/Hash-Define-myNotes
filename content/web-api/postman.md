+++
title = "Postman"
date = 2022-11-03T19:00:00+05:30
weight = 8
+++

### Environment
Create an environment and define variables in its scope

### Variables
```txt
{{baseURL}}/api/users/2

limit={{pageSize}}

https://reqres.in/users/{{category}}
```
- variables can be bound to a scope - global, a specific environment, collection

- make variables _secret_ so they're hidden behind dots in the UI

- make them _persist_ to make initial value same as the current value before sharing with others  

### Parameters (Query & Path)
`/api/users?limit=5&sort=asc`

`/api/users/:uid`

### Random Values
set random values in JSON - `"{{$randomFullName}}"`

see console for value passed at runtime

### Tests
Tests are in JavaScript and run after every request, can be defined at collection scope (will still run after every request run) or individually for a request

```js
pm.test("Foobar", () => {
	pm.expect(1).eql(1);
});
```

### Runner
Use **Runner** to run collections/request: define order, iterations, delay, see summary stats
