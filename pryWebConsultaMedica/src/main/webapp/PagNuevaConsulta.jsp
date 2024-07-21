<%@page import="com.edu.pe.utils.*"%>
<%@page import="com.edu.pe.modelo.*"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
        <title>Nueva Consulta</title>
        <jsp:include page="includes/Recursos.jsp" />
    </head>
    <body>
        <jsp:include page="includes/Header.jsp" />
        <%
            Consulta c = (Consulta) request.getAttribute("consulta");
        %>

        <div class="container container-web-page">
            <h3 class="font-weight-bold poppins-regular text-uppercase">Nueva Consulta</h3>
            <hr>

            <div class="card div-bordered">
                <div class="card-body">
                    <div class="row">

                        <div class="col-sm-6">
                            <form method="post" action="ControlConsulta"  enctype="multipart/form-data">
                                <%
                                    if (request.getSession().getAttribute("usuario") == null) {
                                %>
                                <div class="alert alert-danger" role="alert">
                                    Para realizar una consulta debe estar autentificado.
                                </div>
                                <%
                                    }
                                %>
                                <div class="form-group">
                                    <label >Motivo:</label>
                                    <textarea class="form-control" rows="4" name="motivo" required=""><%=c == null ? "" : c.getMotivo()%></textarea>
                                </div>

                                <div class="form-group">
                                    <label >Imagen:</label>
                                    <input type="file" class="form-control" name="imagen">
                                </div>

                                <div class="form-group mt-3">
                                    <%
                                        if (request.getSession().getAttribute("usuario") == null) {
                                    %>
                                    <button class="btn btn-primary" disabled="">Consultar</button>

                                    <a href="index.jsp">¿Ya tienes una cuenta? Iniciar Sesión</a>
                                    <%
                                    } else {
                                    %>
                                    <button class="btn btn-primary">Consultar</button>
                                    <%
                                        }
                                    %>

                                </div>
                                <input type="hidden" name="accion" value="registrar">
                            </form>
                        </div>
                        <div class="col-sm-6 text-center">
                            <img src="assets/img/fondo_consulta.jpg" class="img-fluid"/>
                        </div>
                    </div>
                </div>
            </div>
            <jsp:include page="includes/Mensajes.jsp" />
    </body>
</html>