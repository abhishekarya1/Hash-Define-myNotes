+++
title = "gRPC, SOAP, GraphQL"
date = 2021-05-19T21:15:22+05:30
weight = 3
+++

## RPC
Another paradigm for creating web APIs is Remote Procedure Call (RPC).

A procedure call but here we call a method on a remote server.

```java
// a Java method
String getName(long id){
	return "John Doe";
}

// method call
getName(1234);		// "John Doe"
```

The equivalent as an RPC is:

Request: 
```foobar
GET /getName HTTP/1.1
HOST: api.example.com
Content-Type: application/json

{"id": "1234"}
```
Response: 
```foobar
HTTP/1.1 200 OK
{ "name": "John Doe" }
```

In the above example, we've sent the data as JSON so it is a [JSON-RPC](https://en.wikipedia.org/wiki/JSON-RPC). We can also send the data as [XML](https://en.wikipedia.org/wiki/XML-RPC) fields, or standardized enveloped XML message as in [SOAP](https://en.wikipedia.org/wiki/SOAP) protocol.

Ethereum uses JSON-RPC.

### RPC vs REST

While REST is resource-oriented, RPC is action-oriented.

Endpoints in REST are noun based, in RPC they are verb based.

REST expects the server to know "what to do", we can send `POST` or `DELETE` request to the same URI and these HTTP verbs will be used to differentiate what the server does in each case. In RPC, the onus is on the client, it is expected to know what to do and call the appropriate endpoint to achieve that.

RPCs are much faster than REST APIs.

## gRPC
A modern open-source high performance RPC framework created by Google (circa 2016) that uses HTTP/2. It uses its own custom data exchange format called [ProtoBuff](https://developers.google.com/protocol-buffers/) which packs down smaller than JSON after compression.

```go
message Person {
  required string name = 1;
  required int32 id = 2;
  optional string email = 3;
}
```

## SOAP
SOAP is an acronym for Simple Object Access Protocol. It is an **XML-based messaging protocol** for exchanging information among applications which are built with different programming languages. SOAP works over HTTP.

SOAP messages are heavily standardized and it's popularity is dwindling as REST is generally faster.

```xml
POST /InStock HTTP/1.1
Host: www.example.org
Content-Type: application/soap+xml; charset=utf-8
Content-Length: 299
SOAPAction: "http://www.w3.org/2003/05/soap-envelope"

<?xml version="1.0"?>
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:m="http://www.example.org">
  <soap:Header>
  </soap:Header>
  <soap:Body>
    <m:GetStockPrice>
      <m:StockName>T</m:StockName>
    </m:GetStockPrice>
  </soap:Body>
</soap:Envelope>
```

[SOAP - Wikipedia](https://en.wikipedia.org/wiki/SOAP)

## GraphQL
GraphQL is an open-source data query and manipulation language for APIs, and a runtime for fulfilling queries with existing data.

It sits between the client and the server and specifies what all fields to return in the response, and we get only those fields back.

There is only a single endpoint and the call is strikingly similar to a RPC.

Query:
```foobar
{
  employee {
    name
  }
}
```
Result:
```json
{
  "employee": {
    "name": "John Doe"
  }
}
```

Tutorial: [howtographql.com](https://www.howtographql.com/basics/1-graphql-is-the-better-rest/)

## References
- https://apisyouwonthate.com/blog/understanding-rpc-rest-and-graphql
- [SOAP Protocol & SOAP vs. REST](https://stoplight.io/api-types/soap-api/)