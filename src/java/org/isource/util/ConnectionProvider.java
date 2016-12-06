/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.isource.util;

import antlr.StringUtils;
import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.poi.ss.formula.FormulaParseException;
import org.apache.poi.ss.formula.FormulaParser;
import org.isource.beans.*;
import org.isource.providers.Provider;
import org.json.simple.JSONObject;
import sun.misc.Signal;
import sun.misc.SignalHandler;

/**
 *
 * @author islam
 */
public class ConnectionProvider {

    private Connection connection;
    private PreparedStatement pstmt;
    private HibernateUtil util;

    public ConnectionProvider() {
        initializeJdbc();
    }

    /**
     * Initialize database connection
     */
    private void initializeJdbc() {

        try {
            Class.forName("org.postgresql.Driver");
            connection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/kpi", "postgres", "postgres");
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ConnectionProvider.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(ConnectionProvider.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    public int createTable(String tableName, List<String> cols) {

        tableName = tableName.trim().toLowerCase().replace(' ', '_');
        
        // if user upload sheet with un-ordered columns
        Map<Integer, String> sorted_cols = Mapping.sortList(cols);
        System.out.println(sorted_cols);
        
        try {
            //Drop table if exist
            pstmt = connection.prepareStatement("DROP TABLE IF EXISTS " + tableName);
            pstmt.executeUpdate();

            String col = "";
            // create table
            String stmt = "CREATE TABLE IF NOT EXISTS public." + tableName + " ( id numeric NOT NULL, ";
            for (int i : sorted_cols.keySet()) {
                col = sorted_cols.get(i);
                stmt += strip_special_chars(col) + " character varying(255), ";

                if (!Mapping.inMap(col)) {
                    Mapping.addToMap(col);
                }
            }

//          stmt += stmt.substring(0, stmt.length() - 2) + " )";
            stmt += " CONSTRAINT " + tableName + "_PK PRIMARY KEY (id))";
            pstmt = connection.prepareStatement(stmt);
            pstmt.executeUpdate();
            
            return 1;
        
        } catch (Exception ex) {
            ex.printStackTrace();
            return 0;
        }
        
    }

    public int insertData(String tableName, List<List> csvData) {

        tableName = tableName.trim().toLowerCase().replace(' ', '_');

        try {
            int id = 1;
            String stmt = "INSERT INTO public." + tableName + " VALUES ( ?,";
            for (int i = 0; i < csvData.get(0).size(); i++) {
                stmt += " ?,";
            }
            stmt = stmt.substring(0, stmt.length() - 1) + " )";
            pstmt = connection.prepareStatement(stmt);
            for (int i = 1; i <= csvData.size() - 1; i++) {
                List<String> line = csvData.get(i);
                pstmt.setInt(1, id);
                for (int j = 1; j <= line.size(); j++) {
                    pstmt.setString(j + 1, line.get(j - 1));
                }
                id++;
                pstmt.executeUpdate();
            }
            return 1;
        } catch (Exception ex) {
            ex.printStackTrace();
            return 0;
        }
    }

    public int addFile(String filepath, String tablename, int formula_id) {

        String title = tablename.substring(0, 1).toUpperCase() + tablename.substring(1);;
        tablename = tablename.trim().toLowerCase().replace(' ', '_');
        int table_id = tableExist(tablename);

        try {

            if (table_id != 0) {
                pstmt = connection.prepareStatement("UPDATE public.files SET updated = now(), formula_id = ?"
                        + " WHERE id = ? ");
                pstmt.setInt(1, formula_id);
                pstmt.setInt(2, table_id);
            } else {
                //pstmt = connection.prepareStatement("INSERT INTO public.files (id, filepath, tablename, created, updated) VALUES (1, ?, ?, now(), now())");
                pstmt = connection.prepareStatement("INSERT INTO public.files (filepath, tablename, title, formula_id)"
                        + " VALUES (?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS);

                pstmt.setString(1, filepath);
                pstmt.setString(2, tablename);
                pstmt.setString(3, title);
                pstmt.setInt(4, formula_id);

            }
            int success = pstmt.executeUpdate();

            // get last inserted id
            ResultSet rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                table_id = rs.getInt(1);
            }

        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return table_id;
    }

    public int tableExist(String tablename) {

        try {
            pstmt = connection.prepareStatement("SELECT id FROM public.files WHERE tablename = ? ");
            pstmt.setString(1, tablename);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    /**
     * List all files from db
     *
     * @return List<Files>
     */
    public List<Files> getFiles() {
        List<Files> files = new ArrayList<Files>();
        try {
            String sql = "select fs.id, fs.tablename, fs.title, fs.filepath, fm.title as formula_title "
                       + "from files fs, formula fm, files_formulas ff " 
                       + "where fs.id = ff.file_id and fm.id = ff.formula_id";
            
            pstmt = connection.prepareStatement("SELECT files.id, files.tablename, files.title, files.filepath, formula.title as formula_title FROM public.files "
                    + " FULL JOIN public.formula ON files.formula_id = formula.id"
                    + " WHERE files.active = TRUE ORDER BY created ASC");
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Files f = new Files();
                f.setId(rs.getInt(1));
                f.setTablename(rs.getString(2));
                f.setTitle(rs.getString(3));
                f.setFilepath(rs.getString(4));
                f.setFormula_title(rs.getString(5));
                files.add(f);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return files;
    }

    public Files getFile(int file_id) {
        Files f = new Files();
        try {
            pstmt = connection.prepareStatement("SELECT files.id, files.tablename, files.title, files.filepath, formula.title as formula_title FROM public.files "
                    + " FULL JOIN public.formula ON files.formula_id = formula.id"
                    + " WHERE files.id = ? LIMIT 1");
            
            /*pstmt = connection.prepareStatement("select fs.id, fs.tablename, fs.title, fs.filepath, fm.title as formula_title "
                    + "from files fs, formula fm, files_formulas ff " +
                "where fs.id = ? and fs.id = ff.file_id and fm.id = ff.formula_id");*/
            
            pstmt.setInt(1, file_id);
            
            ResultSet rs = pstmt.executeQuery();
            rs.next();

            f.setId(rs.getInt(1));
            f.setTablename(rs.getString(2));
            f.setTitle(rs.getString(3));
            f.setFilepath(rs.getString(4));
            f.setFormula_title(rs.getString(5));

        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return f;
    }

    /**
     * delete sheet file + drop table + from files + from files_formulas
     *
     * @param file_id
     * @return boolean deleted
     */
    public boolean delFile(int file_id) {

        boolean deleted = true;
        try {

            Files file = getFile(file_id);

            pstmt = connection.prepareStatement("DELETE FROM public.files WHERE id = ?");
            pstmt.setInt(1, file_id);
            if(pstmt.executeUpdate() < 1){
             deleted = false;
             System.out.println("files not deleted");
            }

            pstmt = connection.prepareStatement("DELETE FROM public.files_formulas WHERE file_id = ?");
            pstmt.setInt(1, file_id);
            
            pstmt = connection.prepareStatement("DROP TABLE IF EXISTS " + file.getTablename());
            int dropped = pstmt.executeUpdate();
            System.out.println("Table Dropped: " + dropped);

            String file_path = Provider.getUpload_path() + file.getFilepath();
            System.out.println("file path " + file_path);
            if (!new File(file_path).delete()) {
                deleted = false;
                System.out.println("files not deleted");
            }


        } catch (Exception ex) {
            deleted = false;
        }

        return deleted;
    }

    public List<String> getTableCols(String tableName) {
        List<String> cols = new ArrayList<String>();
        try {
            ResultSet rs = connection.getMetaData().getColumns(null, null, tableName, null);
            while (rs.next()) {
                String col = rs.getString("COLUMN_NAME");
                if (!col.equals("id")) {
                    cols.add(col);
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return cols;
    }

    public int addFormula(Formula formula) {
        try {
            pstmt = connection.prepareStatement("INSERT INTO public.formula (formula, title) VALUES(?, ?)");
            pstmt.setString(1, formula.getFormula());
            pstmt.setString(2, formula.getTitle());
            return pstmt.executeUpdate();
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return 0;
    }

    public int updateFormula(Formula formula) {
        try {
            pstmt = connection.prepareStatement("Update public.formula SET formula = ?, title = ? WHERE id = ?");
            pstmt.setString(1, formula.getFormula());
            pstmt.setString(2, formula.getTitle());
            pstmt.setInt(3, formula.getId());
            return pstmt.executeUpdate();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    public List<Formula> getFormulaes() {
        List<Formula> formulas = new ArrayList<Formula>();
        try {
            pstmt = connection.prepareStatement("SELECT * FROM public.formula WHERE active = TRUE ORDER BY id ASC");
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Formula f = new Formula();
                f.setId(rs.getInt(1));
                f.setFormula(rs.getString(2));
                f.setActive(rs.getBoolean(3));
                f.setTitle(rs.getString(4));
                formulas.add(f);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return formulas;
    }

    public Formula getFormula(int formula_id) {

        try {
            pstmt = connection.prepareStatement("SELECT * FROM public.formula WHERE id = " + formula_id);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Formula f = new Formula();
                f.setId(rs.getInt(1));
                f.setFormula(rs.getString(2));
                f.setActive(rs.getBoolean(3));
                f.setTitle(rs.getString(4));
                return f;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return null;
    }

    /**
     * get un applied formulas on file
     */
    public List<Formula> get_unapplied_Formulaes(int file_id) {
        List<Formula> formulas = new ArrayList<Formula>();
        try {
            pstmt = connection.prepareStatement("SELECT * "
                    + "FROM public.formula  "
                    + "WHERE id NOT IN "
                    + "    (SELECT formula_id "
                    + "     FROM public.files_formulas WHERE file_id = ?)");
            pstmt.setInt(1, file_id);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Formula f = new Formula();
                f.setId(rs.getInt(1));
                f.setFormula(rs.getString(2));
                f.setActive(rs.getBoolean(3));
                f.setTitle(rs.getString(4));
                formulas.add(f);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return formulas;
    }

    /**
     * get applied formulas on file
     */
    public List<Formula> get_applied_Formulaes(int file_id) {
        List<Formula> formulas = new ArrayList<Formula>();
        try {
            pstmt = connection.prepareStatement("SELECT * "
                    + "FROM public.formula  "
                    + "WHERE id IN "
                    + "    (SELECT formula_id "
                    + "     FROM public.files_formulas WHERE file_id = ?)");
            pstmt.setInt(1, file_id);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Formula f = new Formula();
                f.setId(rs.getInt(1));
                f.setFormula(rs.getString(2));
                f.setActive(rs.getBoolean(3));
                f.setTitle(rs.getString(4));
                formulas.add(f);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return formulas;
    }

    public int delFormula(int kpi_id) {

        try {
            pstmt = connection.prepareStatement("DELETE FROM formula WHERE id = " + kpi_id);
            return pstmt.executeUpdate();
        } catch (Exception ex) {
        }
        return 0;
    }

    public int addKpi(Kpi kpi) {

        try {
            pstmt = connection.prepareStatement("INSERT INTO public.kpi (table_id, formula_id, title, x_axis) "
                    + " VALUES(?, ?, ?, ?)");
            pstmt.setInt(1, kpi.getTable_id());
            pstmt.setInt(2, kpi.getFormula_id());
            pstmt.setString(3, kpi.getTitle());
            pstmt.setString(4, kpi.getX_axis());

            return pstmt.executeUpdate();
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return 0;
    }

    public int updateKpi(Kpi kpi) {

        try {
            pstmt = connection.prepareStatement("UPDATE public.kpi SET table_id = ?, formula_id = ?, title = ?, x_axis = ? WHERE id = ?");
            pstmt.setInt(1, kpi.getTable_id());
            pstmt.setInt(2, kpi.getFormula_id());
            pstmt.setString(3, kpi.getTitle());
            pstmt.setString(4, kpi.getX_axis());
            pstmt.setInt(5, kpi.getId());
            return pstmt.executeUpdate();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    public List<KPI_Formula_Table> getKpis() {
        List<KPI_Formula_Table> kpis = new ArrayList<KPI_Formula_Table>();
        try {
            pstmt = connection.prepareStatement("SELECT kpi.id,kpi.title, kpi.x_axis, formula.formula, files.tablename,formula.title FROM kpi"
                    + " JOIN formula ON kpi.formula_id = formula.id"
                    + " JOIN files ON kpi.table_id = files.id "
                    + " WHERE kpi.active = TRUE "
                    + " ORDER BY kpi.id ASC");
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                KPI_Formula_Table k = new KPI_Formula_Table();
                k.setKpiId(rs.getInt(1));
                k.setKpiTitle(rs.getString(2));
                k.setX_axis(rs.getString(3));
                k.setFormula(rs.getString(4));
                k.setTableName(rs.getString(5));
                k.setFormulaTitle(rs.getString(6));
                kpis.add(k);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return kpis;
    }

    public KPI_Formula_Table getKpi(int kpi_id) {
        try {
            pstmt = connection.prepareStatement("SELECT kpi.title, kpi.x_axis, formula.formula, files.tablename, kpi.table_id, kpi.formula_id FROM kpi"
                    + " JOIN formula ON kpi.formula_id = formula.id"
                    + " JOIN files ON kpi.table_id = files.id "
                    + " WHERE kpi.id = " + kpi_id);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                KPI_Formula_Table k = new KPI_Formula_Table();
                k.setKpiTitle(rs.getString(1));
                k.setX_axis(rs.getString(2));
                k.setFormula(rs.getString(3));
                k.setTableName(rs.getString(4));
                k.setTable_id(rs.getInt(5));
                k.setFormula_id(rs.getInt(6));
                return k;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return null;
    }

    public int delKpi(int kpi_id) {

        try {
            pstmt = connection.prepareStatement("DELETE FROM kpi WHERE id = " + kpi_id);
            return pstmt.executeUpdate();
        } catch (Exception ex) {
        }
        return 0;
    }

    
    /**
     * calculate KPI from (formula , sheet) by apply it into temp sheet
     *
     * @param x_axis
     * @param formula
     * @param tablename
     * @return
     * @throws FormulaParseException
     */
    public String calc2(String x_axis, int formula_id, String tablename) throws FormulaParseException {

        List<String> x_axis_data = new ArrayList<String>();
        List<List> lines = new ArrayList<List>();
        tablename = strip_special_chars(tablename);
        Formula formula_obj = getFormula(formula_id);
        
        try {
            List<String> table_cols = getTableCols(tablename);

//          System.out.println(formula);
            pstmt = connection.prepareStatement("select *, " + x_axis + " as x_axis from " + tablename);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {

                // get x_axis data
                x_axis_data.add(rs.getString(x_axis));

                List<String> line = new ArrayList<String>();
                for (String col : table_cols) {
                    line.add(rs.getString(col));
                }
                lines.add(line);
            }

            // get formula result
            CSVUtils utils = new CSVUtils();
            List<String> kpiout = utils.createSheet(table_cols, lines, formula_obj, tablename);
            System.out.println(Arrays.toString(kpiout.toArray()));
            // get Json String
            return getJsonData(x_axis_data, kpiout, x_axis);

        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return null;
    }

    /**
     * apply formula to sheet (table)
     *
     * @param formula_id
     * @param file_id
     * @param title
     * @throws FormulaParseException
     */
    public boolean apply_formula(int formula_id, int file_id, String title) throws FormulaParseException {

        Files file = getFile(file_id);

        Formula formula_obj = getFormula(formula_id);
       
        List<List> lines = new ArrayList<List>();

        try {
            List<String> table_cols = getTableCols(file.getTablename());

            
            pstmt = connection.prepareStatement("select * from " + file.getTablename());
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {

                List<String> line = new ArrayList<String>();
                for (String col : table_cols) {
                    line.add(rs.getString(col));
                }
                lines.add(line);
            }
            
            title = strip_special_chars(title);

            // get formula result
            CSVUtils utils = new CSVUtils();
            List<String> kpiout = utils.createSheet(table_cols, lines, formula_obj, title);
            kpiout.remove(0);

            // add formula result to each row
            for (int i = 0; i < lines.size(); i++) {
                lines.get(i).add(kpiout.get(i));
            }

            // create new table with old columns + formula column
            table_cols.add(formula_obj.getTitle());
            int created = createTable(title, table_cols);
            System.out.println("created: "+created);
            
            // insert old data + formula result 
            lines.add(0, table_cols);
            int inserted = insertData(title, lines);
            System.out.println("inserted: "+inserted);
            
            // add file into files table
            int new_file_id = addFile( title + ".xls", title, formula_id);

            List<Formula> applied_formulas = get_applied_Formulaes(file_id);

            int added = add_file_formula(formula_id, new_file_id);

            
            // add old applied formulas to new file to not apply it again
            for (Formula f : applied_formulas) {
                added += add_file_formula(f.getId(), new_file_id);
            }
            System.out.println("added: "+added+":"+applied_formulas.size()+1);
            
            // return 
            if(created == 1 && inserted == 1 && added == applied_formulas.size()+1){
                return true;
            }

        } catch (Exception ex) {
            ex.printStackTrace();
        }
        
        return false;
    }

    /*
     * insert into files_formulas table 
     * to not apply formula on table more than once
     */
    public int add_file_formula(int formula_id, int file_id) {

        try {
            // insert into files_formulas
            pstmt = connection.prepareStatement("INSERT INTO files_formulas (file_id, formula_id) VALUES (?, ?)");
            pstmt.setInt(1, file_id);
            pstmt.setInt(2, formula_id);
            return pstmt.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(ConnectionProvider.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return 0;
    }

    /**
     * Convert List to Json String
     *
     * @param x_axis_data
     * @param kpiData
     * @param x_axis
     * @return
     */
    public String getJsonData(List<String> x_axis_data, List<String> kpiData, String x_axis) {

        JSONObject obj = new JSONObject();

        for (int i = 0; i < x_axis_data.size(); i++) {
            String key = x_axis_data.get(i);
            if (obj.containsKey(key)) {
                double value = (Double) obj.get(key) + Double.parseDouble(kpiData.get(i + 1));
                obj.put(key, value);
            } else {
                obj.put(key, Double.parseDouble(kpiData.get(i + 1)));
            }
        }
        return obj.toJSONString();
    }

    /**
     * remove any special chars, spaces and convert into lowerCase
     *
     * @param x
     * @return
     */
    public static String strip_special_chars(String x) {

        x = x.trim().toLowerCase().replaceAll("\\W", "");
        return x;
    }

    public static void main(String[] args) {

     //  String x = new ConnectionProvider().calc2("day", "SUM({Rest Break}#,{Quality}#)", "newtable");
     //  String x = new CSVUtils().validate_formula("SUM({Rest Break}#,{No. of Defects}#");

    }

}
