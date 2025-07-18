+++
title = "Basics"
date = 2022-02-01T11:44:05+05:30
weight = 1
+++

### Variables and Types
- variable initialization using: `=`, `()`, and `{}`
```cpp
int a = 4;
int a(4);
int a{4};
```
- declaring types
```cpp
int a;
auto b = a; 
decltype(b) c;
// all a, b, and c are int

```cpp
// auto can be used as return type too
auto sum(int a, long b){ 
	return a+b;
}

// decltype can be used on expressions too
decltype(x + y) z;	
```
- data ranges wrap around in some cases: 
```cpp
// signed (wraps around to INT_MIN i.e. -32768)
for(short i = 32765; i < 32777; i++){ }		// infinite loop; max is 32767 (2^15 - 1)

// unsigned (wraps around to 0)
for(unsigned short i = 65534; i < 65537; i++){ }	// infinite loop; max is 65535 (2^16 - 1)

// Integer Promotion due to + operator; no wrap around
short i = 32767;
cout << i + 1;		// 32768
```

- `signed` and `unsigned` encounters are always tricky:
```cpp
sizeof(int) > -1 	//false; as -1 is all 1's (very big number) in 2s complement form and it is converted to unsigned on comparison with sizeof(unsigned type)

unsigned a = 4;
cout << (a > -1);	// false; same reason as above

short i = 32768;	//i = -32768; as we are doing short = int here, int value in short container is -32768 (wrap-around)
```

### Strings

- Raw Strings:
```cpp
R"(this\n is a\t raw string)"

// prints "this\n is a\t raw string"
```

- `string` object
```cpp
#include <string>

string str;
string str = "";	// same as above
str.length();		// 0
str.size();			// same as above

// pitfall; there is no index 0 in an empty string
str[0] = 'a';		// so this statement does nothing! 

// append a char
str += 'b';

// append a string
str += "bc";
str.append("bc");

// convert numbers to string and vice-versa

// using in-built functions
int num = 123;
double pi = 3.14159;
string strNum = to_string(num);   
string strPi = to_string(pi);    

int num = stoi(strNum);
double pi = stod(strPi);

// using stringstream as intermediary
int num = 42;
string strNum;
stringstream ss;
ss << num; 
ss >> strNum; 
cout << strNum; 	// 42 (string)

string strNum = "42";
stringstream ss;
ss << strNum;
ss >> num; 
cout << num; 	// 42 (int)
```

- `stringstream`: treats a string as an I/O stream.
```cpp
#include <sstream>
string name = "Abhi";
string str;

stringstream ss;
// type to stringstream
ss << name;
ss.str(name);	// alt; only if type is string

// stringstream to type
ss >> str;
str = ss.str();		// alt; only if type is string

// alternatively, we can also use stringstream constructor if input is of type string
stringstream(name) >> str;
```

- `endl` vs `"/n"`: endl flushes stream everytime it is encountered hence it's slower

- Both `cin` and `scanf()` leave a `"\n"` in the input buffer that can be read by a subsequent method like `getchar()`. 
**Solution**: use `fflush(stdin)` (C) or `cin.ignore()` (C++) just after `cin` or `scanf()`.
```cpp
// for <streamsize>
#include<ios>

// for numeric_limits
#include<limits>

cin >> a;

// discards the input buffer
cin.ignore(numeric_limits<streamsize>::max(),'\n');
```

- `while (cin >> input)`: `cin` returns false when a non-numeric value is entered; this trick applicable to numeric types only

- Strings: `C-style` or using `string` object
String object also uses c-style strings internally.
```cpp
#include<string>
string str = "Ball";
str[0] = 'C';		// mutable!

str.length() == str.size() //true; both are equivalent
str.substr(begin, end)
str.compare(str1, str2) //lexicographic comparison


// C-style strings
char* str = "Abhi";		//Immutable
char str[] = "Abhi"; 	//Mutable; size = 5 (includes '\0' by default in size)
```

### Arrays
Also called _C-style_, _built-in_, or _raw_ arrays.
```cpp
int arr[] = {1,2,3};

cout << sizeof(arr) / sizeof(arr[0]);		// calc size of array

int arr[3] = {1, 2, 3};		// valid
int arr[5] = {1, 2, 3};		// {1,2,3,0,0}
int arr[2] = {1, 2, 3};		// error: too many initializers for 'int [2]'

arr[99];		// undefined behavior; mostly returns a garbage value
arr[99] = 5;	// undefined behavior; mostly causes seg fault
arr[-2];		// same as above

int arr[5];		// garbage values

int arr[3] = {0};	// quick init all elements to 0

// variable sized arrays are possible and init them is also possible (unlike C), even at runtime
int n = 3;
int arr[n] = {1, 2, 3}; 

// for-each loop works on them (only if array isn't pointer decayed i.e. used as function param)
for(int e : arr){
	cout << e << " ";
}
```

### I/O Formatting
```cpp
#include <iomanip> // for setpricision, setw
cout << num << setprecision(4);		// number of decimal places = 4

// setw(n) : set width for the next I/O operation, resets after each operation

// to read only 3 chars from cin into areaCode we can use:
cin >> setw(3) >> areaCode;
cout << setw(2) << 12345; 	// won't truncate forcefully

#include<iostream>
cout << boolalpha << (4 > 1);  // print bool as true/false rather than numeric/0
```

### Functions
- **Default Arguments**: 
```cpp
// in declaration
int foo(int = 3)

