package com.edu.pe.modelo;

public class Usuario extends Rol {

    private int idUsuario;
    private String correo;
    private String pass;
    private String fechaRegistro;
    private boolean estado;
    private int id;
    private String nome;

    @Override
    public String toString() {
        return "Usuario{" + "idUsuario=" + idUsuario + ", correo=" + correo + ", pass=" + pass + ", fechaRegistro=" + fechaRegistro + " , id logeado: " + id + ", nom rol: " + getNomRol() + ", estado=" + estado + ", id=" + id + ", nome=" + nome + '}';
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getPass() {
        return pass;
    }

    public void setPass(String pass) {
        this.pass = pass;
    }

    public String getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(String fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    public boolean isEstado() {
        return estado;
    }

    public void setEstado(boolean estado) {
        this.estado = estado;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

}
