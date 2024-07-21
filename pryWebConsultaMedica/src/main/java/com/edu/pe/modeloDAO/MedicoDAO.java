package com.edu.pe.modeloDAO;

import com.edu.pe.config.*;
import com.edu.pe.modelo.*;
import java.sql.*;
import java.util.ArrayList;

public class MedicoDAO {

    public ArrayList<Medico> ListaMedicos() {
        ArrayList<Medico> lista = new ArrayList<>();
        try {
            Connection cn = Conexion.getConexion();
            String sql = "select idMedico , fn_nomCompletos(u.idUsuario) as nome\n"
                    + "from medico m inner join usuario u on u.idUsuario = m.idUsuario\n"
                    + "where estado = 1 order by 2";
            PreparedStatement ps = cn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Medico m = new Medico();
                m.setIdMedico(rs.getInt("idMedico"));
                m.setNombres(rs.getString("nome"));
                lista.add(m);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return lista;
    }
}
