+++
title = "STL"
date = 2022-02-01T15:10:19+05:30
weight = 3
+++

## STL Intro

```cpp
// STL is provided in the following headers:

// Containers data structures template classes
<array>, <vector>, <list> (DLL), <deque>, <queue>, <stack>, <map>, <set>, <bitset>, <unordered_map>, <unordered_set>, <forward_list> (SLL)

// Iterator for transversing the elements in a container
<iterator>

// Algorithm and function objects
<algorithm>, <numeric>, <functional>, <utility>

<initializer_list>, <memory>
```

## Array
Fixed-sized array.
```cpp
#include<array>

array<int, 5> a = {1, 2, 3, 4, 5};		//need to specify size at compile time

a.fill(2);		// {2, 2, 2, 2, 2}

a.front();
a.back();

a.size();
a.max_size();

a[0];
a.at(0);

a.empty();
```

## Pair
Stores two values together.
```cpp
#include <utility>  // included by default with other headers

pair<int, int> p = {1, 3};

// pair<int, int> p {1, 3};
// pair<int, int> p (1, 3);
// pair<int, int> p(p1);

// prints 1 3
cout << p.first << " " << p.second;

pair<int, pair<int, int>> p = {1, {3, 4}};

// prints 1 4 3
cout << p.first << " " << p.second.second << " " << p.second.first;

pair<int, int> arr[] = { {1, 2}, {2, 5}, {5, 1}};

// Prints 5
cout << arr[1].second;

// make_pair function; helful in some situations
int a = 5;
pair<int, int> pp = make_pair(a, 6);

// Unpacking Pairs
auto [x, y] = p;  	// Structured binding (C++17)

// Comparison among pairs
// To compare two pairs, first element is compared and if they're equaL that tie is broken using second element
```

### Tuple
Stores `N` values together.
```cpp
#include <tuple>

// Creating a tuple
tuple<int, double, string> myTuple(42, 3.14, "Hello");

// Using make_tuple function
auto myTuple = make_tuple(10, 3.14, "Hello") 

// Accessing elements using std::get
cout << get<0>(myTuple);
cout << get<1>(myTuple);
cout << get<2>(myTuple);

// Modifying a tuple element
get<2>(myTuple) = "World";
cout << "Modified third element: " << get<2>(myTuple);

// Using std::tie to unpack a tuple (old way)
int a;
double b;
string c;
tie(a, b, c) = myTuple; 	// unpacking
cout << "Unpacked values: " << a << ", " << b << ", " << c;

// Unpacking with Structured Binding
auto [x, y] = p;  	// Structured binding (C++17)

// Using std::tuple_size to get the number of elements
cout << "Tuple size: " << tuple_size<decltype(myTuple)>::value;
```

## Vector
Dynamically sized array.
```cpp
#include<vector>

vector<int> v = {1, 2, 3};

// vector<int> v {1, 2, 3}

// Caution: below doesn't work since () are required for special use in vector
// vector<int> (1, 2, 3);

vector<int> v(5, 100); // {100, 100, 100, 100, 100}
vector<int> v(5); 	   // {0, 0, 0, 0, 0}, compiler-dependent
vector<int> v(v1);


// Take the vector to be {10, 20, 30, 40}
vector<int>::iterator it = v.begin();

it++;
cout << *(it) << " "; // prints 20

it = it + 2;
cout << *(it) << " "; // prints 30, inderection using *

vector<int>::iterator it = v.end();
vector<int>::iterator it = v.rend();
vector<int>::iterator it = v.rbegin();

// NOTE: begin() points to memory address before 10 and end() points to address after 40
//		 rbegin() points to address after 40, rend() points to address before 10


// Accessing 
v[0]		// first element; no bound-checking, undefined behavior on out of bound access
v.at(0)		// bound-checked; throws error if index is out of bounds
g1.front()

v.back() 	// last element

v.size() 	// size


// Ways to print the vector

for (vector<int>::iterator it = v.begin(); it != v.end(); it++) {
	cout << *(it) << " ";
}

for (auto it = v.begin(); it != v.end(); it++) {
	cout << *(it) << " ";
}

for (auto it : v) {
	cout << it << " ";
}


// Deletion; notice that we can delete at the front but not insert in vectors
v.erase(v.begin())					//erases v[0]
v.erase(v.begin()+3) 				//erases v[3]
v.erase(v.begin()+1, v.begin()+3)	//range erase, won't delete last element in rage; include-exclude range


// Insertion
v.push_back({1, 2});	// inserts at right hand side
v.emplace_back(1, 2);	// same as push_back

vector<int>v(2, 100); 			// {100, 100}
v.insert(v.begin(), 300); 		// {300, 100, 100};
v.insert(v.begin() + 1, 2, 10); // {300, 10, 10, 100, 100}
		(start, count, element)

vector<int> copy(2, 50); 						// {50, 50}
v.insert(v.begin(), copy.begin(), copy.end()); // {50, 50, 300, 10, 10, 100, 100}
		(start, start_other, end_other)


//{10, 20}
v.pop_back(); // {10}

// v1 -> {10, 20}
// v2 -> {30, 40}
v1.swap(v2); // v1 -> {30, 40} , v2 -> {10, 20}

v.clear(); // erases the entire vector

cout << v.empty();		// true	
```

