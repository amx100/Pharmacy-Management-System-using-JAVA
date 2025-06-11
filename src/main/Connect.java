package main;

import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;
import javax.swing.JOptionPane;

public class Connect {

    public static Connection connect() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Add connection pooling parameters to prevent "Too many connections" error
            Properties props = new Properties();
            props.setProperty("user", "root");
            props.setProperty("password", "");

            // Add connection pooling properties
            props.setProperty("autoReconnect", "true");
            props.setProperty("maxReconnects", "5");
            props.setProperty("initialTimeout", "2");

            // Connection pool size parameters
            props.setProperty("connectTimeout", "10000");
            props.setProperty("socketTimeout", "30000");

            // Ensure connections are validated before use
            props.setProperty("testOnBorrow", "true");
            props.setProperty("validationQuery", "SELECT 1");
            props.setProperty("testWhileIdle", "true");

            // Add timezone configuration to avoid potential timezone issues
            String url = "jdbc:mysql://localhost/pharmacy?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
            Connection con = DriverManager.getConnection(url, props);

            if (con != null) {
                return con;
            }
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Database connection error: " + e.getMessage(), "Connection Error",
                    JOptionPane.ERROR_MESSAGE);
        }
        return null;
    }
}
