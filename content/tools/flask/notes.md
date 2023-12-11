+++
title = "Flask"
date =  2020-11-26T21:35:21+05:30
weight = 1
+++

## Setup

1. Create a virtual environment
```bash
$ python -m venv path/to/new/venv_folder

#OR

$ py -m venv path/to/new/venv_folder
```

2. Activate the virtual environment
```bash
$ cd venv_folder/Scripts
$ activate.bat
```

3. Come back to flask app root dir
```bash
$ cd ..
$ cd ..
$ pwd	#my_flask_app
```

4. Install Flask
```bash
$ pip install flask
```

## Flask
### Basic App Module Structure
```python
from flask import Flask

app = Flask(__name__)

#app routes go here

#main is optional
# if __name__ == '__main__':
# 	app.run()
```

### Two ways to run Flask apps
```bash
#One
$ python app.py
$ py app.py

#Two - by default, it works only when file is named "app.py"
$ flask run

#otherwise set env variable, use "set" on Windows instead of "export"
$ export FLASK_APP=main.py 

#we can also enable debug mode like this
$ export FLASK_DEBUG=1
```

### Optional \_\_main\_\_
```python
# Syntax: app.run(host, port, debug, options)  
app.run('127.0.0.5', '4567', debug=True)

#or

app.run(port=4567)
```

### App Routing
```python
@app.route('path/that/triggers/the/method')
def foobar():
	pass
```

```python
#we can have multiple routes for single method
@app.route('/')
@app.route('home')
def index():
	return 'Homepage'
```
#### Point to Note
```python
@app.route('/path/')
#is different from
@app.route('/path')

'''
The former is like a directory path, it will fetch and open path for us in both '/path/' and '/path' scenarios..
while latter is more like a file path, if we go to 'localhost:5000/path/', it will fail to find the correct one and give 404 error
'''
```
		
#### Dynamic Parameters in URL
```python
#we can also have dynamic parameters in url
@app.route('/<name>')
def index(name):
	return 'Welcome, ' + name	
```

```python
#we can enforce strict typing too, 'str' works with all types but 'int' won't take in strings, as expected
@app.route('/<int:age>')
def index(age):
	return f'You are {age}'

'''
string: default
int: used to convert the string to the integer
float: used to convert the string to the float.
path: It can accept the slashes given in the URL.
'''
```

```python
#we can create url rule/route/trigger for an existing method using "add_url_rule()"
# Syntax: add_url_rule(<url rule>, <endpoint>, <view function>)
add_url_rule('/new_home', 'home2', index)    
```
### Redirection
```python
#vars are optional
redirect(url_for('another_method_name', var=1, ...))
```

### HTTP Methods
```python
# Default method is GET

# Specifying expected methods in approute
@app.route('/path', methods=['GET','POST'])

# Check method with which function was called
if request.method == 'POST': pass

# Data retrieval with POST
var = request.form['data']

# Data retrieval with GET
var = request.args.get('data') 
```

### Configuration (config)
```python
#config is an in-built dictionary in Flask, we set values in it
app.config['DEBUG'] = True
```

### Sessions
```python
# Keeps data persistent throughout webpages
# Implemented in Flask using just a simple dictionary
from flask import session
# Set secret_key
app.secret_key = 'anything'
# alternate way --> app.config['SECRET_KEY'] = 'anything'

# Add value
session['name'] = 'Abhishek'

# Check if the value is in session
if 'name' in session: pass

# Close session
session.pop('name', None)
```

### Cookies
```python
# We always set them on the response objects and send them to store on client side in a txt form,
# contrary to session which is sever side storage

# Make response object
resObj = make_response(<h1> Cookie is set in browser! </h1>)

# Set cookies on it
resObj.set_cookie('name', 'Abhishek')

# Access cookies wherever needed
request.cookies.get('name')
```

## Jinja Templating
- Templates goes into `app-folder/templates/`
- Static files like CSS and JS files go into `app-folder/static/`
```python
render_template('login.html', user=user)
#vars are optional
```

```html
<h3> Username is: {{user}} </h3>
```

```html
{{ }} for variables & expressions

{%  %} for blocks, if-else, loops
{% end--- %}
```

### Static Files
```html
<img src="{{ url_for('static', filename='images/mylogo.png') }}">
<link rel="spreadsheet" src="{{ url_for('static', filename='css/main.css') }}">
```

### Template Inheritence
```html
<!-- base.html -->
<!DOCTYPE html>
<html>
<head>
	<title>{% block title %}{% endblock %}</title>
</head>
<body>
	{% block title %}{% endblock %}	
</body>
</html>
```

`{% block title %} {% endblock %}` acts as a placeholder

```html
{% extends 'base.html' %}

{% block title %} Homepage {% endblock %}	

{% block title %} <h2> This is page body. </h2> {% endblock %}	
```
By default, if we have anything in `base.html`'s body block, it will be overwritten completely. To retain it, use `super()` in child's block.

```html
{% block title %} 
{% super() %}
<h2> This is page body. </h2> 
{% endblock %}	
```
#### Including content from another webpage

```html
{% include 'another.html' %}
```
{{% notice info %}}
This is two way though, we can now access variables available on our page on `another.html` too.
{{% /notice %}}

## Flask Bootstrap
[Official Guide](https://pythonhosted.org/Flask-Bootstrap/basic-usage.html)

```sh
$ pip install flask-bootstrap
```

```python
from flask import Flask
from flask_bootstrap import Bootstrap

app = Flask(__name__)
Bootstrap(app)

# further code...
```

## Database
#### sqlite setup
```bash
>>> sqlite3 data.db
>>> create table users(id integer primary key autoincrement, name text, location text);
>>> .tables
users
#insert into ...
```

Shortcut:
```bash
>>> sqlite3 < schema	#schema is a simple text file containing our create table command(s)
```

Or use a python script
```python
import sqlite3  
con = sqlite3.connect("employee.db")  
#print("Database opened successfully")  
con.execute("create table Employees (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, email TEXT UNIQUE NOT NULL, address TEXT NOT NULL)")  
#print("Table created successfully")  
con.close()  
```

```python
# Standard Helper Procedures
from flask import g
import sqlite3
def connect_db():
    sql = sqlite3.connect('/path/to/data.db')
    sql.row_factory = sqlite3.Row
    return sql

def get_db():
    if not hasattr(g, 'sqlite_db'):
        g.sqlite_db = connect_db()
    return g.sqlite_db


# Below goes in the manifest file
@app.teardown_appcontext
def close_db(error):
    if hasattr(g, 'sqlite_db'):
        g.sqlite_db.close()


# Querying and commiting
db = get_db()
result = db.execute('SELECT ? FROM Employee', (name,))	#second argument is either a tuple or a list        
db.commit()
full_output = result.fetchall()
#single_row = result.fetchone()
#db.rollback()
```

### Best security practices
```python
# Use turly random string as secret key for sessions
import os

app.config['SECRET_KEY'] = os.urandom(24)	#generates random string
```

```python
# Always hash passwords before storing them in the database
from werkzeug.security import generate_password_hash, check_password_hash
# generate_password_hash(request.form['password'], method='sha256')
# check_password_hash(request.form['password'], query_result['password']) 
```