## List
Doubly linked list, mostly the same as a vector but we can push elements at the front with built-in method `push_front` unlike vector. Also non-contiguous memory allocation.
```cpp
#include<list>

list<int> ls;

ls.push_back(2); 		// {2}
ls.emplace_back(4); 	// {2, 4}

ls.push_front(5); 		// {5, 2, 4};
ls.emplace_front(6); 	// {6, 5, 2, 4}


ls.reverse();	// {4, 2, 5, 6}

ls.sort();		// {2, 4, 5, 6}

// rest functions same as vector
// begin, end, rbegin, rend, clear, insert, size, swap
```

## Deque
Double ended queue
```cpp
#include<deque>

deque<int> dq;
dq.push_back(1); 	// {1}
dq.emplace_back(2); // {1, 2}
	
dq.push_front(4); 	 // {4, 1, 2}
dq.emplace_front(3); // {3, 4, 1, 2}

dq.pop_back(); 		// {3, 4, 1}
dq.pop_front(); 	// {4, 1}

dq.back(); 
dq.front();

// rest functions same as vector
// begin, end, rbegin, rend, clear, insert, size, swap
```

## Stack
LIFO 
```cpp
#include<stack>

// can't initialize stacks
stack<int> st;

st.push(1); 	// {1}
st.push(2); 	// {2, 1}
st.push(3); 	// {3, 2, 1}
st.push(3);		// {3, 3, 2, 1}
st.emplace(5); 	// {5, 3, 3, 2, 1}

cout << st.top(); // prints 5  "** st[2] is invalid **"

st.pop(); 		// st looks like {3, 3, 2, 1}

cout << st.top(); // 3

cout << st.size(); // 4

cout << st.empty();

stack<int>st1, st2;
st1.swap(st2);
```

## Queue
FIFO
```cpp
#include<queue>

queue<int> q;
q.push(1); 		// {1}
q.push(2); 		// {1, 2}
q.emplace(4); 	// {1, 2, 4}

q.back() += 5

cout << q.back(); // prints 9

// Q is {1, 2, 9}
cout << q.front(); 	// prints 1

q.pop(); // {2, 9}

cout << q.front(); 	// prints 2

// size(), swap(), and empty() are same as stack
```

## Priority Queue
Min/Max Heap
```cpp
#include<queue>

// default is Max Heap
priority_queue<int> pq;

pq.push(5); 	// {5}
pq.push(2); 	// {5, 2}
pq.push(8); 	// {8, 5, 2}
pq.emplace(10); // {10, 8, 5, 2}

cout << pq.top(); 	// prints 10

pq.pop(); 	// {8, 5, 2}

cout << pq.top(); 	// prints 8

// size swap empty function same as others

// Minimum Heap
priority_queue<int, vector<int>, greater<int>> pq;
pq.push(5); 	// {5}
pq.push(2); 	// {2, 5}
pq.push(8); 	// {2, 5, 8}
pq.emplace(10); // {2, 5, 8, 10}

cout << pq.top(); 	// prints 2
```

