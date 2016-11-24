/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.isource.beans;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author islam
 */
public class Mapping {
    private static List<String> map = new ArrayList<String>();
    private static List<String> chars = new ArrayList<String>();
    
    static{
      
      
      map.add("Day");                       chars.add("A");
      map.add("Shift");                     chars.add("B");
      map.add("Set Up Time");               chars.add("C");            
      map.add("Rest Break");                chars.add("D");
      map.add("Break Down");                chars.add("E");
      map.add("Planned Maintenace");        chars.add("F");
      map.add("Others");                    chars.add("G");
      map.add("Total");                     chars.add("H");
      map.add("Operating Time");            chars.add("I");
      map.add("Availability");              chars.add("J");
      map.add("Total Units Produced");      chars.add("K");     
      map.add("No. of Defects");            chars.add("L");
      map.add("Quality");                   chars.add("M");
      map.add("Total Quantity Produced");   chars.add("N");
      map.add("Performance Rate");          chars.add("O");
      map.add("OEE");                       chars.add("P");
      
                                            chars.add("Q");
                                            chars.add("R");
                                            chars.add("S");
                                            chars.add("T");
                                            chars.add("U");
                                            chars.add("V");
                                            chars.add("W");
                                            chars.add("X");
                                            chars.add("Y");
                                            chars.add("Z");
      
    }
    
    public static List<String> getMap(){
        return map;
    }
    
    public static Map<Integer, String> sortCols( List<String> cols ){
        Map<Integer, String> sortedCols = new LinkedHashMap<Integer, String>();
        
        for(String x : map){
            x = x.trim().toLowerCase().replaceAll("\\W", "");
            if(cols.contains(x)){
                sortedCols.put(cols.indexOf(x),x);
            }
        }
        
    return sortedCols;
    }
    
    public static String getChar(int index){
        return chars.get(index);
    }
    
    public static String getFullLabel(String label){
    
        for(String x : map){
            
            if(x.trim().toLowerCase().replaceAll("\\W", "").equals(label) == true){
                System.out.println(x);
                return x;
            }
        }
        return label;
    }

}
