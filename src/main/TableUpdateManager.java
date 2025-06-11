package main;

import java.util.ArrayList;
import java.util.List;

/**
 * Manager class for handling table update notifications across forms
 */
public class TableUpdateManager {

    // Singleton instance
    private static TableUpdateManager instance;

    // List of registered listeners
    private final List<TableUpdateListener> listeners = new ArrayList<>();

    /**
     * Private constructor for singleton pattern
     */
    private TableUpdateManager() {
    }

    /**
     * Get the singleton instance
     * 
     * @return The TableUpdateManager instance
     */
    public static synchronized TableUpdateManager getInstance() {
        if (instance == null) {
            instance = new TableUpdateManager();
        }
        return instance;
    }

    /**
     * Register a listener for table updates
     * 
     * @param listener The listener to register
     */
    public void addListener(TableUpdateListener listener) {
        if (!listeners.contains(listener)) {
            listeners.add(listener);
        }
    }

    /**
     * Remove a listener
     * 
     * @param listener The listener to remove
     */
    public void removeListener(TableUpdateListener listener) {
        listeners.remove(listener);
    }

    /**
     * Notify all listeners that a table has been updated
     * 
     * @param tableName The name of the table that was updated
     */
    public void notifyTableDataChanged(String tableName) {
        for (TableUpdateListener listener : listeners) {
            listener.onTableDataChanged(tableName);
        }
    }
}