## Map
Stores unique key-value pairs only. `O(log n)` average operations. Uses Red-Black Tree (Self-Balancing BST) internally which has max height as `log n`.
```cpp
// {key, value}
map<int, int> mpp;

// map<int, pair<int, int>> mpp;
// map< pair<int, int>, int> mpp;

// key values can be anything

mpp[1] = 2;			// mpp[key] = value
mpp.emplace({3, 1});
mpp.insert({2, 4});

mpp[{2,3}] = 10; 	

/* Map stores in sorted order just like Set
{
	{1, 2}
	{2, 4}
	{3, 1}
}
*/

for(auto it : mpp) {
	cout << it.first << " " << it.second << endl; 
}

// same options for using iterators
// as we did in vector for the insert function


cout << mpp[1]; // prints 2
cout << mpp[5]; // prints 0, since it does not exists


auto it = mpp.find(3); // points to the position where 3 is found
cout << *(it).second; 

auto it = mpp.find(5); // points to the mpp.end() since 5 not there

// lower_bound and upper_bound works exactly in the 
// same way as explained in the other video 
    
// This is the syntax
auto it = mpp.lower_bound(2); 

auto it = mpp.upper_bound(3); 

// erase, swap, size, empty, are same as above
```

### Multimap
```cpp
#include<map>

// everything same as map, only it can store multiple keys
// only mpp[key] cannot be used here 
```

### Unordered Map
No guaranteed ordering but `O(1)` average operations. Uses Hash Table internally.
```cpp
#include<unordered_map>

// same as set and unordered_set
```


## Set
```cpp
#include<set>

set<int> st;

st.insert(1); 	// {1}
st.emplace(2); 	// {1, 2}
st.insert(2); 	// {1, 2}
st.insert(4); 	// {1, 2, 4}
st.insert(3); 	// {1, 2, 3, 4}

// Always rearrages in ascending order

// begin(), end(), rbegin(), rend(), size(),
// empty() and swap() are same as those of above

// {1, 2, 3, 4, 5}
auto it = st.find(3);	// returns an address

// {1, 2, 3, 4, 5}
auto it = st.find(6);	// will return st.end() if element is never found in st

// {1, 4, 5}
st.erase(5); // erases 5 // takes logarithmic time


int cnt = st.count(1); 	// for sets it will either be 0 or 1


auto it = st.find(3);
st.erase(it); // it takes constant time

// {1, 2, 3, 4, 5}
auto it1 = st.find(2);
auto it2 = st.find(4);
st.erase(it1, it2); 	// after erase {1, 4, 5} [first, last)

// lower_bound() and upper_bound() function works in the same way
// as in vector it does.

// This is the syntax
auto it = st.lower_bound(2); 

auto it = st.upper_bound(3); 
``` 

### Multiset
```cpp
#include<set>

// Everything is same as set
// only stores duplicate elements also

multiset<int> ms;
ms.insert(1); 	// {1}
ms.insert(1); 	// {1, 1}
ms.insert(1); 	// {1, 1, 1}

ms.erase(1); 	// all 1's erased

int cnt = ms.count(1); 

// only a single one erased
ms.erase(ms.find(1));

ms.erase(ms.find(1), ms.find(1)+2);

// rest all function same as set
```

### Unordered Set
```cpp
#include<unordered_set>
unordered_set<int> st;

// lower_bound and upper_bound function
// does not work, rest all functions are same
// as above, it does not stores in any
// particular order it has a better complexity
// than set in most cases, except some when collision happens
```

### BitSet
Sequence of `0` and `1`.

```cpp
bitset<8> myBits; 	// nit to 00000000

myBits[1] = 1;        // Set the 2nd bit (index 1) to 1 
myBits.set(3);         // Set the 4th bit (index 3) to 1
myBits[0] = myBits[1]; // Copy the value of the 2nd bit to the 1st

cout << myBits; 	// 00010010

cout << "Bit at index 3: " << myBits[3]; 		//  1
cout << "Bit at index 5: " << myBits.test(5); 	//  0

myBits.reset(1);    // Set the 2nd bit to 0
myBits.flip(0);     // Toggle the 1st bit 
cout << myBits; 	// 00010001
```

