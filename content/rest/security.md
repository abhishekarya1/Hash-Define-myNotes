+++
title = "Security"
date = 2021-05-23T21:35:33+05:30
weight = 3
+++

## Security
```txt
API Key
Token Based
HMAC (Hash-based Message Authorization Code)
OAuth 2.0
```

### API Key
Provide API key to user and include that in request everytime and it is verified everytime a connection is made to server.

### Basic Authentication
[Reference](https://roadmap.sh/guides/basic-authentication)

Server checks for `Authorization` header and if not present sends back `www-authenticate` header. The client then sends `username:password` encoded in base64 as `Authorization: Basic r4Dl3tFaXffsdfsvSse3=` and the same is verified on server and server either sends `401 (Unauthorized)` or `200 (OK)`.

### Session Based Authentication
[Reference](https://roadmap.sh/guides/session-authentication)

A session token is generated on successful login onto the server and shared back with the client. Client also stores it in either cookies or local storage (if cookies are disabled). The client has to send that token in every request. The token gets deleted from both the server and client when the session ends and never used again.

### Token Based Authentication
[Reference](https://roadmap.sh/guides/token-authentication)

A token is generated if credentials are verified, the token is sent to the client and client has to include in every future request to the server, the server doesn't store the token.

- server doesn't store it (stateless)
- has an expiry after which its not usable
- can be opaque (random string, doesn't contain any useful data for client, like session keys) or self-contained (has useful data to be read by clients, like JWT tokens)
- normally signed with a secret to identify any tampering

#### JWT Authentication (JSON Web Token)
[Reference](https://roadmap.sh/guides/jwt-authentication)

Just like any other token based strategy but only differentiator being the way in which token is generated.

### OAuth 2.0
[Reference](https://roadmap.sh/guides/oauth)


## References
- [API authentication and authorization](https://idratherbewriting.com/learnapidoc/docapis_more_about_authorization.html)
- [roadmap.sh guides](https://roadmap.sh/guides)
- [MDN Docs - Mozilla](https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication)
- [OAuth 2.0 Simplified](https://aaronparecki.com/oauth-2-simplified/)