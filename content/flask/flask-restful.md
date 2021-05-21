+++
title= "Flask-Restful"
date = 2021-05-21T19:16:22+05:30
weight = 2
+++

## Flask-Restful
[Documentation](https://flask-restful.readthedocs.io/en/latest/)

## A minimal API
```py
from flask import Flask
from flask_restful import Api, Resource

app = Flask(__name__)
api = Api(app)

#define a resource
class Users(Resource):
	#define access methods
	def get(self, name):
		return {'name' : name}, 200

api.add_resource(Users, '/users/<string:name>')

app.run()	#not optional here
```

- Flask `app` is created, and `Api` is created from that app 
- API **resources are just classes** which inherit `Resource` class from flask_restful
- endpoints are defined using `add_resource(class, 'url/path')`
- class method names represent HTTP methods that are valid for a resource
- response codes can be sent after `return` as shown above

{{% notice warning %}}
Python methods can return `null` if dictionary key doesn't exists. We may need to return `None` object in that cases otherwise Agent may not recognize the response type and errors will entail.
{{% /notice %}}
