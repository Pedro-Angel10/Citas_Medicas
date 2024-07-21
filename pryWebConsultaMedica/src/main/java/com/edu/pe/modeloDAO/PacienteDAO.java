package com.edu.pe.modeloDAO;

import com.edu.pe.config.*;
import com.edu.pe.modelo.*;
import java.sql.*;

public class PacienteDAO {

    public String RegistrarPaciente(Paciente p) {
        String msg = "";
        try {
            Connection cn = Conexion.getConexion();

            CallableStatement cs = cn.prepareCall("{call SP_RegistrarPaciente(?,?,?,?,?,?,?,?)}");
            cs.registerOutParameter(1, Types.VARCHAR);
            cs.setString(2, p.getCorreo());
            cs.setString(3, p.getPass());
            cs.setString(4, p.getNombres());
            cs.setString(5, p.getApellidos());
            cs.setString(6, p.getDni());
            cs.setString(7, p.getTelefono());
            cs.setString(8, p.getGenero());
            cs.executeUpdate();

            msg = cs.getString(1);

        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return msg;
    }

}
