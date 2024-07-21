package com.edu.pe.modeloDAO;

import com.edu.pe.config.*;
import com.edu.pe.modelo.*;
import java.sql.*;

public class UsuarioDAO {

    public Usuario IniciarSesion(String correo, String contrasennia) {
        Usuario user = null;
        try {
            Connection cn = Conexion.getConexion();
            String sql = "SELECT idUsuario , r.idRol , correo , estado , nomRol ,"
                    + " fn_nomCompletos(idUsuario) as nome , fn_id(idUsuario) as id \n"
                    + "FROM usuario u INNER JOIN rol r\n"
                    + "ON r.idRol = u.idRol "
                    + "WHERE correo=? AND pass=?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setString(1, correo);
            ps.setString(2, contrasennia);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = new Usuario();
                user.setIdUsuario(rs.getInt("idUsuario"));
                user.setCorreo(rs.getString("correo"));
                user.setEstado(rs.getBoolean("estado"));
                user.setIdRol(rs.getInt("idRol"));
                user.setNomRol(rs.getString("nomRol"));
                user.setNome(rs.getString("nome"));
                user.setId(rs.getInt("id"));
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return user;
    }

}
