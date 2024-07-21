
<%@page import="com.edu.pe.modelo.Usuario"%>
<%
    HttpSession sesion = request.getSession();

    Usuario user = (Usuario) sesion.getAttribute("usuario");
    String rol = user == null ? "" : user.getNomRol();
%>

<%
    if (user != null) {
%>
<div class="alert alert-primary" role="alert">
    <div class="row">
        <div class="col-sm-2 " style="text-align: right;">
            <strong>ROL:</strong> <%=user.getNomRol()%>
        </div>
        <div class="col-sm-6">
            | &nbsp;&nbsp;  <%=user.getNome() == null ? "" : user.getNome().toUpperCase()%>
        </div>
    </div>
</div>

<%
    }
%>
<header class="header full-box">
    <div class="header-brand text-center full-box">
        <a href="#">
            <img src="./assets/img/logo.jpg" alt="logo" class="img-fluid">
        </a>
    </div>

    <div class="header-options full-box">
        <nav class="header-navbar full-box poppins-regular font-weight-bold" >
            <ul class="list-unstyled full-box">
                <%
                    if (rol.equalsIgnoreCase("PACIENTE") || rol.equals("")) {
                %>
                <li>
                    <a href="PagNuevaConsulta.jsp" >Nueva Consulta<span class="full-box" ></span></a>
                </li>
                <%
                    }
                %>

                <%
                    if (rol.equalsIgnoreCase("PACIENTE")) {
                %>
                <li>
                    <a href="ControlConsulta?accion=misConsultas" >Mis Consultas<span class="full-box" ></span></a>
                </li>
                <%
                    }
                %>

                <%
                    if (rol.equalsIgnoreCase("ADMIN")) {
                %>
                <li>
                    <a href="ControlConsulta?accion=asignar" >Consultas Asignar<span class="full-box" ></span></a>
                    <a href="ControlConsulta?accion=reporte_estado" >Reporte<span class="full-box" ></span></a>
                </li>
                <%
                    }
                %>
            </ul>
        </nav>
        <div class="header-button full-box text-center btn-login-menu" >
            <%
                if (user != null) {
            %>
            <a href="ControlAcceso?accion=logout">
                <i class="fas fa-times-circle"  data-mdb-toggle="tooltip" data-mdb-placement="bottom" title="Cerrar Sesión" > </i>

            </a>
            <%
            } else {
            %>
            <a href="index.jsp">
                <i class="fas fa-user-alt"  data-mdb-toggle="tooltip" data-mdb-placement="bottom" title="Login" ></i>
            </a>
            <%
                }
            %>


        </div>
        <!--
        
        -->
    </div>
</header>
