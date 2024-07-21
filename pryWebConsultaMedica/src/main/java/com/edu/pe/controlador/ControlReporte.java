package com.edu.pe.controlador;

import com.edu.pe.config.Conexion;
import com.edu.pe.modeloDAO.ConsultaDAO;
import com.edu.pe.utils.Utileria;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;

public class ControlReporte extends HttpServlet {

    private ConsultaDAO daoCons = new ConsultaDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String accion = request.getParameter("accion") == null ? "" : request.getParameter("accion");

        if (accion.equalsIgnoreCase("generar_reporte")) {
            GenerarReporte(request, response);
        }
    }

    protected void GenerarReporte(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        try {
            String estado = request.getParameter("estado") == null ? "" : request.getParameter("estado");

            if (estado.length() > 0) {
                String ruta = Utileria.RutaAbsoluta(request) + Utileria.RUTA_REPORTE;
                String nombreArchivo = "ReporteConsulta.jrxml";
                JasperReport reporte = JasperCompileManager.compileReport(ruta + nombreArchivo);

                Map parametros = new HashMap();
                parametros.put("estado", estado);

                JasperPrint jasperPrint = JasperFillManager.
                        fillReport(reporte, parametros, 
                                Conexion.getConexion());
                ServletOutputStream out = response.getOutputStream();
                ByteArrayOutputStream byteOut = new ByteArrayOutputStream();
                JasperExportManager.exportReportToPdfStream(jasperPrint, byteOut);

                response.setContentType("application/pdf");
                out.write(byteOut.toByteArray());
                response.setHeader("Cache-Control", "max-age=0");
                response.setHeader("Content-Disposition", "attachment; filename=" + "ReporteConsultaPorEstado.pdf");
                out.flush();
                out.close();
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
            e.printStackTrace();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
