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
     * 
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
     * Release the shared connection. The connection will be closed when no forms
     * are using it.
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
                JOptionPane.showMessageDialog(null, "Error closing database connection: " + e.getMessage(), "Error",
                        JOptionPane.ERROR_MESSAGE);
            }
        }
    }

    /**
     * Close a PreparedStatement safely
     * 
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
     * 
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
     * 
     * @param rs The ResultSet to close
     * @param ps The PreparedStatement to close
     */
    public static void closeResources(ResultSet rs, PreparedStatement ps) {
        closeResultSet(rs);
        closeStatement(ps);
    }
}