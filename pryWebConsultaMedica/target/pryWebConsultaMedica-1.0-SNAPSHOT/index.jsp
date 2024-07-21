<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
        <title>Login</title>
        <jsp:include page="includes/Recursos.jsp" />
    </head>
    <body>

        <jsp:include page="includes/Header.jsp" />

        <div class="container container-web-page">
            <h3 class="font-weight-bold poppins-regular text-uppercase">Login</h3>
            <hr>
            <div class="card div-bordered">
                <div class="card-body">
                    <div class="row">
                        <div class="col-sm-6 text-center">
                            <img src="assets/img/fondo_logo.jpeg" alt=""/>
                        </div>

                        <div class="col-sm-6">
                            <form method="post" action="ControlAcceso">
                                <div class="form-group">
                                    <label >Correo elétronico:</label>
                                    <input type="email" class="form-control" name="correo" required=""  >
                                </div>

                                <div class="form-group">
                                    <label >Contraseña:</label>
                                    <input type="password" class="form-control" name="pass" required="" >
                                </div>

                                <div class="form-group mt-3">
                                    <button class="btn btn-primary">Iniciar Sesión</button>
                                    <br>
                                    <a href="PagRegistro.jsp">¿No tienes una cuenta? Registrate Aquí</a>
                                </div>
                                <input type="hidden" name="accion" value="login">
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <jsp:include page="includes/Mensajes.jsp" />
    </body>

</html>