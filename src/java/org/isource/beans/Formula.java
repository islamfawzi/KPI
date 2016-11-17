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
public class Formula {

    private int id;
    private String formula;
    private String title;
    private boolean active;

    public Formula() {
    }

    public int getId() {
        return id;
    }

    public String getFormula() {
        return formula;
    }

    public String getTitle() {
        return title;
    }

    public boolean isActive() {
        return active;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setFormula(String formula) {
        this.formula = formula;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

}
