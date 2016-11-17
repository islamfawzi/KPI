/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.isource.beans;

/**
 *
 * @author islam
 */
public class KPI_Formula_Table {

    private int kpiId;
    private String kpiTitle;
    private String x_axis;
    private String formula;
    private String tableName;
    private int table_id;
    private int formula_id;

    public KPI_Formula_Table() {

    }

    public int getKpiId() {
        return kpiId;
    }

    public String getKpiTitle() {
        return kpiTitle;
    }

    public String getX_axis() {
        return x_axis;
    }

    public String getFormula() {
        return formula;
    }

    public String getTableName() {
        return tableName;
    }

    public void setKpiId(int kpiId) {
        this.kpiId = kpiId;
    }

    public void setKpiTitle(String kpiTitle) {
        this.kpiTitle = kpiTitle;
    }

    public void setX_axis(String x_axis) {
        this.x_axis = x_axis;
    }

    public void setFormula(String formula) {
        this.formula = formula;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public int getTable_id() {
        return table_id;
    }

    public int getFormula_id() {
        return formula_id;
    }

    public void setTable_id(int table_id) {
        this.table_id = table_id;
    }

    public void setFormula_id(int formula_id) {
        this.formula_id = formula_id;
    }

}
