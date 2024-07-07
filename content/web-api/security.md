+++
title = "Security I"
date = 2021-05-23T21:35:33+05:30
weight = 5
+++

### Summary
```txt
Basic Auth

Session Based Auth

Token Based Auth
	API Key
	Bearer Token
	JWT
	OAuth 2.0
```

### Authentication vs Authorization
Authentication deals with the identity of the user: The "Who are you?" part. Prove identity using passwords.

Authorization deals with the access of resources for a user: The "Can you access that?" part. Follows authentication.

## Basic Auth
```foobar
Authorization: Basic <"username:password" encoded in base64>
```

Server checks for `Authorization` header and if not present or invalid credentials, it sends back `www-authenticate` header (a prompt is shown in the browser to input credentials). 

The client then sends `username:password` encoded in base64 in `Authorization: Basic r4Dl3tFaXffsdfsvSse3=` header and it is decoded and credentials are verified on the server. The server either sends `401 Unauthorized` again or `200 OK`.

In APIs, there is no prompt so it acts like a simple API key. Always use HTTPS/TLS with it.

[Reference](https://roadmap.sh/guides/basic-authentication)

## Session Based Auth
A random unique identifier called session token (_aka_ session ID) is generated and stored on successful login onto the server and shared back with the client. Client also stores it in either cookies or local storage (if cookies are disabled). The client has to send that token in every subsequent request.

Often uses cookies since storage on client and sending in subsequent request is to be done.

On every request, the server checks if session is still valid for that user. When the user logs out, the session id gets deleted from the server and subsequently the client, and that session id is never used again.

[Reference](https://roadmap.sh/guides/session-authentication)

## Token Based Auth
- Always use HTTPS/TLS in conjunction with token based authentication mechanisms since tokens can be visible to everyone.

- Tokens are usually generated on and fetched from the server (using another auth mechanism like username and password) and sent in subsequent requests. They have an expiration time and must be fetched again (refreshed) after that time has passed otherwise they become invalid and server returns a `401` as response status code.

- Client stores the token. Server doesn't store the token (stateless)

- Tokens are normally signed with a secret to identify any tampering
### API Key
Provide API key in a custom header (e.g. `X-Api-Key`) to users and include that in requests and it is verified by the server.

API-key can be present anywhere in header, cookie, query param, body, etc...

### Bearer
```foobar
Authorization: Bearer <token_string>
```
Bearer tokens come from OAuth 2.0 specification but they can be used in a standalone way. Bearer tokens don't have a particular meaning unlike Basic tokens.

[Reference](https://roadmap.sh/guides/token-authentication)

### JWT (JSON Web Token)
Just like the other token based strategies but only differentiator is that the token structure is standardized here.

```txt
header.payload.signature

header = base64(tokenMeta)
payload = base64(claims)
signature = HMAC_SHA256(header.payload, SECRET)
```
```json
// tokenMeta

{
	"typ": "jwt",
	"alg": "H256"
}

// claims (in this example: 2 custom public + 2 registered)
{
	"userid": "XDF-11",
	"email": "johndoe@gmail.com",
	"exp": "1592427938",
	"iat": "1590969600"
}

// SECRET - server stores it, used to generate a symmetric key for HMAC algorithm to create signature part of JWT token
```

The signature (anti-tampering measure) proves that the token is received as-is (as server generated it) from the client and the username and expiration date present in it are correct. So token verification in JWT boils down to just checking the signature validity and then we can extract payload (claims) and identify user and their access rights from that info.

- the contents of a JWT are visible to everyone (except the signature part which is a SHA256 hash)
- claims can be private too (obfuscated; have names that have no meaning)
- can be passed in header, body or as a query param
- we can pass it as `Authorization: Bearer <jwt_token>` HTTP header

**Pros**: lightweight, stateless, standalone as no token store is required on the server-side.

**Cons**: since its standalone, the token has full authority. This means that if anyone gets their hands on the token they can impersonate us till it expires.

**Refresh Tokens**: JWT tokens can be refreshed if the client sends the security server a Refresh Token. The server initially sends both the Access Token and a Refresh Token to the client at the time of token creation and issue. The client stores the refresh token securely, often in a secure HTTP-only cookie or local storage. It can then use it later to get another access token **without terminating the session**.

**Some Tips and Pointers**:
- if someone gets JWT and modifies the claims, then signature verification will not match so it is safe. But never store anything confidential in claims as they are not cryptographically encrypted (just encoded).
- we can encrypt JWT token itself to enhance security (and not only send it as Base64 string). It is done using JSON Web Encryption (JWE) standard.
- we can have asymmetric encryption of JWT signatures rather than a symmetric one in which a private (SECRET) has to be shared between the token creator server and the token verifier server (if they are separate).
- on a user logout, the JWT token doesn't expire automatically immediately. We need to impl JWT forced expiration logic in the application such that it does and its not easy since JWT tokens are not traceable by the server.

**References**:
- https://roadmap.sh/guides/jwt-authentication
- JWT - ByteByteGo - [YouTube](https://youtu.be/P2CPd9ynFLg)

### OAuth 2.0
Used to get a token from a third party server in order to access its resources.

Our app sends a request to the **authorization server** (often the same as **resource server**) and it decides whether to give access to the requested resources and sends a token back if access is granted. This token can be a JWT Bearer token.

Ex - using Google account to sign-in to GitHub - GitHub triggers Google sign-in page and Google authenticates the user (on sign-in) and then asks if we want to share info with GitHub, if we allow we get a token from Google that GitHub uses to talk to Google in order to access user info.

In the above example, we have used OAuth to authenticate user for GitHub, but beneath the surface OAuth is always about Authorization. We have authorized GitHub to use our info from Google.

Four types of authorization flows (aka **grant types**) for generating a token:
1. **Authorization code grant flow**: app gets back authorization_code from auth server. Have to make another request to auth server for token.
2. **Implicit grant flow**: app gets back token from auth server instead of an authorization_code, so a separate request is not required. (also no refresh tokens)
3. **Password grant flow**: app sends token request alongwith sign-in credentials to the auth server
4. **Client credential grant flow**: no user interaction (sign-in), app directly requests a token (with client ID and secret), and gets a token back from auth_server

The token we get back has an expiry date-time and accompanied by a refresh token that we use to refresh the main access token when it expires. We simply send the refresh token to auth server and get a new access token back.


[Reference](https://roadmap.sh/guides/oauth)

## References
- [API authentication and authorization](https://idratherbewriting.com/learnapidoc/docapis_more_about_authorization.html)
- [roadmap.sh guides](https://roadmap.sh/guides)
- [Authentication - OpenAPI Guide](https://swagger.io/docs/specification/authentication/)
- [HTTP Authentication - MDN Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication)
- [OAuth 2.0 Simplified](https://aaronparecki.com/oauth-2-simplified/)
- [Diagrams And Movies Of All The OAuth 2.0 Flows - Medium](https://darutk.medium.com/diagrams-and-movies-of-all-the-oauth-2-0-flows-194f3c3ade85)