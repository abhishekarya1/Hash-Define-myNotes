+++
title = "cURL"
date = 2021-05-22T14:01:25+05:30
weight = 8
+++

## cURL
**C**lient **URL**: A command line library/tool to send data from terminal.

```bash
#Get only body (default method is GET)
curl https://api.yomomma.info

#Get only header
curl -I https://api.yomomma.info

#Get both header and body
curl -i https://api.yomomma.info

#Verbose and more verbose
curl -v https://api.yomomma.info
curl -vv https://api.yomomma.info

#Output to file
curl -o output.txt https://api.yomomma.info
curl -o https://api.yomomma.info -o output.txt

#GET
curl -X GET https://api.yomomma.info

#POST
curl -d '{"id":1,"name":"foobar"}' http://localhost:5000/user
curl -X POST -d '{"id":1,"name":"foobar"}' http://localhost:5000/user

#Input from file
curl -d @output.txt https://api.yomomma.info

#Any other method
curl -X PUT -d ...
curl -X DELETE ...

#Custom Header
curl -X POST -H "Content-Type: application/json" http://example.com
```

## References
- [How to test a REST api from command line with curl](https://www.codepedia.org/ama/how-to-test-a-rest-api-from-command-line-with-curl/)
- [Using Curl to make REST API requests](https://linuxize.com/post/curl-rest-api/)
- [Test a REST API with curl - Baeldung](https://www.baeldung.com/curl-rest)