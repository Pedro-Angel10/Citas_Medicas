<%@page import="com.edu.pe.utils.*"%>
<%@page import="com.edu.pe.modelo.*"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
        <title>Registro</title>
        <jsp:include page="includes/Recursos.jsp" />
    </head>
    <body>
        <jsp:include page="includes/Header.jsp" />
        <%
        Paciente p =(Paciente) request.getAttribute("paciente");
        %>

        <div class="container container-web-page">
            <h3 class="font-weight-bold poppins-regular text-uppercase">Registro Paciente</h3>
            <hr>

            <div class="card div-bordered">
                <div class="card-body">
                    <div class="row">

                        <div class="col-sm-6">
                            <form method="post" action="ControlPaciente">
                                <div class="form-group">
                                    <label >Nombres:</label>
                                    <input type="text" class="form-control" name="nombres" required="" maxlength="60" value="<%=p == null?"":p.getNombres()  %>">
                                </div>

                                <div class="form-group">
                                    <label >Apellidos:</label>
                                    <input type="text" class="form-control" name="apellidos" required="" maxlength="60" value="<%=p == null?"":p.getApellidos()%>">
                                </div>

                                <div class="form-group">
                                    <div class="row">
                                        <div class="col-sm-6">
                                            <label >DNI:</label>
                                            <input type="text" class="form-control" name="dni" required="" maxlength="8" value="<%=p == null?"":p.getDni()%>">
                                        </div>
                                        <div class="col-sm-6">
                                            <label >Genero:</label>
                                            <select class="form-control" name="genero">
                                                <option disabled="">:::Seleccione:::</option>
                                                <option value="F" <%= p != null && p.getGenero().equals("F")? "selected": "" %>>Femenino</option>
                                                <option value="M"  <%= p != null && p.getGenero().equals("M")? "selected": "" %> >Masculino</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label >Teléfono:</label>
                                    <input type="text" class="form-control" name="telefono" required="" maxlength="9" value="<%=p == null?"":p.getTelefono()%>">
                                </div>

                                <div class="form-group">
                                    <label >Correo elétronico:</label>
                                    <input type="email" class="form-control" name="correo" required="" maxlength="30" value="<%=p == null?"":p.getCorreo()%>">
                                </div>

                                <div class="form-group">
                                    <label >Contraseña:</label>
                                    <input type="password" class="form-control" name="pass" required="" maxlength="30" value="<%=p == null?"":p.getPass()%>">
                                </div>

                                <div class="form-group mt-3">
                                    <button class="btn btn-primary">Registrarse</button>
                                    <br>
                                    <a href="index.jsp">¿Ya tienes una cuenta? Iniciar Sesión</a>
                                </div>
                                <input type="hidden" name="accion" value="registrar">
                            </form>
                        </div>
                        <div class="col-sm-6 text-center">
                            <img src="assets/img/fondo_paciente.jpg" class="img-fluid"/>
                        </div>
                    </div>
                </div>
            </div>
            <jsp:include page="includes/Mensajes.jsp" />
    </body>
</html>