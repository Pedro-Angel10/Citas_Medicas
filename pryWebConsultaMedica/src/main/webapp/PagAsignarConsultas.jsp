<%@page import="com.edu.pe.utils.*"%>
<%@page import="com.edu.pe.modelo.*"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
        <title>Asignar Consultas</title>
        <jsp:include page="includes/Recursos.jsp" />
    </head>
    <body>
        <jsp:include page="includes/Header.jsp" />
        <%
            ArrayList<Consulta> listaCons = (ArrayList<Consulta>) request.getAttribute("consultas");
            ArrayList<Medico> listaMed = (ArrayList<Medico>) request.getAttribute("medicos");
            if (listaCons == null) {
                listaCons = new ArrayList<>();
            }
        %>

        <div class="container container-web-page">
            <h3 class="font-weight-bold poppins-regular text-uppercase">Consultas a Asignar</h3>
            <hr>
            <div class="card div-bordered">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered table-striped" id="tabla">
                            <thead class="text-center">
                                <tr>
                                    <th># Consulta</th>
                                    <th>Paciente</th>
                                    <th>Fecha Registro</th>
                                    <th>Estado</th>
                                    <th>Ver</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    for (Consulta c : listaCons) {
                                %>
                                <tr class="text-center">
                                    <td><%=c.getNroConsulta()%></td>
                                    <td><%=c.getPaciente().getNombres() == null ? "" : c.getPaciente().getNombres()%></td>
                                    <td><%=c.getFechaRegistro()%></td>
                                    <td><%=c.getEstado()%></td>
                                    <td>
                                        <a href="#" class="btn btn-info" onclick="Asignar('<%=c.getPaciente().getNombres()%>',
                                           <%=c.getNroConsulta()%>)">
                                            <i class="fa fa-info-circle"></i>
                                        </a>
                                        &nbsp;
                                        <%
                                            if (c.getImagen() == null || c.getImagen().equals("")) {
                                        %>
                                        <button type="button" class="btn btn-success" disabled=""><i class="fa fa-image"></i></button>

                                        <%
                                        } else {
                                        %>
                                        <a href="<%=Utileria.RUTA_APP_IMAGEN + c.getImagen()%>" target="_blank" class="btn btn-success" title="Ver imagen">
                                            <i class="fa fa-image"></i>
                                        </a>     
                                        <%
                                            }
                                        %>
                                    </td>
                                </tr>
                                <%
                                    }
                                    if (listaCons.size() == 0) {
                                %>
                                <tr>
                                    <td class="text-center" colspan="6">No se encontraron registros.</td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <jsp:include page="includes/Mensajes.jsp" />
    </body>

    <div class="modal fade" id="ModalAsignar" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">Asignar Medico a Consulta</h5>
                    <button type="button" class="close" data-mdb-dismiss="modal"  aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <form>
                    <div class="modal-body">
                        <div class="form-group">
                            <label># Consulta</label>
                            <label id="lbIdConsulta" class="form-control"></label>
                        </div>
                        <div class="form-group">
                            <label>Paciente:</label>
                            <label id="lbPaciente" class="form-control"></label>
                        </div>

                        <div class="form-group">
                            <label>Medico:</label>
                            <select class="form-control" name="idMedico" required="">
                                <option disabled="">:::Seleccione:::</option>
                                <%
                                    for (Medico m : listaMed) {
                                %>
                                <option value="<%=m.getIdMedico()%>"><%=m.getNombres()%></option>
                                <%
                                    }
                                %>
                            </select>
                        </div>

                    </div>
                    <div class="modal-footer">
                        <input type="hidden" name="nroConsulta" id="nroConsulta" value="0">
                        <input type="hidden" name="accion" value="asignarMedico">
                        <button type="submit" class="btn btn-primary" >Asignar</button>
                    </div>
                </form>

            </div>
        </div>
    </div>
    <script src="assets/js/fnDataTable.js" type="text/javascript"></script>               
    <script>
                                            function Asignar(nome, nroConsulta) {
                                                $("#lbPaciente").html(nome);
                                                $("#lbIdConsulta").html(nroConsulta);
                                                $("#nroConsulta").val(nroConsulta);
                                                $("#ModalAsignar").modal("show");
                                            }
                                            CargarDatatable("tabla");
    </script>
</html>