## Algorithms & Misc
- create `set` from `vector`
```cpp
vector<int> nums = {1, 2, 2, 3};

set<int> mySet(nums.begin(), nums.end());

cout << mySet.size();	// 3
```

- sorting with `sort`
```cpp
#include<algorithm>

sort(a, a+n); 	// [first, last)
sort(a.begin(), a.begin()+5); // using iterators
sort(a+2, a+5); // sort in range

// desc
sort(a, a+n, greater<int>);

// custom sort
pair<int,int> a[] = {{1,2}, {2, 1}, {4, 1}}; 

// sort it according to second element 
// if second element is same, then sort 
// it according to first element but in descending 

// {4,1}, {2, 1}, {1, 2}}; 
sort(a, a+n, comp)

bool comp(pair<int,int>p1, pair<int,int>p2) {
	if(p1.second < p2.second) {
		return true; 
	} else if(p1.second == p2.second){
		if(p1.first>p2.second) return true; 
	}
	return false; 
}
```

- search with `binary_search`
```cpp
// Binary Search only works on sorted array
vector<int> sorted = {1, 3, 5, 7, 9};
bool found = binary_search(sorted.begin(), sorted.end(), 5); 	// true 
```

- lower bound and upper bound
```cpp
// needs sorted input
vector<int> v = {10, 20, 30, 40, 50};
cout << *lower_bound(v.begin(), v.end(), 35);	// 40
cout << *upper_bound(v.begin(), v.end(), 35);	// 40
```

- min/max, reverse, accumulate, count, find
```cpp
int maxi = *max_element(a, a+n);
int mini = *min_element(a, a+n);

int maxi = *max_element(v.begin(), v.end());
int mini = *min_element(v.begin(), v.end());

// reverse() (in place reversal)
reverse(arr, arr+n);
reverse(v.begin(), v.end());

long sum = accumulate(v.begin(), v.end(), 0); 	// 0 is initial sum
int cnt = count(v.begin(), v.end(), 2);			// 2 is element to search in vector
auto it = find(v.begin(), v.end(), 2);	// return address

min(1, 3);
min({1, 3, 0, -2});		// multiple values

max(1, 3);
max({1, 3, 0, -2});
```

- `for_each` on containers
```cpp
vector<int> nums = {10, 20, 30, 40, 50};
for_each(nums.begin(), nums.end(), [](int value) {
	cout << "Value: " << value;
});
```

- Counting set bits in binary representation (GCC compilers only)
```cpp
int num = 7; 	// 111 
int cnt = __builtin_popcount(num);		// 3 

// for very large numbers
long long num = 165786578687;
int cnt = __builtin_popcountll(num);
```

- math; most functions have `double` type as args and return type
```cpp
double x = sqrt(16.0);		// 4.0
int y = abs(-10);			// 10
double z = pow(2.0, 2.0); 	// 4.0
``` 

## Lambda Expressions
```cpp
// Syntax
[capture_clause](arg1, arg2) { /*body*/ }

// Definition and call together
cout << [](int a, int b){ return a+b; }(2, 4);		// 6

// use capture_clause to define what variables can the lambda access and how 
// we can pass this as comparator in sort(arr, arr+n, [](arg1, arg2) { })
```

### Some commonly used boolean lambdas
```cpp
all_of(v.begin(), v.end(), lambda);		// returns true if ALL elements in range satisfy lambda
any_of(v.begin(), v.end(), lambda); 	// returns true if ATLEAST ONE elements in range satisfy lambda
none_of(v.begin(), v.end(), lambda);	// returns true if NONE of the elements in range satisfy lambda
```

## References
- [takeUforward - YouTube](https://www.youtube.com/watch?v=zBhVZzi5RdU)
- [C++ STL - GfG](https://www.geeksforgeeks.org/the-c-standard-template-library-stl/)
- [Luv - YouTube](https://www.youtube.com/playlist?list=PLauivoElc3gh3RCiQA82MDI-gJfXQQVnn)
- https://medium.com/@himanshusingh2719/c-stl-essentials-for-leetcode-2b9d97307feb#1c29