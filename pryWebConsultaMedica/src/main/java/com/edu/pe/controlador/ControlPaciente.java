package com.edu.pe.controlador;

import com.edu.pe.modelo.Paciente;
import com.edu.pe.modeloDAO.PacienteDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class ControlPaciente extends HttpServlet {

    private PacienteDAO dao = new PacienteDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String accion = request.getParameter("accion") == null ? "" : request.getParameter("accion");

        if (accion.equalsIgnoreCase("registrar")) {
            Registrar(request, response);
        }
    }

    protected void Registrar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        Paciente p = new Paciente();
        p.setCorreo(request.getParameter("correo"));
        p.setPass(request.getParameter("pass"));
        p.setNombres(request.getParameter("nombres"));
        p.setApellidos(request.getParameter("apellidos"));
        p.setDni(request.getParameter("dni"));
        p.setTelefono(request.getParameter("telefono"));
        p.setGenero(request.getParameter("genero"));

        String msg = dao.RegistrarPaciente(p);

        if (!msg.equals("")) {
            if (msg.equals("OK")) {

                request.getSession().setAttribute("success", "Felicitaciones.!! Su cuenta se ha creado correctamente.");
            } else {
                request.setAttribute("paciente", p);
                request.getSession().setAttribute("error", msg);
            }
        } else {
            request.getSession().setAttribute("error", msg);
        }
        request.getRequestDispatcher("PagRegistro.jsp").forward(request, response);
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
