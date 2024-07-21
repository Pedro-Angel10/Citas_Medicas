package com.edu.pe.modelo;

public class Rol {

    private int idRol;
    private String nomRol;

    @Override
    public String toString() {
        return "Rol{" + "idRol=" + idRol + ", nomRol=" + nomRol + '}';
    }

    public int getIdRol() {
        return idRol;
    }

    public void setIdRol(int idRol) {
        this.idRol = idRol;
    }

    public String getNomRol() {
        return nomRol;
    }

    public void setNomRol(String nomRol) {
        this.nomRol = nomRol;
    }

}
