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
            props.setProperty("maxReconnects", "3");
            props.setProperty("initialTimeout", "2");
            props.setProperty("maxIdle", "25");
            props.setProperty("maxActive", "10");
            props.setProperty("maxWait", "30000");
            props.setProperty("removeAbandoned", "true");
            props.setProperty("removeAbandonedTimeout", "60");

            // Add timezone configuration to avoid potential timezone issues
            String url = "jdbc:mysql://localhost/pharmacy?useSSL=false&serverTimezone=UTC";
            Connection con = DriverManager.getConnection(url, props);

            if (con != null) {
                return con;
            }
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, e.getMessage(), "Error", 2);
        }
        return null;
    }
}
