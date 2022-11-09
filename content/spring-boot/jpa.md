+++
title = "JPA"
date = 2022-06-06T03:29:00+05:30
weight = 8
+++

## ORMs and Hibernate
An **ORM** (Object Relationship Mapper) is a tool that can map POJOs to Rows (in relations) in the database and vice-versa and it can also express relation between them in the code itself. It also simplifies querying as we can query on particular POJOs now instead of writing SQL queries and mapping the output rows onto the fields of POJO.


The goal of using an ORM is: To **make code database provider agnostic** by **generating SQL queries from code**, so we can swap Postgres for H2 or MySQL and no change will be required in the code. Ex - [Hibernate](https://hibernate.org/) is an ORM.

ORMs are _generally_ a bit slower than native SQL since they just add another layer of abstraction but imo they are worth it as they can solve a plethora of safety and optimization problems [0].

We can always write DB provider native SQL, handle the mapping manually, and query via JDBC but that's often a very tedious and "manual" task even for simpler applications.

## Spring Data JPA
**Persistence**: Map and save data from POJO to a relation in database.

JPA goes one step further as it makes the code **ORM framework agnostic**. It is an abstraction (interface/API spec) provided by Java to implement persistence, and ORM frameworks like Hibernate has to implement the functionalities internally.

The goal of using JPA is: We can **swap different JPA "implementations"** like Hibernate with [others](https://www.eclipse.org/eclipselink/) without any code change at all. 

JPA is described in the `javax.persistence` package.

Hibernate is the de facto provider for JPA in Spring and is added transitively when we add the below dependency to enable JPA.

```xml
<dependency>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>
```

```txt
In the code, we write using JPA annotations, JPQL, etc... and it automatically uses ORM (Hibernate) internally. Avoid writing code that is Hibernate specific (org.hibernate)

Data Access Layer -> JPA (spec) -> Hibernate (impl engine) -> JDBC -> Database
```

## Annotations
```java
// class level
@Entity		// this POJO is a table
@Table 		// optional; specify name and constraints on the table
@Embeddable // embed this POJO in another entity; notice that it doesn't have @Entity and thus no @Id
@AttributeOverrides @AttributeOverride	// optional; to override attribute name with column name in embeddable entity pojo

// attribute level
@Id 		// primary key
@SequenceGenerator @GeneratedValue	// generate a unique number everytime or use a sequence
@Column		// specify name and constraints on a column (nullable, unique, updatable, length, etc...)
@Embedded	// embed another POJO into this entity (will be made into same table's columns)
@Transient	// ignore the field; field isn't persisted to database
```	

Table name is the class name (same as entity name) by default if not specified with `@Table(name=)`. We can also specify table name with `@Entity(name=)` but this will change the entity name too and it is used in JPQL queries. We then have to use the entity name provided by `name=` everywhere and not the class name. So its better to leave entity name as the class name and use _@Table_ to change table name.

_Code_: https://github.com/abhishekarya1/Spring-Data-JPA-Tutorial

```txt
emailId in POJO = email_id in table
firstName in POJO = first_name in table

So, camelCase attribute names in POJO becomes snake_case in table column names
```

### More on Entity
Entity is nothing but projection (subset columns) from the actual table. If our _@Entity_ class name is same as table's then no need of _@Table_ annotation, same goes for _@Column_ too. Also an _@Entity_ class will always need an _@Id_ field to be present inside it and a no-args constructor.

We need not have all the columns in _@Entity_. Only those which are available will be fetched, created, or updated just like a normal DTO. Others will be empty or error based on not empty validations.

Another way to get a projection with plain DTOs (no _@Entity_) is to make a query in repository using _@Query_ with constructor expression but this way we will need that specific constructor in the DTO. There are a other ways too such as by using `interface` but they are generally slower.

_References_ (interface and constructor expression techniques): https://stackoverflow.com/questions/22007341/spring-jpa-selecting-specific-columns

## Validations
Doing validations on the persistance layer isn't recommended since it means that we've worked with invalid objects at the higher layers so far.

That said, the Spring Data JPA supports validations out-of-the-box i.e. We don't need to trigger validations by writing `@Validated` or `@Valid`, instead we just define validations in the `@Entity` class and they are enforced implicitly when JPA is working with them.

[Validation Notes](/spring-boot/exception/#validations)

## Hibernate DDL AUTO Property
Apart from usual connection url, username, password, driver we can also add properties to print executed SQL and prettify it too.

Important one is `ddl-auto` property which decides if we can `create`, `update`, or do no modification `none` to schema in the table upon entity persistance and DDL queries.

Here schema refers to the columns in the table.

```txt
spring.jpa.hibernate.ddl-auto=update

create 			-- drop all existing tables and create new
create-drop		-- create tables and drop it upon program finish. used in testing.
update 			-- add schema but don't delete any prior ones
none (default)	-- make no changes to any schema
validate		-- validate existance of schema; if not found then throw exception
```

**Create a database manually and specify URL in properties file using `spring.datasource.url` property and when the application is run, all of the _@Entity_ will be made (or mapped, if they already exist) into table in the specified database**.

_References_: https://stackoverflow.com/questions/42135114/how-does-spring-jpa-hibernate-ddl-auto-property-exactly-work-in-spring

## CommandLineRunner
Always executes upon server run.
```java
@Configuration
public class StudentConfig {
    @Bean
    CommandLineRunner commandLineRunner(StudentRepository repository){
        return args -> {
            Student s1 = Student.builder().name("Abhishek").email("abhishekarya102@gmail.com").build();		// pojo creation
            repository.save(s1);	// method call
        };
```

## Methods
```java
// default methods from JpaRepository
repository.save(s1);		// insert into query
repository.findAll();		// select * query
```

We can build our own custom methods **following the naming conventions and impl will be automatically done!**.
```java
@Repository
public interface StudentRepository extends JpaRepository<Student, Long> {	// <Entity type, Id type>
	List<Student> findByEmail(String email);		// all are custom methods but no need to define impl
	List<Student> findByEmailContaining(String str);		
	List<Student> findByNameNotNull();
}

// calls
repository.findByEmail("abhishek@gmail.com");
repository.findByEmailContaining("gmail.com");
repository.findByNameNotNull();
```

_Reference_: https://docs.spring.io/spring-data/jpa/docs/current/reference/html/#jpa.query-methods

## Query
Specifying queries explicitly with _@Query_ annotation.
```java
// JPQL query; based on class attrs and not column names, ?1 is first parameter
@Query("select s from Student s where s.email = ?1")
Student getStudentByEmailAddress(String email);		// method name doesn't matter now

@Query("select s.name from Student s where s.is = ?1")
String getStudentByEmailAddress(Long id);
```

### Native Queries
```java
@Query(
	value="SELECT * from student_table WHERE name = 'Abhishek';",
	nativeQuery = true
	)
```
### Named Params
```java
@Query("select s from Student s where s.email = :email")
Student getStudentByEmailAddress(String email);

@Query("select s from Student s where s.email = :emailId")
Student getStudentByEmailAddress(@Param("emailId") String email);	// diff param name that arg name with @Param
```

## Modifying
To use modifying and DDL queries in _@Query_.
```java
@Modifying
@Transactional
@Query(value="update student_table set name = ?1, email = ?2 where student_id=2", nativeQuery = true)
public int updateData(String name, String email);
```

Any modifications to be done in transactions so if we use _@Transactional_ on service layer, that'll be fine too.

## Relationships
### One-to-One
```java
// in Onwer entity
String ownerName;
String ownerCity;

@OneToOne
Pet pet;

// pet_pet_id column is added to Owner table as a Foreign Key
```

**Making it bi-directional**:
```java
// in Pet entity
String petName;
String petType;

@OneToOne(mappedBy = "pet")
Owner owner;

// no new column created in Pet table when we map back to Owner as pet_id is already available into Owner table
```

```java
// explicitly specify column to reference

// in Owner entity
@OneToOne
@JoinColumn(				// foreign key to Pet entity
	name = "pet_id",
	referencedColumnName = "petId")
private Pet pet;

// a new column called "pet_id" will be created in Owner's table referencing petId's column in Pet's table
```

A column (called Join Column) named `pet_id` is created in `Owner` referencing `petId` column from `Pet`.

#### Cascading
If there is a one-to-one relation between two tables then we often may try to insert into one table when corresponding data isn't available in other table. 

```java
Pet pet = Pet.builder().petName("Lucy").petType("Dog").build();
Owner owner = Owner.builder().ownerName("Abhishek").ownerCity("New Delhi").pet(pet).build();	// pet object has-a relation
repository.save(owner);
```

As in the above example, if we try to input `Owner` with `Pet` object entry, it will lead to error since INSERT query will be run only for `Owner` table. We need to direct hibernate to insert into `Pet` table too using cascade in _@OnetoOne_ annotation. **All this can be done by the OwnerRepository only which is hardcoded for Owner `interface OwnerRepository extends JpaRepository<Owner, Long>`!**.

```java
@OneToOne(cascade = CascadeType.ALL)
``` 

Other cascade options like `PERSIST` and `DELETE` are also available.

#### Fetch Types
```java
@OneToOne(cascade = CascadeType.ALL,
		  fetch = FetchType.LAZY)

// LAZY - fetch Owner data only on findAll() on Owner (default)
// EAGER - fetch both Owner and corresponding Pet data on findAll() on Owner
```

This will fetch all data in `Owner` and `Pet` when `findAll()` is done on `Pet` due to the bi-directional mapping and `FetchType.ALL`.

#### More on Bi Directional Mapping
`Owner` has reference to `Pet` but not the other way round and it is oblivious to existance of `Owner`.

```java
// in Pet entity
@OneToOne(mappedBy = "pet",		// attr in Owner entity defining one-to-one relation
		  optional = false)			// a Pet must have an Owner
private Owner owner;
```

No new column is created in this (`Pet`) entity's table when we have a `mappedBy` bi-directional relationship.

We won't be able to insert data in `Pet` table alone now using `PetRepository`'s `.save(pet)` as it will lead to error since its not optional now. And if we want to insert to `Owner` table using `Owner`'s' object then we need to add cascade too.
```java
@OneToOne(mappedBy = "pet", 
		  optional = false, 
		  cascade = CascadeType.ALL)
private Owner owner;
```

This will make sure that all pets have an owner and we can insert pets with owner info.

### One-to-Many
One owner can own many pets.

```java
// in Owner entity
@OneToMany
private List<Pet> petList;
```

A new table `owner_pet_list` is created having two columns i.e. primary keys (`owner_id` and `pet_id`) of both the tables and they are also foreign keys to original tables. A `UNIQUE` constraint on `pet_id` is there too since one owner has many pets and each pet is unique.

```txt
owner_id     pet_id (UNIQUE)
--------	 ------
1  				1
1 				2
1 				3
```

If we make `owner_id` as unique then such mapping won't be possible. The "one" side of OneToMany and ManyToOne always has to be repeated (non-unique) to make sense since we can't represent many pets for one unique owner in the table but can represent owner for each unique pet.

**To avoid making another table use Join Column**:
```java
// in Owner entity
@OneToMany
@JoinColumn(
	name = "owner_id",
	referencedColumnName="ownerId"
)
private List<Pet> petList;
```

A `owner_id` column is created in `Pet` since our reference column was in Owner so it got added to Pet too. We can't make this bi-directional since `mappedBy = ...` isn't supported in _@ManyToOne_.

**Can't we add Join Column `pet_id` to Owner (and `referencedColumnName = "petId"`) like we did in OneToOne mapping?** No, it will be runtime error when forming queries. If we do that, one `owner_id` cannot have multiple `pet_id` in Owner table since `owner_id` is PK. We need `owner_id` to be redundant so we add it to Pet table as a non-unique column. For this reason, the Many-to-One side is the owner of relationship as per JPA specification as shown below.

### Many-to-One
Better than One-to-Many acc to JPA spec. Many-to-One are (almost) always the owner side (i.e having Join Column) of a bidirectional relationship in the JPA spec, and by convention the One-to-Many association is annotated by `@OneToMany(mappedBy = ...)`. To promote this, JPA doesn't even provide `mappedBy` property on _@ManyToOne_ annotation.

This one is straightforward like the _@OneToOne_ examples above:
```java
// in Pet entity
@ManyToOne
@JoinColumn(name = "owner_id", referencedColumnName = "ownerId")
private Owner owner;
```

Making it bi-directional:
```java
// in Owner entity
@OneToMany(mappedBy = "owner")
private List<Pet> petList;
```

### Many-to-Many
Each owner can have many pets. And, each pet can have multiple owners.

We always need a new table for this kind of relationship that contains columns from both the tables we want to represent Many-to-Many relationship for.
```java
// in Owner entity
@ManyToMany
@JoinTable(
	name = "owner_pet_table",
	joinColumn = @JoinColumn(
		name = "owner_id",
		referencedColumnName = "ownerId"),
	inverseJoinColumn = @JoinColumn(
		name = "pet_id",
		referencedColumnName = "petId")
)
private List<Pet> petlist;
```

We can use `joinColumns = {}` and `inverseJoinColumns = {}` to specify multiple columns.

```txt
name - name of third table

joinColumn - assign the column of third table from current entity itself

inverseJoinColumn - assign the column of third table from the associated entity

For attribute type, Set<> etc.. can also be used, I have used List<> here.
```

**Making it bi-directional**:
```java
// in Pet entity
@ManyToMany(mappedBy = "petList")
private List<Owner> ownerList;
```

## Paging and Sorting
`JpaRepository` extends from `PagingAndSortingRepository` and we can pass `Pageable` along with a sort param.

### Paging
```java
Pageable firstPagewithThreeRecords = PageRequest.of(0, 3);
Pageable secondPageWithTwoRecords = PageRequest.of(1, 2);
        
List<Course> courses = courseRepository.findAll(secondPageWithTwoRecords).getContent();
long totalElements = courseRepository.findAll(secondPageWithTwoRecords).getTotalElements();
long totalPages = courseRepository.findAll(secondPageWithTwoRecords).getTotalPages();

System.out.println("totalPages = " + totalPages);	// 2
System.out.println("totalElements = " + totalElements);	// 5
System.out.println("courses = " + courses);	// 2 records on 2nd page
```

Use `PageRequest.of(pageNumber, pageSize, Sort)` to create `Pageable` ref to pass to `findAll()` and we can call more methods upon output.

### Sort
Third param of `PageRequest.of()` can be used for sorting pages. Pages are created after sorting on entire table is applied.
```java
Pageable sortByTitle = PageRequest.of(
                        0,
                        2,
                        Sort.by("title"));		// sort by title column

Pageable sortByCreditDesc = PageRequest.of(
                        0,
                        2,
                        Sort.by("credit").descending());	// desc sort on credit column

Pageable sortByTitleAndCreditDesc = PageRequest.of(
                        0,
                        2,
                        Sort.by("title")
                        .descending()
                        .and(Sort.by("credit")));		// sorted by both title and credit in desc order
        
List<Course> courses = courseRepository.findAll(sortByTitle).getContent();

System.out.println("courses = " + courses);
```

## References
- Spring Data JPA Tutorial - Daily Code Buffer [[YouTube](https://youtu.be/XszpXoII9Sg)]
- JavaBrains - JPA and Hibernate Essentials [[YouTube](https://youtube.com/playlist?list=PLqq-6Pq4lTTb3J4IxKEg80LFTUbzm2p7V)]