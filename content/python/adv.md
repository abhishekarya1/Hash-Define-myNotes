+++
title = "Advanced"
date =  2020-11-25T11:49:03+05:30
weight = 3
+++

```python
'''
Iterable
Iterator

Generator

Closures

Decorator

Property

RegEx

Command-Line Arguments (sys)
'''

# Iterable -> objects that implement __iter__ and __next__.The function range() returns an iterator and for loop performs next() on it automatically.

# Python offers a fundamental abstraction called the Iterable.
# An iterable is an object that can be treated as a sequence.
# The object returned by the range function, is an iterable.

filled_dict = {"one": 1, "two": 2, "three": 3}
our_iterable = filled_dict.keys()
print(our_iterable)  # => dict_keys(['one', 'two', 'three']). This is an object that implements our Iterable interface.

# We can loop over it.
for i in our_iterable:
    print(i)  # Prints one, two, three

# However we cannot address elements by index.
our_iterable[1]  # Raises a TypeError

# An iterable is an object that knows how to create an iterator.
our_iterator = iter(our_iterable)

# Our iterator is an object that can remember the state as we traverse through it.
# We get the next object with "next()". First object too by next() initially.
print(next(our_iterator))  # => "one"

#alternate syntax
print(our_iterator.__next__())	# => "one"

# It maintains state as we iterate.
next(our_iterator)  # => "two"
next(our_iterator)  # => "three"

# After the iterator has returned all of its data, it raises a StopIteration exception
next(our_iterator)  # Raises StopIteration

# We can also loop over it, in fact, "for" does this implicitly!
our_iterator = iter(our_iterable)
for i in our_iterator:
    print(i)  # Prints one, two, three

# You can grab all the elements of an iterable or iterator by calling list() on it.
list(our_iterable)  # => Returns ["one", "two", "three"]
list(our_iterator)  # => Returns [] because state is saved

#We can also create our own iterator using classes that implement __iter__ and __next__
class TopTen:

    def __init__(self):
        self.num = 1

    def __iter__(self):
        return self

    def __next__(self):

        if self.num <= 10:	#always specify end
            val = self.num
            self.num += 1	#increment by 1
            return val
        else:
            raise StopIteration	#raise exception or else None is traversed after 10


values = TopTen()

print(next(values))	# => 1

# print(values.__next__())

for i in values:
    print(i) 
'''
1
2
3
4
5
6
7
8
9
10
'''

# Generators = Functions that create iterators, they create __iter__ and __next__ implicitly
# If a function contains at least one yield statement (it may contain other yield or return statements), it becomes a generator function. Both yield and return will return some value from a function.

# yield = Local variables and theirs states are remembered between successive calls unlike return.
def my_gen():
    n = 1
    print('This is printed first')
    # Generator function contains yield statements
    yield n

    n += 1
    print('This is printed second')
    yield n

    n += 1
    print('This is printed at last')
    yield n

'''
>>> # It returns an object but does not start execution immediately.
>>> a = my_gen()

>>> # We can iterate through the items using next().
>>> next(a)
This is printed first
1
>>> # Once the function yields, the function is paused and the control is transferred to the caller.

>>> # Local variables and theirs states are remembered between successive calls.
>>> next(a)
This is printed second
2

>>> next(a)
This is printed at last
3

>>> # Finally, when the function terminates, StopIteration is raised automatically on further calls.
>>> next(a)
Traceback (most recent call last):
...
StopIteration
>>> next(a)
Traceback (most recent call last):
...
StopIteration
'''

# Closure = The data from the enclosing function gets binded to the inner function and persists even when outer function goes out of scope.
# The criteria that must be met to create closure in Python are summarized in the following points.
# 1. We must have a nested function (function inside a function).
# 2. The nested function must refer to a value defined in the enclosing function.
# 3. The enclosing function must return the nested function.

def print_msg(msg):
    # This is the outer enclosing function

    def printer():
        # This is the nested function
        print(msg)

    return printer  # returns the nested function, not "printer(msg)" call


# Now let's try calling this function.
# Output: Hello
another = print_msg("Hello")	# req. to store in another var, since we return a function
another()

# Decorator = A decorator function takes in a function as argument, adds some functionality and returns it. Uses closures ofcourse.

# @ symbol to specify decorators, syntactic sugar
@make_pretty	
def ordinary():
    print("I am ordinary")

# above is equivalent to
def ordinary():
    print("I am ordinary")
ordinary = make_pretty(ordinary)


# Property

# RegEx (Regular Expressions)
# https://www.programiz.com/python-programming/regex



# Command-Line Arguments
argv       # If 'import sys.argv' used
sys.argv   # If sys imported as 'import sys'

# $python num.py 9 8 7

sys.argv[0] # num.py
sys.argv[1] # 9
sys.argv[2] # 8
sys.argv[3] # 7



```
