package com.edu.pe.modeloDAO;

import com.edu.pe.config.*;
import com.edu.pe.modelo.*;
import java.sql.*;
import java.util.ArrayList;

public class ConsultaDAO {

    public int RegistrarConsulta(Consulta c) {
        int res = 0;
        try {
            String sql = "insert into Consulta(idPaciente,fecharegistro,motivo,estado,imagen) values(?,NOW(),?,'PENDIENTE',?)";
            Connection cn = Conexion.getConexion();
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setInt(1, c.getPaciente().getIdPaciente());
            ps.setString(2, c.getMotivo());
            ps.setString(3, c.getImagen() != null ? c.getImagen() : "");
            res = ps.executeUpdate();

        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return res;
    }

    public ArrayList<Consulta> ListarMisConsultas(int idPaciente) {
        ArrayList<Consulta> lista = new ArrayList<>();
        try {
            Connection cn = Conexion.getConexion();
            String sql = "select nroConsulta ,idMedico,"
                    + "fn_nomCompletos((select idUsuario from Medico where c.idMedico = idMedico limit 1)) as nomMedico,\n"
                    + " fechaRegistro ,fechaAtencion, motivo, diagnostico , tratamiento , estado, imagen  \n"
                    + " from consulta c where idPaciente = ?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setInt(1, idPaciente);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Consulta c = new Consulta();
                Medico m = new Medico();
                c.setNroConsulta(rs.getInt("nroConsulta"));
                c.setFechaRegistro(rs.getString("fecharegistro"));
                c.setFechaAtencion(rs.getString("fechaAtencion"));
                m.setIdMedico(rs.getInt("idMedico"));
                m.setNombres(rs.getString("nomMedico"));
                c.setMotivo(rs.getString("motivo"));
                c.setDiagnostico(rs.getString("diagnostico"));
                c.setTratamiento(rs.getString("tratamiento"));
                c.setEstado(rs.getString("estado"));
                c.setImagen(rs.getString("imagen"));
                c.setMedico(m);
                lista.add(c);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return lista;
    }

    public ArrayList<Consulta> ListaConsultasPorEstado(String estado) {
        ArrayList<Consulta> lista = new ArrayList<>();
        try {
            Connection cn = Conexion.getConexion();
            String sql = "select nroConsulta , "
                    + "fn_nomCompletos((select idUsuario from Paciente where c.idPaciente = idPaciente limit 1)) as nomPaciente,\n"
                    + " fechaRegistro ,fechaAtencion, motivo, diagnostico , tratamiento , estado,imagen,nombres,apellidos \n"
                    + " from consulta c inner join medico m on m.idMedico = c.idMedico"
                    + " where estado = ?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setString(1, estado);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Consulta c = new Consulta();
                Paciente p = new Paciente();
                Medico m = new Medico();
                c.setNroConsulta(rs.getInt("nroConsulta"));
                c.setFechaRegistro(rs.getString("fecharegistro"));
                c.setFechaAtencion(rs.getString("fechaAtencion"));
                p.setNombres(rs.getString("nomPaciente"));
                c.setMotivo(rs.getString("motivo"));
                c.setDiagnostico(rs.getString("diagnostico"));
                c.setTratamiento(rs.getString("tratamiento"));
                c.setEstado(rs.getString("estado"));
                c.setImagen(rs.getString("imagen"));
                m.setNombres(rs.getString("nombres"));
                m.setApellidos(rs.getString("apellidos"));
                c.setPaciente(p);
                c.setMedico(m);
                lista.add(c);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return lista;
    }

    public ArrayList<Consulta> ListaConsultasAsignar(String estado) {
        ArrayList<Consulta> lista = new ArrayList<>();
        try {
            Connection cn = Conexion.getConexion();
            String sql = "select nroConsulta , "
                    + "fn_nomCompletos((select idUsuario from Paciente where c.idPaciente = idPaciente limit 1)) as nomPaciente,\n"
                    + " fechaRegistro ,fechaAtencion, motivo, diagnostico , tratamiento , estado,imagen \n"
                    + " from consulta c where estado = ? and c.idMedico is null";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setString(1, estado);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Consulta c = new Consulta();
                Paciente m = new Paciente();
                c.setNroConsulta(rs.getInt("nroConsulta"));
                c.setFechaRegistro(rs.getString("fecharegistro"));
                c.setFechaAtencion(rs.getString("fechaAtencion"));
                m.setNombres(rs.getString("nomPaciente"));
                c.setMotivo(rs.getString("motivo"));
                c.setDiagnostico(rs.getString("diagnostico"));
                c.setTratamiento(rs.getString("tratamiento"));
                c.setEstado(rs.getString("estado"));
                c.setImagen(rs.getString("imagen"));
                c.setPaciente(m);
                lista.add(c);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return lista;
    }

    public int AsignarConsulta(Consulta c) {
        int res = 0;
        try {
            String sql = "update Consulta set idMedico = ? where nroConsulta=?";
            Connection cn = Conexion.getConexion();
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setInt(1, c.getMedico().getIdMedico());
            ps.setInt(2, c.getNroConsulta());

            res = ps.executeUpdate();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return res;
    }

    public ArrayList<Consulta> ListaConsultasPorAtender(String estado, int idMedico) {
        ArrayList<Consulta> lista = new ArrayList<>();
        try {
            Connection cn = Conexion.getConexion();
            String sql = "select nroConsulta , "
                    + "fn_nomCompletos((select idUsuario from Paciente where c.idPaciente = idPaciente limit 1)) as nomPaciente,\n"
                    + " fechaRegistro ,fechaAtencion, motivo, diagnostico , tratamiento , estado,imagen \n"
                    + " from consulta c where estado = ? and c.idMedico =?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setString(1, estado);
            ps.setInt(2, idMedico);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Consulta c = new Consulta();
                Paciente m = new Paciente();
                c.setNroConsulta(rs.getInt("nroConsulta"));
                c.setFechaRegistro(rs.getString("fecharegistro"));
                c.setFechaAtencion(rs.getString("fechaAtencion"));
                m.setNombres(rs.getString("nomPaciente"));
                c.setMotivo(rs.getString("motivo"));
                c.setDiagnostico(rs.getString("diagnostico"));
                c.setTratamiento(rs.getString("tratamiento"));
                c.setEstado(rs.getString("estado"));
                c.setImagen(rs.getString("imagen"));
                c.setPaciente(m);
                lista.add(c);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return lista;
    }

    public int AtenderConsulta(Consulta c) {
        int res = 0;
        try {
            String sql = "update consulta set fechaAtencion = NOW() , diagnostico=?,tratamiento=?, estado='ATENDIDO' "
                    + " where nroConsulta = ?";
            Connection cn = Conexion.getConexion();
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setString(1, c.getDiagnostico());
            ps.setString(2, c.getTratamiento());
            ps.setInt(3, c.getNroConsulta());

            res = ps.executeUpdate();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return res;
    }
}
