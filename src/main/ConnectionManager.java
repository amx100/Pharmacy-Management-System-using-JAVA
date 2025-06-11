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
    private static boolean connectionValid = true;

    /**
     * Get a shared database connection to reduce the number of open connections.
     * 
     * @return The shared database connection
     */
    public static synchronized Connection getConnection() {
        try {
            // Check if connection is closed or invalid and recreate if needed
            if (sharedConnection == null || sharedConnection.isClosed() || !connectionValid) {
                sharedConnection = Connect.connect();
                connectionValid = true;
            }
        } catch (SQLException e) {
            // If there's an error checking connection status, get a new connection
            sharedConnection = Connect.connect();
            connectionValid = true;
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
                // Don't actually close the connection, just reset the counter
                connectionUsageCount = 0;
            }
        }
    }

    /**
     * Force close the shared database connection. Should only be used when shutting
     * down the application.
     */
    public static synchronized void closeConnection() {
        if (sharedConnection != null) {
            try {
                sharedConnection.close();
            } catch (SQLException e) {
                // Silently handle exception
            } finally {
                sharedConnection = null;
                connectionUsageCount = 0;
            }
        }
    }

    /**
     * Check if connection is valid and set the flag accordingly.
     * Called when an SQL exception occurs.
     */
    public static synchronized void markConnectionInvalid() {
        connectionValid = false;
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