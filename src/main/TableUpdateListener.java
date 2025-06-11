package main;

/**
 * Interface for notifying forms when data in tables has been updated
 */
public interface TableUpdateListener {

    /**
     * Called when data in a table has been updated
     * 
     * @param tableName The name of the table that was updated
     */
    void onTableDataChanged(String tableName);
}