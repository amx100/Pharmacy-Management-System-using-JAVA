# Database Connection Fix for Pharmacy Management System

## Problem
The application is experiencing a "Too many connections" error when opening and closing multiple forms. This happens because database connections are not properly closed when forms are closed.

## Solution
To fix this issue, follow these steps:

### 1. Create a ConnectionManager Class

Create a new Java class `ConnectionManager.java` in the `src/main` package:

```java
package main;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.swing.JOptionPane;

/**
 * Centralized connection manager to prevent database connection leaks.
 * Implements a singleton pattern for the database connection.
 */
public class ConnectionManager {
    
    private static Connection sharedConnection = null;
    private static int connectionUsageCount = 0;
    
    /**
     * Get a shared database connection to reduce the number of open connections.
     * @return The shared database connection
     */
    public static synchronized Connection getConnection() {
        if (sharedConnection == null) {
            sharedConnection = Connect.connect();
        }
        
        connectionUsageCount++;
        return sharedConnection;
    }
    
    /**
     * Release the shared connection. The connection will be closed when no forms are using it.
     */
    public static synchronized void releaseConnection() {
        if (sharedConnection != null) {
            connectionUsageCount--;
            
            // Only close the connection when no forms are using it
            if (connectionUsageCount <= 0) {
                closeConnection();
                connectionUsageCount = 0;
            }
        }
    }
    
    /**
     * Close the shared database connection.
     */
    public static synchronized void closeConnection() {
        if (sharedConnection != null) {
            try {
                sharedConnection.close();
                sharedConnection = null;
            } catch (SQLException e) {
                JOptionPane.showMessageDialog(null, "Error closing database connection: " + e.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
            }
        }
    }
    
    /**
     * Close a PreparedStatement safely
     * @param ps The PreparedStatement to close
     */
    public static void closeStatement(PreparedStatement ps) {
        if (ps != null) {
            try {
                ps.close();
            } catch (SQLException e) {
                // Silently handle the exception
            }
        }
    }
    
    /**
     * Close a ResultSet safely
     * @param rs The ResultSet to close
     */
    public static void closeResultSet(ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                // Silently handle the exception
            }
        }
    }
    
    /**
     * Close all database resources safely
     * @param rs The ResultSet to close
     * @param ps The PreparedStatement to close
     */
    public static void closeResources(ResultSet rs, PreparedStatement ps) {
        closeResultSet(rs);
        closeStatement(ps);
    }
}
```

### 2. Create a FormUtils Class

Create a new Java class `FormUtils.java` in the `src/main` package:

```java
package main;

import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.swing.JFrame;

/**
 * Utility class for forms to properly manage database resources
 */
public class FormUtils {
    
    /**
     * Add a window closing event handler to a form to properly release the database connection
     * @param frame The JFrame to add the window closing event handler to
     * @param con The Connection to close
     * @param pre The PreparedStatement to close
     * @param res The ResultSet to close
     */
    public static void addWindowClosingEvent(JFrame frame, Connection con, PreparedStatement pre, ResultSet res) {
        frame.addWindowListener(new WindowAdapter() {
            @Override
            public void windowClosing(WindowEvent e) {
                // Close resources in the correct order: ResultSet -> PreparedStatement -> Connection
                ConnectionManager.closeResources(res, pre);
                ConnectionManager.releaseConnection();
            }
        });
    }
}
```

### 3. Modify the Connect Class

Update the `Connect.java` class to use connection pooling parameters:

```java
package main;

import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;
import javax.swing.JOptionPane;

public class Connect {

    public static Connection connect() {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            
            // Add connection pooling parameters to prevent "Too many connections" error
            Properties props = new Properties();
            props.setProperty("user", "root");
            props.setProperty("password", "");
            
            // Add connection pooling properties
            props.setProperty("autoReconnect", "true");
            props.setProperty("maxReconnects", "3");
            props.setProperty("initialTimeout", "2");
            props.setProperty("maxIdle", "25");
            props.setProperty("maxActive", "10");
            props.setProperty("maxWait", "30000");
            props.setProperty("removeAbandoned", "true");
            props.setProperty("removeAbandonedTimeout", "60");
            
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/pharmacy", props);
            
            if (con != null) {
                return con;
            }
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, e.getMessage(), "Error", 2);
        }
        return null;
    }
}
```

### 4. Modify All Form Classes

For each form class that uses a database connection (like `Almost_Finish.java`, `BuyDrug.java`, `Customer.java`, etc.), make the following changes:

1. Change the connection initialization in the constructor:
   ```java
   // Change this:
   con = Connect.connect();
   
   // To this:
   con = ConnectionManager.getConnection();
   
   // Add this at the end of the constructor:
   FormUtils.addWindowClosingEvent(this, con, pre, res);
   ```

2. Modify methods that use the database to properly close resources:
   ```java
   // Before executing a query:
   if (pre != null) {
       pre.close();
   }
   if (res != null) {
       res.close();
   }
   
   // For temporary queries, use local variables and close them:
   PreparedStatement tempPre = null;
   ResultSet tempRes = null;
   try {
       tempPre = con.prepareStatement(sql);
       tempRes = tempPre.executeQuery();
       // Use tempRes...
   } finally {
       ConnectionManager.closeResources(tempRes, tempPre);
   }
   ```

3. For the report generation methods, modify them to avoid closing the connection but ensure ResultSet is closed:
   ```java
   public static void generateReport(PreparedStatement preparedStatement) {
       ResultSet resultSet = null;
       try {
           // ...
           resultSet = preparedStatement.executeQuery();
           // ...
       } catch (Exception e) {
           e.printStackTrace();
       } finally {
           // Close the ResultSet but don't close the connection
           try {
               if (resultSet != null) {
                   resultSet.close();
               }
           } catch (SQLException e) {
               e.printStackTrace();
           }
       }
   }
   ```

### 5. Change setDefaultCloseOperation for Child Forms

For forms that are opened from the main Pharmacy window:

```java
// In the Pharmacy.java class, when opening child forms:
childForm.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
```

## Additional MySQL Server Configuration

You may also want to adjust your MySQL server configuration to allow more connections:

1. Edit your MySQL configuration file (my.ini or my.cnf)
2. Increase the max_connections parameter:
   ```
   max_connections = 200
   ```
3. Restart the MySQL server

This combined approach will prevent connection leaks and ensure your application doesn't run into "Too many connections" errors. 