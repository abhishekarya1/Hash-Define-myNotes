+++
title = "JPA"
date = 2022-06-06T03:29:00+05:30
weight = 3
+++

## Spring Data JPA
An **ORM** (Object Relationship Mapper) is a tool that can map POJOs to Relations (tables) in a database and vice-versa and it can also express relation between them in code itself. It also simplifies querying as we can query on particular POJOs now instead of writing SQL queries.

**Persistance**: To map POJO to table in database.

**Spring Data JPA**: It is an abstraction (interface) provided by the Spring to implement persistence and tools like **Hibernate** implement those functionality in the code. The goal is to simplify queries and to make the code provider agnostic, so we can swap Postgres for H2 or MySQL and no change will be required in the code.

Most of the annotations used are from `javax.persistance.*` and Hibernate is the default provider when we add the below dependency to enable JPA.

```xml
<dependency>
	<groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>
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
@SequenceGenerator @GeneratedValue	// generate a unique number everytime a row is added using sequence
@Column		// specify name and constraints on a column
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

## Hibernate Validations

```xml
spring-boot-starter-validation
```
Many annotation based validations can be specified in _@Entity_ class directly. When we convert (deserialize) from JSON to POJO, these validations are performed and BAD_REQUEST status is returned along with messsage (if specified) in place of JSON value.
```java
@NotBlank(message="Please provide value for name!")
private String name;

@Length(min=1, max=5)
@Size(min=0, max=10)
@Email
@Positive
@Negative
@PositiveOrZero
@NegativeOrZero
@Past
@Future
@PastOrPresent
```

## DDL AUTO Property
Apart from usual connection url, username, password, driver we can also add dependencies to print executed SQL and prettify it too.

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

**Create a database manually and specify URL in properties file using `spring.datasource.url` property and when the application is run, all of the _@Entity_ will be made into table in the specified database**.

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

// no new column created in Pet table when we map back to Owner as pet_id is already added into Owner table
```

```java
// explicitly specify column to reference

// in Owner entity
@OnetoOne
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
@OnetoOne(cascade = CascadeType.ALL)
``` 

Other cascade options are also available.

#### Fetch Types
```java
@OnetoOne(cascade = CascadeType.ALL,
		  fetch = FetchType.LAZY)

// LAZY - fetch Owner data only on findAll() on Owner
// EAGER - fetch both Owner and corresponding Pet data on findAll() on Owner
```

This will fetch all data in `Owner` and `Pet` when `findAll()` is done on `Pet` due to the bi-directional mapping and `FetchType.ALL`.

#### More on Bi Directional Mapping
`Owner` has reference to `Pet` but not the other way round and it is oblivious to existance of `Owner`.

```java
// in Pet entity
@OnetoOne(mappedBy = "pet",		// attr in Owner entity defining one-to-one relation
		  optional = false)			// a Pet must have an Owner
private Owner owner;
```

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
// in Teacher entity
@OnetoMany(cascade=CascadeType.ALL)
@JoinColumn(
	name = "teacher_id",
	referencedColumnName="teacherId"
)
private List<Course> course;
```

A `teacher_id` column is created in `Course` since our reference column was in Teacher so it added to Course too.

We can make this bi-directional too using `@ManytoOne` and `mappedBy` property in `Course` entity.
```java
@ManytoOne(mappedBy="course")
private Teacher teacher;
```

### Many-to-One
Better than One-to-Many acc to JPA spec.
```java
// in Course entity
@ManytoOne(cascade=CascadeType.ALL)
@JoinColumn(
	name = "teacher_id",
	referencedColumnName="teacherId"
)
private Teacher teacher;
```
We can make this bi-directional too using `@OnetoMany` and `mappedBy` property in `Teacher` entity.
```java
@OnetoMany(mappedBy="teacher")
private List<Course> course;
```

### Many-to-Many
Many students can have multiple courses. We always need a new table for this kind of relationship that contains columns from both the tables we want to represent many-to-many relationship for.
```java
// in Course entity
@ManytoMany(cascade=CascadeType.ALL)
@JoinTable(
	name="student_course_map",
	joinColumn=@JoinColumn(
		name="course_id",
		referencedColumnName="courseId"),
	inverseJoinColumn=@JoinColumn(
		name="student_id",
		referencedColumnName="studentId")
)
private List<Student> students;
```
No need to do this in `Student` entity.

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