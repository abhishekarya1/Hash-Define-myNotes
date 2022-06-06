+++
title = "JPA"
date = 2022-06-06T03:29:00+05:30
weight = 2
+++

## Spring Data JPA
An **ORM** (Object Relationship Mapper) is a tool that can map POJOs to Relations (tables) in a database and it can also express relation between them in code itself. It also simplifies querying as we can query on particular POJOs now instead of writing SQL queries.

**Persistance**: To map POJO to table in database.

**Spring Data JPA**: It is an abstraction (interface) provided by the Spring to implement persistence and tools like **Hibernate** implement those functionality in the code.

Most of the annotations used here are from `javax.persistance.*` and Hibernate is just the provider which is changeable.

## Annotations
```java
// class level
@Entity		// this POJO is a table
@Table 		// specify name and constraints on table
@Embeddable // embed this POJO in another entity
@AttributeOverrides @AttributeOverride	// to override attribute name with column name in embeddable entity pojo

// attribute level
@Id 		// primary key
@Column		// specify name and nullable
@SequenceGenerator @GeneratedValue	// generate a sequence everytime a row is added
@Embedded	// embed another POJO into this entity (table)
```	
_Code_: https://github.com/abhishekarya1/Spring-Data-JPA-Tutorial

```txt
emailId in POJO = email_id in table
firstName in POJO = first_name in table

So, camelCase attribute names in POJO becomes snake_case in table column names
```

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
@Query("select s from Student s where s.email = :emailId")
Student getStudentByEmailAddress(@Param("emailId") String email);
```

## Modifying
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
// at attribute level in CourseMaterial entity
@OnetoOne
@JoinColumn(				// foreign key to Course entity
	name="course_id",
	referencedColumnName="courseId")
private Course course;

// a new column called "course_id" will be created in CourseMaterial's table referencing courseId's column in Course's table
```

#### Cascading
If there is a one-to-one relation between two tables then we often may try to insert into one table when corresponding data isn't available in other table. 

As in the above example, if we try to input `CourseMaterial` without `Course` entry previously available in table, it will lead to error and we need to direct using cascade in _@OnetoOne_ annotation.

```java
@OnetoOne(cascade=CascadeType.ALL)
``` 

Other cascade options are also available.

#### Fetch Types
```java
@OnetoOne(cascade=CascadeType.ALL,
		  fetch = FetchType.LAZY)

// LAZY - fetch CourseMaterial data only on findAll() on CourseMaterial
// EAGER - fetch both CourseMaterial and corresponding Course data only on findAll() on CourseMaterial
```

#### Bi Directional Relationship
`CourseMaterial` has reference to `Course` but not the other way round and it is oblivious to existance of `CourseMaterial`. 
```java
// in Course entity
@OnetoOne(mappedBy = "course",		// attr in CourseMaterial entity defining one-to-one relation
		  optional = false)			// a Course must have a CourseMaterial
private CourseMaterial courseMaterial;
```

This will fetch all data in `CourseMaterial` and `Course` when `findAll()` is done on `Course` due to the bi-directional mapping.

### One-to-Many
One teacher can teach many courses.

```java
// in Teacher entity
@OnetoMany(cascade=CascadeType.ALL)
@JoinColumn(
	name = "teacher_id",
	referencedColumnName="teacherId"
)
private List<Course> course;
```

A `teacher_id` column is created in `Course` since our reference column was in Teacher only so it added to Course too.

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