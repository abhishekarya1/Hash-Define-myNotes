+++
title = "JDBC"
date =  2022-11-25T00:41:00+05:30
weight = 14
+++

## Basics
JDBC (Java Database Connectivity) - API in `java.sql` package for creating database connections and executing queries on relational databases.

The 5 interfaces of JDBC API:
- **Driver** (_eastablish a protocol to communicate with the database_)
- **Connection** (_send commands to the database_)
- **PreparedStatement** (_send an SQL query with parameters to the database_)
- **CallableStatement** (_call a stored procedure from the database_)
- **ResultSet** (_read results of SQL query_)

```java
// complete JDBC demo code
public class MyFirstDatabaseConnection {
	public static void main(String[] args) throws SQLException {
 	 	String url = "jdbc:postgres:localhost:8000/food";
 		try (Connection conn = DataSource.getConnection(url);
 			PreparedStatement ps = conn.prepareStatement("SELECT name FROM vegetarian");
 			ResultSet rs = ps.executeQuery()) {
 				while (rs.next())
 					System.out.println(rs.getString(1));
			} 
	}
}
```

## Building Blocks

### Include the Driver
Driver are a set of classes that contain logic on how Java code and the database understand each other. They are vendor specific.

Traditionally we used to place a driver JAR in our project. 

Nowadays, with build systems like Maven and Gradle we include it as a dependency.

```xml
<!-- MySQL Driver Dependency -->
<dependency>
	<groupId>com.mysql</groupId>
	<artifactId>mysql-connector-j</artifactId>
	<scope>runtime</scope>
</dependency>
```

### Get the JDBC URL
```txt
jdbc:<dbprovider>://<serverURL>/<databaseName>

jdbc:postgres://localhost:8000/food

many other forms...
```

### Create a Connection
Either use `DriverManager` or `DataSource` (both are in-built in Java). The latter is better as it has more features and can take input from external sources.
```java
Connection conn = DataSource.getConnection(url);
```

### Build & Execute SQL Queries

Use `Statement` interface or its subinterfaces: `PreparedStatement` or `CallableStatement`.

`Statement` doesn't take any parameters, just executes whatever query we supply to it.

```java
// for INSERT, UPDATE, DELETE
try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM vegetarian")) {
 	int result = ps.executeUpdate();
 	System.out.println(result);	 	// 1
}

// for SELECT
try (var ps = conn.prepareStatement("SELECT * FROM vegetarian");
	 ResultSet rs = ps.executeQuery()) {
 	// work with rs
}

// for both
boolean isResultSet = ps.execute();
// returns "true" if SELECT query is passed to it and ResultSet is there; otherwise "false"
if (isResultSet) {
	try (ResultSet rs = ps.getResultSet()) {	// get result set
		System.out.println("ran a query");
	}
} 
else {
	int result = ps.getUpdateCount();		// get updated row count
	System.out.println("ran an update");
}
```

- `ps.executeUpdate()`
- `ps.executeQuery()`
- `ps.execute()`


**Parameterized Statements**: Indexing starts from `1` and not `0`.
```java
String sql = "INSERT INTO names VALUES(?, ?, ?)";
try (var ps = conn.prepareStatement(sql)) {
	ps.setInt(1, x);
	ps.setString(3, y);
	ps.setInt(2, z);
	ps.executeUpdate();
}

// use ps.setObject() for any type
```

### Read ResultSet
`ResultSet` has a cursor, and it is indexed from `1` and not `0`, just like a `PreparedStatement`.

```java
String sql = "SELECT id, name FROM food";
try (var ps = conn.prepareStatement(sql);
	ResultSet rs = ps.executeQuery()) {

	while (rs.next()) {
		int id = rs.getInt("id");				// can use .getInt(1) here
		String name = rs.getString("name");		// can use .getString(2) here

		// process both here...
	}
}

// use rs.getObject() for any type
```

## Transactions
```java
conn.setAutoCommit(false);	// to let the database know that we'll handle transactions ourselves

conn.commit();
conn.rollback();

Savepoint sp1 = conn.setSavepoint();
Savepoint sp2 = conn.setSavepoint("second savepoint");		// savepoint with a name
conn.rollback(sp2);
conn.rollback(sp1);
```

## Closing Resources
- Closing a `Connection` closes `PreparedStatement` and `ResultSet` too
- Closing a `PreparedStatement` closes `ResultSet` too

All the above examples on this page used try-with-resources to close resources, this is how its done traditionally.

Although, with modern frameworks such as Spring, it is not recommended to close resources manually unless you know what you're doing, since a connection maybe required to continue the same transaction in another class, etc. Spring provides in-built classes like `JdbcTemplate` to run the query that can automatically close the connection later.