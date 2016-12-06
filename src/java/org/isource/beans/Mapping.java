/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.isource.beans;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.SortedSet;
import java.util.TreeSet;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.isource.providers.Provider;

/**
 *
 * @author islam
 */
public class Mapping {

    private static List<String> map = new ArrayList<String>();
    private static String charcters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

    static {

        map.add("Day");
        map.add("Shift");
        map.add("Set Up Time");
        map.add("Rest Break");
        map.add("Break Down");
        map.add("Planned Maintenace");
        map.add("Others");
        map.add("Total");
        map.add("Operating Time");
        map.add("Availability");
        map.add("Total Units Produced");
        map.add("No. of Defects");
        map.add("Quality");
        map.add("Total Quantity Produced");
        map.add("Performance Rate");
        map.add("OEE");

    }

    public static List<String> getMap() {
        return map;
    }

    public static Map<Integer, String> sortCols(List<String> cols) {
        Map<Integer, String> sortedCols = new LinkedHashMap<Integer, String>();

        for (String x : map) {
            x = x.trim().toLowerCase().replaceAll("\\W", "");
            if (cols.contains(x)) {
                sortedCols.put(cols.indexOf(x), x);
            }
        }

        return sortedCols;
    }

    public static Map<Integer, String> sortList(List<String> cols) {

        Map<Integer, String> sortedCols = new HashMap<Integer, String>();

        List<String> not_contained = new ArrayList<String>();
        List<String> minified_map = minify(map);

        for (String col : cols) {

            if (minified_map.contains(col)) {
                System.out.println("index of map: " + minified_map.indexOf(col));
                sortedCols.put(minified_map.indexOf(col), col);
            } else {
                not_contained.add(col);
            }

        }

        for (int i = 0; i < not_contained.size(); i++) {
            sortedCols.put(minified_map.size() + i, not_contained.get(i));
        }

        return sortMap(sortedCols);
    }

    private static Map<Integer, String> sortMap(Map<Integer, String> map) {

        Map<Integer, String> sortedMap = new HashMap<Integer, String>();
        List<Integer> sortedKeys = new ArrayList<Integer>(map.keySet());
        Collections.sort(sortedKeys);

        int index = 0;
        for (int i : sortedKeys) {
            sortedMap.put(index, map.get(i));
            index++;
        }

        System.out.print("sorted keys: ");
        System.out.println(sortedMap);
        return sortedMap;
    }

    public static List<String> minify(List<String> list) {

        List<String> minified = new ArrayList<String>();
        for (String w : list) {
            minified.add(w.trim().toLowerCase().replaceAll("\\W", ""));
        }
        return minified;
    }

    public static String getFullLabel(String label) {

        for (String x : map) {

            if (x.trim().toLowerCase().replaceAll("\\W", "").equals(label) == true) {
                System.out.println(x);
                return x;
            }
        }
        return label;
    }

    public static boolean inMap(String label) {

        for (String x : map) {

            if (x.trim().toLowerCase().replaceAll("\\W", "").equals(label) == true) {

                return true;
            }
        }
        return false;
    }

    public static String getCharAt(int index) {

        return charcters.substring(index, index + 1);
    }

    public static void addToMap(String colname) {

        map.add(colname);
        
        try {
            FileInputStream file = new FileInputStream(new File(Provider.getUpload_path() + "validation.xls"));

            HSSFWorkbook workbook = new HSSFWorkbook(file);
            HSSFSheet sheet = workbook.getSheetAt(0);
            Row row = sheet.getRow(0);
            Cell cell = row.createCell(map.size()-1);
            cell.setCellType(Cell.CELL_TYPE_STRING);
            cell.setCellValue(colname);
            
            file.close();

            FileOutputStream outFile = new FileOutputStream(new File(Provider.getUpload_path() + "validation.xls"));
            workbook.write(outFile);
            outFile.close();

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        
    }

}
