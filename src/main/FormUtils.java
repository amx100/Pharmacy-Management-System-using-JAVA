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
     * Add a window closing event handler to a form to properly release the database
     * connection
     * 
     * @param frame The JFrame to add the window closing event handler to
     * @param con   The Connection to close
     * @param pre   The PreparedStatement to close
     * @param res   The ResultSet to close
     */
    public static void addWindowClosingEvent(JFrame frame, Connection con, PreparedStatement pre, ResultSet res) {
        frame.addWindowListener(new WindowAdapter() {
            @Override
            public void windowClosing(WindowEvent e) {
                // Close resources in the correct order: ResultSet -> PreparedStatement ->
                // Connection
                ConnectionManager.closeResources(res, pre);
                ConnectionManager.releaseConnection();
            }
        });
    }
}