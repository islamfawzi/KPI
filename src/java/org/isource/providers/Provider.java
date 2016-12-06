package org.isource.providers;

/**
 *
 * @author islam
 */
public class Provider {

    private static String upload_folder = "/uploads/";
    private static String upload_path;

    public static String getUpload_path() {
        return upload_path;
    }

    public static void setUpload_path(String upload_path) {
        new Provider().upload_path = upload_path;
    }

    public static String getUpload_folder() {
        return upload_folder;
    }
    
    

}
