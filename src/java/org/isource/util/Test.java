/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.isource.util;

import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author islam
 */
public class Test {
    
    public static void main(String[] args) {
        String file = "/opt/tomcat7/webapps/data/import.csv";
        CSVUtils.readCsv(file);
    }
}
