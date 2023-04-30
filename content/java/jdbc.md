+++
title = "JDBC"
date =  2022-11-25T00:41:00+05:30
weight = 13
+++

## Basics
JDBC (Java DataBase Connectivity) - API in `java.sql` package for creating database connections and executing queries on relational databases.

The 5 interfaces of JDBC API:
- **Driver** (_eastablish a connection to the database_)
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

### Get the JDBC URL
```txt
jdbc:<dbprovider>://<serverURL>/<databaseName>

jdbc:postgres://localhost:8000/food

many other forms...
```

### Create a Connection
Either use `DriverManager` or `DataSource`. The latter is better as it has more features and can take input from external sources.
```java
Connection conn = DataSource.getConnection(url);
```

### Execute SQL Queries

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

### Reading ResultSet
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