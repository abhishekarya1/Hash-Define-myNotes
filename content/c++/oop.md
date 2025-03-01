+++
title = "OOP"
date = 2022-02-01T12:49:49+05:30
weight = 2
+++

### OOP
Use ; to terminate class definition
Declaring method indside class body and defining it outside using ::
Creating object: 	 Foobar fb;   //default constructor called
									 Foobar fb(2, 3); //parameterized constructor called (if any)
									 Foobar fb(); //won't work as its interpreted as function call to fb() by compiler
									 Foobar fb{}; //default constructor called

struct vs classes: struct have public access by default,  and classes have private access by default

this -> and not this. since "this" stores address of class (its a pointer)

Use Destructor to deallocate memory and cleanup:
									 ~MyClass() { }

Copy Constructor: create a new object by passing an existing object as parameter
									Foobar fb2(fb1);
									// pass-by-value of an object invokes copy constructor; creates a shallow copy for dynamically allocated members
Copy Assignment Operator (=):  same class objects can be assigned with =. Ex: obj_new = obj_old

Trick: Circle c8 = c6;  // Invoke the copy constructor, NOT copy assignment operator
                 		// Same as Circle c8(c6)


Topics skipped for now: Friendship & inheritance, Polymorphism & Virtual Functions, Operator Overloading, const & static members/functions, Move Constructor
https://personal.ntu.edu.sg/ehchua/programming/cpp/cp6_Inheritance.html
https://personal.ntu.edu.sg/ehchua/programming/cpp/cp7_OperatorOverloading.html
https://www.cplusplus.com/doc/tutorial/classes2/
