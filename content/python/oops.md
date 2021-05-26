+++
title = "OOP"
date =  2020-11-24T15:16:54+05:30
weight = 2
+++

```python
'''
Class
Object/Instance

Object/Instance Variable
Class Attribute/Data member (Static variable)

Instance Methods 
Class Methods (@classmethod)
Static Methods (@staticmethod)
Abstract Methods (a way)

Constructor 	(__init__)
Destructor		(__del__)

@property
@attribute_name.setter
@attribute_name.deleter

Instance
Instantiation

self -> instance reference
cls -> class reference
super() -> parent class reference

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

# Changing values of class attribute
class Fun:
    name = 'Arya'

foo = Fun()
print(foo.name)		# "Arya"
bar = Fun()
Fun.name = 'Abhi'	# shared variable modified here
print(bar.name)		# "Abhi"

# Class Methods
class A:
	@classmethod	# required to access via A.foobar()
	def foobar(cls):	#can also use self insted of cls, it has first parameter as classname implicitly unlike staticmethods which have no object params
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

# Abstract methods can be implemented like so
class Pizza(object):
    def get_radius(self):
        raise NotImplementedError

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
Method Resolution Order(MRO) [Left --> Right]
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


# Advanced OOPS
'''
Name Mangling: if we have double underscore as prefix to a identifier name in a class then
it is implicitly converted by the interpreter as "_Classname__name".
So if we make a method name as "__name", no one will be able to call it with that name. but they can with "_Classname__name"
Link: https://www.geeksforgeeks.org/name-mangling-in-python/
'''

class Student:
    def __init__(self, name):
        self.__name = name
  
    def displayName(self):
        print(self.__name)
  
s1 = Student("foobar")
s1.displayName()
  
# Raises an error
print(s1.__name)


# Printing Objects
'''
__str__
__repr__

Add these to the class to make objects printable, both return a String literal.
'''

class Test:
    def __init__(self, a, b):
        self.a = a
        self.b = b
  
    def __repr__(self):
        return f"Test a: {self.a} b: {self.b}"
  
    def __str__(self):
        return f"From str method of Test: a is {self.a}, b is {self.b}"

t = Test(123, 567)
print(t) # This calls __str__(), if no __str__ is present then print(t) uses __repr__
print([t]) # This calls __repr__()   

'''Output:
From str method of Test: a is 123, b is 567
[Test a: 123 b: 567]
'''

# User-defined Exception Class
'''
Derived from "Exception" class.
'''
class MyExcp(Exception):
	def __init__(self, value):
		self.value = value
	def __str__(self):
		return f"Exception with value {self.value} has occured."

try: 
	raise MyExcp(4)

except MyExcp as e: 
	print(e)

#Output: "Exception with value 4 has occured.""			

```

