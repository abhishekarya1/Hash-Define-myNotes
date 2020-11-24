+++
title = "OOP"
date =  2020-11-24T15:16:54+05:30
weight = 2
+++

```python
'''
Class
Object

Object Variable
Class Attribute/Data member (Static variable)

Instance Methods
Class Methods
Static Methods

Instance
Instantiation

self -> instance reference
cls -> class reference

Inner Classes
'''

# The need for "self" 
class Car:
	pass

obj = Car()	#Insantiation, Instance = obj
obj.brand = 'Audi'
obj.type = 'Sports'
obj.price = 5000000

print(obj.brand, obj.type, obj.price)	# => Audi Sports 5000000

# We can 'automate' this variable creation using "self" to refer to calling object 
class Car:
	def __init__(self):
		self.brand = 'Audi'
		self.type = 'Sports'
		self.price = 5000000

obj = Car()
print(obj.brand, obj.type, obj.price)	# => Audi Sports 5000000

# First parameter is always the instance of the calling object (i.e. self), it is passed implicitly

# Variables (Class vars and Instance vars)
class Car:
	wheels = 4 	# class variable

	def __init__(self, br):
		self.brand = br #instance variables
		self.year = 1999

	def foobar(self):
		print(self.year)

obj = Car('BMW')			
# Instance Methods = Calling with two visually different but functionally excatly the same syntaxes
obj.foobar() 	# => 1999
Car.foobar(obj)	# => 1999

# Class attribute "wheels" can be accessed by both class name and via object 
print(Car.wheels)	# => 4
print(obj.wheels)	# => 4

# Class Methods
class A:
	@classmethod	# required to access via A.foobar()
	def foobar(cls):	#can also use self insted of cls, it has first parameter as classname implicitly
		print('foobar')

obj = A()
# Can be accessed by both class name and object just like class attributes
A.foobar()	# => foobar
obj.foobar()	#=> foobar

# Static methods
class A:
	@staticmethod	
	def foobar():	#not supposed to have any class or object instance arguments
		print('foobar')

obj = A()
# Can be accessed by both class name and object just like class attributes
A.foobar()	# => foobar
obj.foobar()	#=> foobar

# Inner Classes -> Classes inside other classes
class A:
	name = 'Apple'

	def __init__(self):
		self.objB = self.B()	#can create object of inner class in outer class

	class B:	#inner class
		name = 'Ball'

objA = A()
print(objA.objB.name)	# => Ball

#creating object of B outside A
anotherObjB = A.B()
print(anotherObjB.name)	# => Ball

# Inheritence
'''
Single
Mutli-Level
Multiple

Constructors in Inheritence
Method Resolution Order(MRO) 
'''
"""
Superclass
	|
 Subclass

Subclass can access all vars and methods of super but not vice-versa.
"""
# Single Inheritence
class A:
	pass
class B(A):
	pass

# Multi-level Inheritence
class A:
	pass
class B(A):
	pass
class C(B):
	pass	

# Multiple Inheritence
class A:
	pass
class B:
	pass
class C(A,B):
	pass

# Constructor behaviour in Inheritence -> By default only the calling object's class __init__ is called
class A:
	def __init__(self):
		print('Const of A')
class B(A):
	def __init__(self):
		print('Const of B')

obj = B()	# => Const of B

# If we want to call __init__ of A too, use "super()""
class A:
	def __init__(self):
		print('Const of A')
class B(A):
	def __init__(self):
		super().__init__()	#redirect to const of A first
		print('Const of B')

obj = B()   
'''
Const of A
Const of B
'''

# In multiple inheritence -> we can't use super(), can we? Yes, left to right order is followed, i.e. if 
class C(A, B):
	pass
#then only the constructor of A is called with super() call
#this applies to other class and object methods too and is called Method Resolution Order (MRO)

# Polymorphism - 4 ways in Python 
'''
Duck Typing 
Operator Overloading
Method Overloading
Method Overiding
'''
# Duck Typing -> Can have many diffrent classes and their objects can be passed to functions accessing a common method that all of them have.
class A:
	my_attr = 'Anything'
	
	def foo(self):
		print('foobar')

class B:
	def foo(self):
		print('boofar')

objA = A()
objB = B()

def printMe(obj):	#external method
	obj.foo()

printMe(objA)	# don't care if we are passing any class object as long as it has foo() method 
printMe(objB)


# Operator Overloading -> Customizing(overloading) default built-in operators for performing operations on class objects
# Default operators' built-in actions:
a = 3
b= 4
print(a + b) #int.__add__(a, b)
print(a - b) #int.__sub__(a, b)
print(a * b) #int.__mul__(a, b)
print(a > b) #int.__gt__(a, b)

# Create methods that overload these in class and you can use +, -, *, >, etc..
class A:
	marks = 40
	def __add__(self, any_var):
		return self.marks + any_var.marks
class B:
	marks = 50

objA = A()
objB = B()

print(objA + objB)	# => 90, not an error

# Method Overloading (can't create two functions with same name in same scope in Python)
# Use *vargs or default arguments for this

# Method Overriding
class A:
    def show(self):
        print('A')
class B(A):
    def show(self):
        print('B')        

objB = B() 
objB.show() # => B
#B.show() overrides A.show()      
```