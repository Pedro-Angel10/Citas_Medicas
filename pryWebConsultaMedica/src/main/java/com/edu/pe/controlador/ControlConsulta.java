package com.edu.pe.controlador;

import com.edu.pe.modelo.*;
import com.edu.pe.modeloDAO.*;
import com.edu.pe.utils.Utileria;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

@MultipartConfig(maxFileSize = 104857600, maxRequestSize = 104857600)
public class ControlConsulta extends HttpServlet {

    private ConsultaDAO daoCons = new ConsultaDAO();
    private MedicoDAO daoMed = new MedicoDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String accion = request.getParameter("accion") == null ? "" : request.getParameter("accion");

        if (accion.equalsIgnoreCase("registrar")) {
            RegistrarConsulta(request, response);
        } else if (accion.equalsIgnoreCase("misConsultas")) {
            MisConsultas(request, response);
        } else if (accion.equalsIgnoreCase("asignar")) {
            AsignarConsulta(request, response);
        } else if (accion.equalsIgnoreCase("asignarMedico")) {
            AsignarMedicoConsulta(request, response);
        } else if (accion.equalsIgnoreCase("listaAtender")) {
            ListaConsultaAtender(request, response);
        } else if (accion.equalsIgnoreCase("atender")) {
            AtenderConsulta(request, response);
        } else if (accion.equalsIgnoreCase("exportar_excel")) {
            ExportarConsultaExcel(request, response);
        } else if (accion.equalsIgnoreCase("reporte_estado")) {
            ReporteEstado(request, response);
        }
    }

    protected void ReporteEstado(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession sesion = request.getSession(); 
        Usuario user = (Usuario) sesion.getAttribute("usuario");

        if (user != null && user.getNomRol().equalsIgnoreCase("ADMIN")) {
            String estado = request.getParameter("estado") == null ? "": request.getParameter("estado") ;
            
            ArrayList<Consulta> lista = daoCons.ListaConsultasPorEstado(estado);
            request.setAttribute("consultas", lista);
            request.setAttribute("estado", estado);
            request.getRequestDispatcher("PagReporteEstado.jsp").forward(request, response);
        } else {
            request.getSession().setAttribute("error", "Lo sentimos no se encuentra autenficado o no cumple con el rol de ADMIN.");
            response.sendRedirect("index.jsp");
        }
    }

    protected void ExportarConsultaExcel(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession sesion = request.getSession();
        Usuario user = (Usuario) sesion.getAttribute("usuario");
        try {
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=reporte_consulta_citas.xlsx");

            String[] columnas = {"# Consulta", "Medico", "Fecha Registro", "Fecha Atención", "Estado", "Motivo", "Diagnostico", "Tratamiento"};

            XSSFWorkbook workbook = new XSSFWorkbook();

            ByteArrayOutputStream stream = new ByteArrayOutputStream();
            XSSFSheet hoja = workbook.createSheet();
            Row fila = hoja.createRow(0);
            CellStyle cabeceraEstilo = workbook.createCellStyle();
            cabeceraEstilo.setFillForegroundColor(IndexedColors.OLIVE_GREEN.getIndex());
            cabeceraEstilo.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            cabeceraEstilo.setBorderBottom(BorderStyle.THIN);
            cabeceraEstilo.setBorderLeft(BorderStyle.THIN);
            cabeceraEstilo.setBorderRight(BorderStyle.THIN);
            cabeceraEstilo.setBorderBottom(BorderStyle.THIN);
            cabeceraEstilo.setAlignment(HorizontalAlignment.CENTER);
            cabeceraEstilo.setVerticalAlignment(VerticalAlignment.CENTER);

            Font fuenteCabecera = workbook.createFont();
            fuenteCabecera.setFontName("Arial");
            fuenteCabecera.setBold(true);
            fuenteCabecera.setFontHeightInPoints((short) 12);
            fuenteCabecera.setColor(IndexedColors.WHITE.getIndex());
            cabeceraEstilo.setFont(fuenteCabecera);
            hoja.setDefaultColumnWidth(20);
            hoja.setDefaultRowHeightInPoints(20);

            for (int i = 0; i < columnas.length; i++) {
                Cell cell = fila.createCell(i);
                cell.setCellStyle(cabeceraEstilo);
                cell.setCellValue(columnas[i]);

            }

            int idPac = user.getId();
            ArrayList<Consulta> lista = daoCons.ListarMisConsultas(idPac);
            int initRow = 1;
            for (Consulta c : lista) {
                fila = hoja.createRow(initRow);
                fila.createCell(0).setCellValue(c.getNroConsulta());
                fila.createCell(1).setCellValue(c.getMedico().getNombres() == null ? "" : c.getMedico().getNombres());
                fila.createCell(2).setCellValue(c.getFechaRegistro());
                fila.createCell(3).setCellValue(c.getFechaAtencion() == null ? "" : c.getFechaAtencion());
                fila.createCell(4).setCellValue(c.getEstado());
                fila.createCell(5).setCellValue(c.getMotivo());
                fila.createCell(6).setCellValue(c.getDiagnostico());
                fila.createCell(7).setCellValue(c.getTratamiento());

                initRow++;
            }

            ByteArrayOutputStream outByteStream = new ByteArrayOutputStream();
            workbook.write(outByteStream);
            byte[] outArray = outByteStream.toByteArray();
            OutputStream outStream = response.getOutputStream();
            outStream.write(outArray);
            outStream.flush();

        } catch (Exception ex) {

        }

    }

    protected void AtenderConsulta(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession sesion = request.getSession();
        Usuario user = (Usuario) sesion.getAttribute("usuario");

        if (user != null && user.getNomRol().equalsIgnoreCase("MEDICO")) {
            Consulta c = new Consulta();
            c.setNroConsulta(Integer.parseInt(request.getParameter("nroConsulta")));
            c.setDiagnostico(request.getParameter("diagnostico"));
            c.setTratamiento(request.getParameter("tratamiento"));
            int res = daoCons.AtenderConsulta(c);

            if (res > 0) {
                request.getSession().setAttribute("success", "Se atendió correctamente la consulta con el nro " + c.getNroConsulta());
            } else {
                request.getSession().setAttribute("error", "Lo sentimos no se ha podido atender la consulta con el nro " + c.getNroConsulta());
            }

            response.sendRedirect("ControlConsulta?accion=listaAtender");
        } else {
            request.getSession().setAttribute("error", "Lo sentimos no se encuentra autenficado o no cumple con el rol de MEDICO.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }

    protected void ListaConsultaAtender(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession sesion = request.getSession();
        Usuario user = (Usuario) sesion.getAttribute("usuario");

        if (user != null && user.getNomRol().equalsIgnoreCase("MEDICO")) {
            int idMed = user.getId();

            request.setAttribute("consultas", daoCons.ListaConsultasPorAtender("PENDIENTE", idMed));

            request.getRequestDispatcher("PagConsultasPorAtender.jsp").forward(request, response);
        } else {
            request.getSession().setAttribute("error", "Lo sentimos no se encuentra autenficado o no cumple con el rol de MEDICO.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }

    protected void AsignarMedicoConsulta(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession sesion = request.getSession();
        Usuario user = (Usuario) sesion.getAttribute("usuario");

        if (user != null && user.getNomRol().equalsIgnoreCase("ADMIN")) {
            Consulta c = new Consulta();
            Medico m = new Medico();
            m.setIdMedico(Integer.parseInt(request.getParameter("idMedico")));
            c.setNroConsulta(Integer.parseInt(request.getParameter("nroConsulta")));
            c.setMedico(m);

            int res = daoCons.AsignarConsulta(c);

            if (res > 0) {
                request.getSession().setAttribute("success", "Se asignó medico correctamente a la consulta nro " + c.getNroConsulta());
            } else {
                request.getSession().setAttribute("error", "Lo sentimos no se ha podido asignar medico  a la consulta nro " + c.getNroConsulta());
            }

            response.sendRedirect("ControlConsulta?accion=asignar");
        } else {
            request.getSession().setAttribute("error", "Lo sentimos no se encuentra autenficado o no cumple con el rol de ADMIN.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }

    protected void AsignarConsulta(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession sesion = request.getSession();
        Usuario user = (Usuario) sesion.getAttribute("usuario");

        if (user != null && user.getNomRol().equalsIgnoreCase("ADMIN")) {
            int idPac = user.getId();

            ArrayList<Consulta> listaCons = daoCons.ListaConsultasAsignar("PENDIENTE");
            ArrayList<Medico> listaMed = daoMed.ListaMedicos();

            request.setAttribute("consultas", listaCons);
            request.setAttribute("medicos", listaMed);

            request.getRequestDispatcher("PagAsignarConsultas.jsp").forward(request, response);
        } else {
            request.getSession().setAttribute("error", "Lo sentimos no se encuentra autenficado o no cumple con el rol de ADMIN.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }

    protected void MisConsultas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession sesion = request.getSession();
        Usuario user = (Usuario) sesion.getAttribute("usuario");

        if (user != null && user.getNomRol().equalsIgnoreCase("PACIENTE")) {
            int idPac = user.getId();

            ArrayList<Consulta> lista = daoCons.ListarMisConsultas(idPac);

            request.setAttribute("consultas", lista);

            request.getRequestDispatcher("PagMisConsultas.jsp").forward(request, response);
        } else {
            request.getSession().setAttribute("error", "Lo sentimos no se encuentra autenficado o no cumple con el rol de PACIENTE.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }

    protected void RegistrarConsulta(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession sesion = request.getSession();
        Usuario user = (Usuario) sesion.getAttribute("usuario");

        if (user != null) {
            if (!user.getNomRol().equalsIgnoreCase("PACIENTE")) {
                request.getSession().setAttribute("error", "Lo sentimos, la consulta solo son para pacientes :(");
            } else {

                Paciente p = new Paciente();
                Consulta c = new Consulta();
                c.setMotivo(request.getParameter("motivo"));
                p.setIdPaciente(user.getId());
                c.setPaciente(p);

                Part archivoPart = request.getPart("imagen");
                if (archivoPart.getSize() != 0) {
                    String ruta = Utileria.RutaAbsoluta(request, Utileria.RUTA_IMAGEN);
                    String imagen = Utileria.guardarArchivo(ruta, archivoPart, Utileria.NomImagen());
                    c.setImagen(imagen);
                }

                int res = daoCons.RegistrarConsulta(c);

                if (res > 0) {
                    request.getSession().setAttribute("success", "Su consulta fue procesada correctamente.!!");
                } else {
                    request.setAttribute("consulta", c);
                    request.getSession().setAttribute("error", "Lo sentimos, su consulta no se pudo procesar :(");
                }
            }

        } else {
            request.getSession().setAttribute("error", "No se encuentra autenficado para registrar una consulta.");
        }
        request.getRequestDispatcher("PagNuevaConsulta.jsp").forward(request, response);
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
