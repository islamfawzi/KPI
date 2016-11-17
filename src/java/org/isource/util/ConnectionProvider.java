/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.isource.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.isource.beans.*;
import org.json.simple.JSONObject;

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
            connection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/kpi", "postgres", "root");
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ConnectionProvider.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(ConnectionProvider.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    public void createTable(String tableName, List<String> cols) {
        try {
            //Drop table if exist
            pstmt = connection.prepareStatement("DROP TABLE IF EXISTS " + tableName);
            pstmt.executeUpdate();

            // create table
            String stmt = "CREATE TABLE IF NOT EXISTS public." + tableName + " ( id numeric NOT NULL, ";
            for (int i = 0; i < cols.size(); i++) {
                stmt += cols.get(i) + " character varying(255), ";
            }

//          stmt += stmt.substring(0, stmt.length() - 2) + " )";
            stmt += " CONSTRAINT " + tableName + "_PK PRIMARY KEY (id))";
            pstmt = connection.prepareStatement(stmt);
            pstmt.executeUpdate();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public void insertData(String tableName, List<List> csvData) {

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
        } catch (Exception ex) {
            ex.printStackTrace();
        }

    }

    public void addFile(String filepath, String tablename) {
        try {

            int table_id = tableExist(tablename);
            if (table_id != 0) {
                pstmt = connection.prepareStatement("UPDATE public.files SET updated = now()"
                        + " WHERE id = ? ");
                pstmt.setInt(1, table_id);
            } else {
                //pstmt = connection.prepareStatement("INSERT INTO public.files (id, filepath, tablename, created, updated) VALUES (1, ?, ?, now(), now())");
                pstmt = connection.prepareStatement("INSERT INTO public.files"
                        + "  SELECT MAX(id) + 1, ?, ?, now(), now()"
                        + "  FROM public.files;");

                pstmt.setString(1, filepath);
                pstmt.setString(2, tablename);
            }
            pstmt.executeUpdate();

        } catch (Exception ex) {
            ex.printStackTrace();
        }
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
            pstmt = connection.prepareStatement("SELECT id, tablename FROM public.files WHERE active = TRUE ORDER BY created ASC");
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Files f = new Files();
                f.setId(rs.getInt(1));
                f.setTablename(rs.getString(2));
                files.add(f);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return files;
    }

    public List<String> getTableCols(String tableName) {
        List<String> cols = new ArrayList<String>();
        try {
            ResultSet rs = connection.getMetaData().getColumns(null, null, tableName, null);
            while (rs.next()) {
                cols.add(rs.getString("COLUMN_NAME"));
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return cols;
    }

    public int addFormula(Formula formula) {
        try {
            pstmt = connection.prepareStatement("INSERT INTO public.formula (id, formula, title) "
                    + " SELECT MAX(id) + 1, ?, ? FROM public.formula");
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
            pstmt = connection.prepareStatement("INSERT INTO public.kpi (id, table_id, formula_id, title, x_axis) "
                    + " SELECT MAX(id) + 1, ?, ?, ?, ? FROM public.kpi");
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
            pstmt = connection.prepareStatement("SELECT kpi.id,kpi.title, kpi.x_axis, formula.formula, files.tablename FROM kpi"
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

    public String calc(String x_axis, String formula, String tablename) {

        formula = formula.replace("{", " cast( ");
        formula = formula.replace("}", " as numeric) ");
        JSONObject obj = new JSONObject();

        try {
            pstmt = connection.prepareStatement("SELECT " + x_axis + "," + formula + " as result FROM " + tablename);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                String key = rs.getString(x_axis);
                if (obj.containsKey(key)) {
                    double value = (Double) obj.get(key) + rs.getDouble("result");
                    obj.put(key, value);
                } else {
                    obj.put(key, rs.getDouble("result"));
                }

            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        System.out.println(obj.toJSONString());
        return obj.toJSONString();
    }

}
