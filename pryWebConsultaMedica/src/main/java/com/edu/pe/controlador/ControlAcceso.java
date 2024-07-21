package com.edu.pe.controlador;

import com.edu.pe.modelo.Usuario;
import com.edu.pe.modeloDAO.UsuarioDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class ControlAcceso extends HttpServlet {

    private UsuarioDAO dao = new UsuarioDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String accion = request.getParameter("accion") == null ? "" : request.getParameter("accion");

        if (accion.equalsIgnoreCase("login")) {
            IniciarSesion(request, response);
        } else if (accion.equalsIgnoreCase("logout")) {
            CerrarSesion(request, response);
        } else {
            response.sendRedirect("index.jsp");
        }
    }

    protected void IniciarSesion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession sesion = request.getSession();

        String correo = request.getParameter("correo");
        String pass = request.getParameter("pass");

        Usuario user = dao.IniciarSesion(correo, pass);

        if (user != null) {
            if (user.isEstado()) {
                sesion.setAttribute("usuario", user);

                if (user.getNomRol().equalsIgnoreCase("PACIENTE")) {
                    response.sendRedirect("ControlConsulta?accion=misConsultas");
                } else if (user.getNomRol().equalsIgnoreCase("ADMIN")) {
                    response.sendRedirect("ControlConsulta?accion=asignar");
                } else if (user.getNomRol().equalsIgnoreCase("MEDICO")) {
                    response.sendRedirect("ControlConsulta?accion=listaAtender");
                }

            } else {
                sesion.setAttribute("error", "Lo sentimos, su cuenta se encuentra desactivada.");
                response.sendRedirect("index.jsp");
            }
        } else {
            sesion.setAttribute("error", "Correo y/o contraseña incorrecto.");
            response.sendRedirect("index.jsp");
        }
    }

    protected void CerrarSesion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        HttpSession sesion = request.getSession();
        sesion.setAttribute("usuario", null);

        request.getRequestDispatcher("index.jsp").forward(request, response);
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