// in definition 
int foo(int a = 3)

// default args must be towards the right in the function signature
int foo(int a = 3, int b) 	// compiler-error

// such functions can then be called by skipping default arguments in the call too (obviously!)
```

- **Function Overloading**: based on parameter (_**TYPE**_ or _**ARITY**_); a function cannot be overloaded only by its return type only. _Name mangling_ happens in background for overloaded funcitons.

- **Function Templating**:
```cpp
template <class T>
T sum(T a, T b){
	return a+b;
}

x = sum(2, 7)
x = sum(2.0, 5.77)
			
// we can use keyword "typename" instead of "class" too in above example

// Non-type templates:	
template <class T, int N>
T fixed_multiply (T val){ return val * N; }
fixed_multiply<int, 2>(10)

// we can't pass variables in second argument of template since the code for this is generated and is hardcoded (as 2) during compile-time itself and during runtime call is made for "val" argument only
```

- *const* parameters and function overloading:
```cpp
// funtions can be overloaded based on "const-ness" of the parameters only if the const parameter is a reference or a pointer

void foo(int a){ }
void foo(const int a) { }		// no overloading; compile-error

void bar(int* p){ }
void bar(const int* p){ }		// allowed
```

- *const* functions:
```cpp
void foobar() const{
	cout<<"Hello";
}

// a const function specifies that it cannot modify any attributes of the object on which they are called
// const objects cannot call non-const functions; consts functions can be called from any object, const and non-const
```

### Namespaces
```cpp 
namespace foobar{
	int foo(){ return 5; }
	int a, b;
	}
int main{
	foobar::a = 2;
	foobar::foo();
```
- **"using"** and **"using namespace"**
```cpp
using foobar::a;		// declaring a single variable in a scope with "using"
using namespace b;		// declaring entire namespce with "using namespace"
// namespace declaration in a block confines it to local scope
```
- **Aliasing**: `namespace new_name = current_name;`

- Declaring namespaces _twice_ willl merge them:
```cpp
namespace a{ int a; }
namespace b{ int b; }
namespace a{ int c; }
```

### Pointers and References
- `nullptr` keyword
```cpp
int* p = nullptr;		//same as 0 or NULL
```
- **References (&)**: aliasing; just like pointers but referencing and dereferencing are implicitly taken care of

- Downcasting of `const` is error in C++ (unlike C): See [here](/c/notes/3/#const-pointers)
```cpp
const int a = 3;
int * p = nullptr;

p = &a;		// error
```

### Dynamic Memory Allocation
- `new`: returns pointer, initializes allocated space with garbage value(s)

```cpp
a = new int;
foo = new (nothrow) int [5];		// won't throw error if fails to allocate; will return a NUll pointer 
delete a;

int *arr = new int[10];
int *p = new int[5] {1, 2, 3, 4, 5};		// init
delete[] arr;
```

### Control Structures
- Range-based _for_ loop (C++11)
```cpp
for (int n : nums) 	//read-only by default
for(int &n: nums) 	//need to use references for mutability
```
### Storage Duration, Scopes, and Linkage
- Scopes in C++:
```txt
- Storage Duration: determines the duration of a variable, i.e., when it is created and when it is destroyed.
					 Automatic (local), Static(global, static, namespace) and Dynamic(new, malloc)
- Scope: Local and Global (determines which parts of the program can reference the variable)

- Linkage: Internal(local, static) and External(extern)

Static storage (global, static, namespace): Initialized to 0, allocated for the whole duration of program
Automatic storage (local): Initialized to garbage value, allocated for the duration of block execution only
```

### Storage Classes and CV-Qualifiers
```cpp
auto 			// meaning changed since C++11
typedef 		// not a storage class in C++
register		// deprecated since C++11

static, extern
mutable 		// used in struct or class to indicate that a data member is modifiable even though the object is declared const 
thread_local

// CV-Qualifiers
const, volatile 
```

### Templates and Generic Programming
Note that the C++ compiler generate a version of the code for each type used in the program, in a process known as "instantiation of template"
- Two types of templating: _function_ and _class_.
1. **Function Templates**
```cpp
// template<typename T> on both declaration and definition
// Multiple types
template<typename T, class U, ...>
T sum(T a, U b){
    cout << "Generic" << "\n" ;
    return a + b;
}

// Function Calling
// 1. Let compiler decide types
sum(2, 7)		// (int, int)
sum(2.0, 6)		// (double, int)

// 2. Explicitly declare types on call
sum<int, int>(2, 7)
sum<double, int>(2.0, 6)
```
- **Function Template Overloading**
	- **Explicit Specialization**:
```cpp
#include <iostream>
using namespace std;

template<typename T>
T sum(T a, T b){
    cout << "Generic" << "\n" ;
    return a + b;
}

template<>
int sum<int>(int a, int b){
    cout << "Specialized" << "\n";
    return a + b;
}

int sum(int a, int b){
    cout << "Normal" << "\n";
    return a + b;
}

int main() {
   cout << sum(2, 7);
}


// Precedence: Normal > Specialized > Generic 
```
2. **Class Templates**:
```cpp
template <typename T>
class Number { 
	//body 
};

// Have to use template on each of method definitions outside of the class.
template <typename T>
T Number<T>::getValue() {
	return value;
}
```
### TODO
- Exception Handling
- OOPS
- Operator Overloading
- Virtual Functions
- Lambdas
- Smart Pointers