+++
title = "Security"
date = 2021-05-23T21:35:33+05:30
weight = 5
+++

### Summary
```txt
Basic Authentication

Session Based Authentication

Token Based Authentication
	API Key
	Bearer Token
	JWT
	OAuth 2.0
```

## Basic Authentication
```foobar
Authorization: Basic <"username:password" encoded in base64>
```

Server checks for `Authorization` header and if not present or invliad credentials, it sends back `www-authenticate` header (a prompt is shown in the browser to input credentials). 

The client then sends `username:password` encoded in base64 in `Authorization: Basic r4Dl3tFaXffsdfsvSse3=` header and it is decoded and credentials are verified on the server. The server either sends `401 Unauthorized` again or `200 OK`.

In APIs, there is no prompt so it acts like a simple API key. Always use HTTPS/TLS with it.

[Reference](https://roadmap.sh/guides/basic-authentication)

## Session Based Authentication
A random unique identifier called session token (_aka_ session ID) is generated and stored on successful login onto the server and shared back with the client. Client also stores it in either cookies or local storage (if cookies are disabled). The client has to send that token in every subsequent request.

On every request, the server checks if session is still valid for that user. When the user logs out, the session id gets deleted from the server and subsequently the client, and that session id is never used again.

[Reference](https://roadmap.sh/guides/session-authentication)

## Token Based Authentication
- Always use HTTPS/TLS in conjunction with token based authentication mechanisms since tokens can be visible to everyone.

- Tokens are usually generated on and fetched from the server (using another auth mechanism like username and password) and sent in subsequent requests. They have an expiration time and must be fetched again (refreshed) after that time has passed otherwise they become invalid and server returns a `401` as response status code.

- Client stores the token. Server doesn't store the token (stateless)

- Tokens are normally signed with a secret to identify any tampering
### API Key
Provide API key in a custom header (e.g. `X-Api-Key`) to users and include that in requests and it is verified by the server. Simplest method but unsafe.

API-key can be present anywhere in header, cookie, query param, body, etc...

### Bearer
```foobar
Authorization: Bearer <token_string>
```
Bearer tokens come from OAuth 2.0 specification but they can be used in a standalone way. Bearer tokens don't have a particular meaning unlike Basic tokens.

[Reference](https://roadmap.sh/guides/token-authentication)

### JWT (JSON Web Token)
Just like the other token based strategies but only differentiator being the token structure.
```txt
header.payload.signature

header = base64(tokenMeta)
payload = base64(ourData)
signature = HMAC_SHA256(header.payload, SECRET)
```
```json
// tokenMeta

{
	"typ": "jwt",
	"alg": "H256"
}

// ourData: data + claims
{
	"userid": "XDF-11",
	"email": "johndoe@gmail.com",
	"exp": "1592427938",
	"iat": "1590969600"
}

// SECRET - server stores it, used to generate and verify tokens
```

- the contents of a JWT are visible to everyone
- can be passed in header, body or as a query param
- we can pass it as `Authorization: Bearer <jwt_token>`

[Reference](https://roadmap.sh/guides/jwt-authentication)


### OAuth 2.0
[Reference](https://roadmap.sh/guides/oauth)

## References
- [API authentication and authorization](https://idratherbewriting.com/learnapidoc/docapis_more_about_authorization.html)
- [roadmap.sh guides](https://roadmap.sh/guides)
- [Authentication - OpenAPI Guide](https://swagger.io/docs/specification/authentication/)
- [HTTP Authentication - MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication)
- [OAuth 2.0 Simplified](https://aaronparecki.com/oauth-2-simplified/)