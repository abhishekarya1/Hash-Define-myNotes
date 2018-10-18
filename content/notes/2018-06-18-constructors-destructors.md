---
title: Constructors and Destructors
date: 2018-06-18
---

### Constructors
Every class comes with four hidden functions.
1. Default Constructor
2. Parameterized Constructor
3. Copy Constructors
4. Destructor

### Default Constructors
- They have the same name as the class and do not have any return type.
- They are provided implicitly and they initialise with 0.
```
class me
{
  me()
  {
    // they have nothing inside
  }
}
```
### Parameterized Constructors

If we write something inside and parameterize it, then it is called **parameterized constructor**.

```
class me
{
  public:
  int marks;
  int age;

  me(int m, int a)        // Constructor with parameters
  {
    marks = m;          // Putting in values
    age = a;
  }

  void print()
  {
      cout << marks <<" ";
      cout<< age;
  }
};

int main()
{
  me t(99, 19);         // parameterized constructor call
  t.print();
}
```
### Copy Constructors
It is used to create a copy of given object of the same type.

It exists by default and we don't need to create it explicitly.
```

class me
{
  public:
  int marks;
  int age;

  me()
  {
      // Default Constructor
  }

  me(int m, int a)        // Parameterized Constructor
  {
    marks = m;          // Putting in values
    age = a;
  }

  me(me &x)            // Copy Constructor (parameter is another object from where to copy which is PASSED BY REFERENCE)
  {
    marks = x.marks;
    age = x.age;
  }

  void print()
  {
      cout << marks <<" ";
      cout<< age;
  }
};

int main()
{
  me t(99, 19);         // Parameterized Constructor call
  t.print();

  me m1(t);             // Copy Constructor Call [create object m1 and, copy object t's values in object m1]
  me m1 = t;            // Alternate Call Syntax for Copy Constructor
  m1.print();

}
```
### Shallow Copy and Deep Copy
We don not need to assign the same array memory every time for our need, say, name. We can have `char name[40]` and store names in it, but sometimes names are shorter than 40 and a lot of space is wasted because for every name array is allocated.

**Solution** - We can allocate space to array on demand, dynamically from the Heap.

When pointers are copied from one object to another using Default Copy Constructor the address in the pointer remains the same and changes done to one will be reflected into the others too. This is a **Shallow Copy**.

Hence we need to dynamically allocate new pointers in our new object and copy data manually in our Copy Constructor to avoid this. This is a **DeepCopy**.

```
#define LABEL(x, val) cout << "Updated Value of " << (#x) << " " << (val)\
        << endl

class Person{
    int age;
public:
    char* name;
    Person(int k, const char n[]){
        age = k;
        int len = strlen(n);
        name = new char[len];       // dynamic allocation
        strcpy(name, n);

    }
    void print(){
        cout << name << ":" << age << endl;
    }

};
int main(){
       Person P1(20, "Johnny");
       P1.print();            // Johnny : 20

       Person P2 = P1;      // Person P2(P1);       P2.initialiseWith(P1)
       P2.print();            //Johnny : 20

       P2.name[0] = 'T';
       LABEL(P2, P2.name);      // Tohnny
       LABEL(P1, P1.name);      // Tohnny         // Shallow Copy
}
```
Shallow Copy happened because the we copied pointer to array from P1 to P2, and when we changed in P2, changes were reflected in P1 too.

- With default copy constructor only a **Shallow Copy** is created.

- We can explicitly create copy constructor to create a **Deep Copy**.

To create a deep copy just create a new array for P2 using explicitly supplied copy constructor.

```
Person(const Person& p){                      // Explicit Copy Constructor
        age = p.age;
        name = new char[strlen(p.name)];      // Deep Copy created
        strcpy(name, p.name);                 // Array copied
    }

int main(){
           Person P1(20, "Johnny");
           P1.print();            // Johnny : 20

           Person P2 = P1;      // Person P2(P1);       P2.initialiseWith(P1)
           P2.print();            //Johnny : 20

           P2.name[0] = 'T';
           LABEL(P2, P2.name);      // Tohnny
           LABEL(P1, P1.name);      // Johnny         
    }
```

### Copy Asignment Operator
We can assign values from one constructor to another. It can called many times, unlike copy Constructor which is called only once when creating an object.
```
Car c;
Car d;
d = c;
d = e;
d = r;    // Copy Assignment Constructor
```

**Beware** - Copy Assignment Constructor creates shallow copy, do not use it if you have any pointers among data members.

### Destructors
**Default Destructor** - Destroys created objects as soon as the program [main() function] goes out of scope implicitly. It does not deletes dynamically allocated data members, for them we have to manually delete them using `delete ptr`.
- Same name as class name preceded by a tilde `~`.
- Do not return anything and do not take any parameters.
- We only need to write it for deleting dynamically allocated data members.
- When a class contains a pointer to memory allocated in class, we should write a destructor to release memory before the class instance is destroyed. This must be done to avoid memory leak.

```
Car()
{
  cout << "Deleting...";
  delete [] name;         // Deleting 'name' array
}

int main()
{
  Car *DC = new Car(1991, "Audi");      // Dynamic Object will not be destroyed by default destructor
  delete DC;
}
```
