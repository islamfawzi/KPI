/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.isource.util;

import antlr.StringUtils;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.EmptyStackException;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Scanner;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.catalina.tribes.util.Arrays;
import org.apache.commons.lang3.math.NumberUtils;
import org.apache.poi.hssf.usermodel.HSSFEvaluationWorkbook;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.formula.FormulaParseException;
import org.apache.poi.ss.formula.FormulaParser;
import org.apache.poi.ss.formula.FormulaType;
import org.apache.poi.ss.formula.ptg.Ptg;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFEvaluationWorkbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.hibernate.metamodel.source.annotations.attribute.MappedAttribute;
import org.isource.beans.Mapping;

/**
 *
 * @author islam
 */
public class CSVUtils {

    private static final char DEFAULT_SEPARATOR = ',';
    private static final char DEFAULT_QUOTE = '"';

    public static List<List> readCsv(String csvFile) {
        List<List> lines = new ArrayList<List>();
        try {
            if (getFileExtension(csvFile).equalsIgnoreCase("csv")) {
                Scanner scanner = new Scanner(new File(csvFile));
                while (scanner.hasNext()) {
                    List<String> line = parseLine(scanner.nextLine());
                    lines.add(line);
                }
                scanner.close();
            } else if (getFileExtension(csvFile).equalsIgnoreCase("xls")) {
                lines = readXls(csvFile);
            }
        } catch (FileNotFoundException ex) {
            Logger.getLogger(CSVUtils.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            Logger.getLogger(CSVUtils.class.getName()).log(Level.SEVERE, null, ex);
        }

        return lines;
    }

    public static List<List> readXls(String filename) {

        List<List> lines = new ArrayList<List>();

        try {
            FileInputStream file = new FileInputStream(new File(filename));

            //Get the workbook instance for XLS file 
            HSSFWorkbook workbook = new HSSFWorkbook(file);

            lines = readWorkbook(workbook);

            file.close();

        } catch (FileNotFoundException ex) {
            Logger.getLogger(CSVUtils.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            Logger.getLogger(CSVUtils.class.getName()).log(Level.SEVERE, null, ex);
        }

        return lines;
    }

    public static void updateSheet(String filename) {

        try {
            FileInputStream file = new FileInputStream(new File(filename));

            //Get the workbook instance for XLS file 
            HSSFWorkbook workbook = new HSSFWorkbook(file);

            //Get first sheet from the workbook
            HSSFSheet sheet = workbook.getSheetAt(0);

            //Iterate through each rows from first sheet
            Iterator<Row> rowIterator = sheet.iterator();
            int rowNum = 1;
            while (rowIterator.hasNext()) {

                Row row = rowIterator.next();

                List<String> line = new ArrayList<String>();

                Cell newCell = row.createCell(row.getPhysicalNumberOfCells());

                if (rowNum == 1) {
                    newCell.setCellValue("New Cell");
                } else {
                    newCell.setCellType(Cell.CELL_TYPE_FORMULA);
                    newCell.setCellFormula("SUM(B2:B9)");
                }

                rowNum++;
            }

            workbook = evaluateFormulas(workbook);
            FileOutputStream out = new FileOutputStream(new File(filename));
            workbook.write(out);
            out.close();
            file.close();
            System.out.println("update: " + filename);

        } catch (FileNotFoundException ex) {
            Logger.getLogger(CSVUtils.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException ex) {
            Logger.getLogger(CSVUtils.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    public List<String> createSheet(List<String> titles, List<List> lines, String formula) throws FormulaParseException {

        Map<Integer, String> sortedCols = Mapping.sortCols(titles);

        HSSFWorkbook workbook = new HSSFWorkbook();

        HSSFSheet sheet = workbook.createSheet("Calculate Kpi");

        Row header = sheet.createRow(0);

        int title_cell = 0;
        for (int col : sortedCols.keySet()) {
            header.createCell(title_cell).setCellValue(sortedCols.get(col));
            title_cell++;
        }
        header.createCell(sortedCols.size()).setCellValue(formula);

        for (int row = 1; row <= lines.size(); row++) {

            Row dataRow = sheet.createRow(row);
            List<String> line = lines.get(row - 1);

            int cell = 0;
            for (int col : sortedCols.keySet()) {
//              System.out.println(col + "  " + line.get(col));
                Cell c = dataRow.createCell(cell);
                if (isNumeric(line.get(col))) {
                    c.setCellValue(Double.parseDouble(line.get(col)));
                } else {
                    c.setCellValue(line.get(col));
                }
                cell++;
            }

            // create formula result cell
            Cell formula_cell = dataRow.createCell(line.size());
            formula_cell.setCellType(Cell.CELL_TYPE_FORMULA);

            System.out.println(formula);

            // replace # with row ranges
            if (formula.contains("#")) {
                formula_cell.setCellFormula(formula.replace("#", (row + 1) + ""));
            } else {
                formula_cell.setCellFormula(formula);
            }
        }

        List<List> KpiLines = readWorkbook(workbook);
        List formula_output = new ArrayList<String>();

        for (int i = 0; i < KpiLines.size(); i++) {

            List line = KpiLines.get(i);
            formula_output.add(line.get(line.size() - 1));

        }

        // apply formula 
        workbook = evaluateFormulas(workbook);

        // write into sample.xls
        try {
            FileOutputStream out = new FileOutputStream(new File("/media/islam/55247aa2-2234-4e48-8a62-c1fabcb5c84d/opt/apache-tomcat-7.0.70/webapps/data/sample.xls"));
            workbook.write(out);
            out.close();
        } catch (Exception ex) {
        }

        return formula_output;

    }

    private static List<List> readWorkbook(HSSFWorkbook workbook) {

        List<List> lines = new ArrayList<List>();

        workbook = evaluateFormulas(workbook);

        HSSFSheet sheet = workbook.getSheetAt(0);

        Iterator<Row> rowIterator = sheet.iterator();

        while (rowIterator.hasNext()) {

            Row row = rowIterator.next();

            List<String> line = new ArrayList<String>();

            //For each row, iterate through each columns
            Iterator<Cell> cellIterator = row.cellIterator();

            while (cellIterator.hasNext()) {

                Cell cell = cellIterator.next();

                switch (cell.getCellType()) {
                    case Cell.CELL_TYPE_BOOLEAN:
                        line.add(new Boolean(cell.getBooleanCellValue()).toString());
                        break;
                    case Cell.CELL_TYPE_NUMERIC:
                        if (DateUtil.isCellDateFormatted(cell)) {
                            SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy");
                            line.add(dateFormat.format(cell.getDateCellValue()));
                        } else {
                            line.add(new Double(cell.getNumericCellValue()).toString());
                        }
                        break;
                    case Cell.CELL_TYPE_STRING:
                        line.add(cell.getStringCellValue());
                        break;
                    case Cell.CELL_TYPE_FORMULA:
                        switch (cell.getCachedFormulaResultType()) {
                            case Cell.CELL_TYPE_NUMERIC:
                                line.add(new Double(cell.getNumericCellValue()).toString());
                                break;
                            case Cell.CELL_TYPE_STRING:
                                line.add(cell.getRichStringCellValue().toString());
                                break;
                        }
                        break;
                }
            }

            lines.add(line);
        }

        return lines;
    }

    private static HSSFWorkbook evaluateFormulas(HSSFWorkbook wb) {

        FormulaEvaluator evaluator = null;
        evaluator = wb.getCreationHelper().createFormulaEvaluator();
        for (int sheetNum = 0; sheetNum < wb.getNumberOfSheets(); sheetNum++) {
            Sheet sheet = wb.getSheetAt(sheetNum);
            for (Row r : sheet) {
                for (Cell c : r) {
                    if (c.getCellType() == Cell.CELL_TYPE_FORMULA) {
                        evaluator.evaluateFormulaCell(c);
                        if (sheetNum == 0 && c.getColumnIndex() == r.getPhysicalNumberOfCells() - 1) {
                            switch (c.getCachedFormulaResultType()) {
                                case Cell.CELL_TYPE_NUMERIC:
                                    break;
                                case Cell.CELL_TYPE_STRING:
                                    break;
                            }
                        }
                    }
                }
            }
        }
        return wb;
    }

    public static List<String> parseLine(String cvsLine) {
        return parseLine(cvsLine, DEFAULT_SEPARATOR, DEFAULT_QUOTE);
    }

    public static List<String> parseLine(String cvsLine, char separators) {
        return parseLine(cvsLine, separators, DEFAULT_QUOTE);
    }

    public static List<String> parseLine(String cvsLine, char separators, char customQuote) {

        List result = new ArrayList();

        //if empty, return!
        if (cvsLine == null && cvsLine.isEmpty()) {
            return result;
        }

        if (customQuote == ' ') {
            customQuote = DEFAULT_QUOTE;
        }

        if (separators == ' ') {
            separators = DEFAULT_SEPARATOR;
        }

        StringBuffer curVal = new StringBuffer();
        boolean inQuotes = false;
        boolean startCollectChar = false;
        boolean doubleQuotesInColumn = false;

        char[] chars = cvsLine.toCharArray();

        for (char ch : chars) {

            if (inQuotes) {
                startCollectChar = true;
                if (ch == customQuote) {
                    inQuotes = false;
                    doubleQuotesInColumn = false;
                } else //Fixed : allow "" in custom quote enclosed
                {
                    if (ch == '\"') {
                        if (!doubleQuotesInColumn) {
                            curVal.append(ch);
                            doubleQuotesInColumn = true;
                        }
                    } else {
                        curVal.append(ch);
                    }
                }
            } else if (ch == customQuote) {

                inQuotes = true;

                //Fixed : allow "" in empty quote enclosed
                if (chars[0] != '"' && customQuote == '\"') {
                    curVal.append('"');
                }

                //double quotes in column will hit this!
                if (startCollectChar) {
                    curVal.append('"');
                }

            } else if (ch == separators) {

                result.add(curVal.toString());

                curVal = new StringBuffer();
                startCollectChar = false;

            } else if (ch == '\r') {
                //ignore LF characters
                continue;
            } else if (ch == '\n') {
                //the end, break!
                break;
            } else {
                curVal.append(ch);
            }

        }

        result.add(curVal.toString());

        return result;
    }

    public static String getFileExtension(String fileName) {
        if (fileName.lastIndexOf(".") != -1 && fileName.lastIndexOf(".") != 0) {
            return fileName.substring(fileName.lastIndexOf(".") + 1);
        } else {
            return "";
        }
    }

    public static boolean isNumeric(String str) {
        return str.matches("-?\\d+(\\.\\d+)?");  //match a number with optional '-' and decimal.
    }

    public static String validate_formula(String formula) {
         
        List<String> allCols = Mapping.minify(Mapping.getMap());
        
        formula  = new ConnectionProvider().translate_formula(formula, allCols).replace("#", "1");
        System.out.println(formula);
        
        String v_msg = "valid";
        try {
            FileInputStream file = new FileInputStream(new File("/media/islam/55247aa2-2234-4e48-8a62-c1fabcb5c84d/opt/apache-tomcat-7.0.70/webapps/data/validation.xls"));

            HSSFWorkbook workbook = new HSSFWorkbook(file);
            HSSFSheet sheet = workbook.getSheetAt(0);
            Row row = sheet.getRow(0);
            Cell cell = row.createCell(row.getPhysicalNumberOfCells());
            cell.setCellType(Cell.CELL_TYPE_FORMULA);
            
            cell.setCellFormula(formula);
            
            workbook = evaluateFormulas(workbook);
            
            file.close();

            /*
            FileOutputStream outFile = new FileOutputStream(new File("/media/islam/55247aa2-2234-4e48-8a62-c1fabcb5c84d/opt/apache-tomcat-7.0.70/webapps/data/validation.xls"));
            workbook.write(outFile);
            outFile.close();
            */

        } catch (Exception e) {
            v_msg = e.getMessage();
        }
        return v_msg;
    }
    

}
