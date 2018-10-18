---
title: STL - Vectors and Generic Programming
date: 2018-06-18
---
### Vectors
They are data structures in C++ just like arrays but they have size that is capped only by the amount of space we can possibly allocate.

- Header files:
```
#include<vector>
```
- Declaration:
```
vector<int> v;    // vector<data_type> name;
```
As Function Parameter Passed by Reference:
```
int func(int n, vector<int> &v)  {    }
```

#### Built in Functions
- **v.push_back(x)** - Pushes the element(x) inside the vector.
- **v.pop_back(x)** - Pops the element(x) from the vector.
- **v.reserve(100)** - Reserves a vector space of 100.
- **v.size()** - Returns size of the vector.

For more functions, refer [here](http://www.cplusplus.com/reference/vector/vector/).

### Generic Programming in C++

- **Placeholders** in templates get replaced by a data type.

#### Generic Data Types and  Function Templates

To declare a generic data type.
```
template<typename T> or template<class T>
```

- Usage:

```
#include<iostream>

using namespace std;

template <typename T>
T bigger(T a, T b)        // Generic Function with a generic Return Type
{
	if(a > b) return a;
	else return b;
}

int main()
{
	cout << bigger(14.2,7.2);
}

OUTPUT : 14.2
```
- With Multiple Placeholders:

```
#include<iostream>

using namespace std;

template <typename X, typename Y>
Y bigger(X a, Y b)        // Generic Function with a generic Return Type (X)
{
	if(a > b) return a;
	else return b;
}

int main()
{
	cout << bigger(14.2,7);
}

OUTPUT : 14
```

We can also use the below syntax:

```
template<typename T>
class Vector{
	T arr[100];
}

class Me{
	int roll_no;
	char name[10];
}

int main(){
	Vector<int> v1;					// Associating Constructor of Class Vector and type int and Making the whole as another object (v1)

	Vector<Me> v2;					// Associating another class object (type) and making the whole as an object (v2)

	char arr_char[] = {'a','b','c'};
  print<char>(arr_char, 3);

  print<char>(arr_char, 3, compareInt);			// Function call for a specific data type specified by [function_name<data_type>(para,meter,s)]
}
```

Let's see another example -

```
class Elephant{
public:
    int wt;
    char name[20];
};

template<typename T, typename Y >
void print(T arr[], int n, Y printCriteria){			// Y is a function type
    for(int i = 0; i < n; ++i){
        printCriteria(arr[i]);										// printMyElephant(arr[i])
    }
    cout << endl;
}

void printMyElephant(Elephant E){
    cout << E.wt << " " << E.name << endl;
}

int main(){
		Elephant E[] = {									// Array of objects
        {1600, "Hachi"},
        {1500, "Rocky"},
        {1000, "Jumbo"}
    };

print(E, 3, printMyElephant);		// Passed whole function
}
```
In the above example we created a function for comparing Elephants. Since our compiler didn't know how to print Elephants, we passed that function to our generic function to print any values adding another parameter for it and the value in `print()` got bounded during compile-time to `printMyElephant()` that we passed in our call.

#### Class Templates
Since we can also pass into out Generic type the objects of class.
We have to be careful as the algorithms that work flawlessly for data types might not work for an object.
Ex - How do you compare two objects? What is the result of this? - `Car c > Pen p;`.

We need to build a Generic system that frees our algorithm from implementation and truly make us achieve generic nature across all types.

```
class VectorInt{
    int arr[100];
};

class VectorChar{
    char arr[100];
};

template <typename T>
class Vector{            // Generic Class
    T arr[100];         // Array has elements of type T
};

class Elephant{
    int wt;
    char name[100];
};


int main(){
    // VectorInt vint;   // container of ints (object)
    // VectorChar vchar;   // container of chars (object)

    Vector<int> v1;
    Vector<char> v2;   
    Vector<Elephant> v3;      // Vector containing Elephant data type
}
```
More [here](https://medium.com/coding-blocks/generic-programming-in-c-a-conceptual-overview-446f1ee89287).
