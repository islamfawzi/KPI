/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.isource.beans;

import java.math.BigDecimal;
import java.util.Date;

/**
 *
 * @author islam
 */
public class Kpi {

    private int id;
    private int table_id;
    private int formula_id;
    private String title;
    private String x_axis;
    private boolean active;
    private Date created;
    private Date updated;

    public Kpi() {
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setTable_id(int table_id) {
        this.table_id = table_id;
    }

    public void setFormula_id(int formula_id) {
        this.formula_id = formula_id;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public void setCreated(Date created) {
        this.created = created;
    }

    public void setUpdated(Date updated) {
        this.updated = updated;
    }

    public void setX_axis(String x_axis) {
        this.x_axis = x_axis;
    }

    public int getId() {
        return id;
    }

    public int getTable_id() {
        return table_id;
    }

    public int getFormula_id() {
        return formula_id;
    }

    public String getTitle() {
        return title;
    }

    public boolean isActive() {
        return active;
    }

    public Date getCreated() {
        return created;
    }

    public Date getUpdated() {
        return updated;
    }

    public String getX_axis() {
        return x_axis;
    }
}
