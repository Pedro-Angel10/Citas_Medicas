<%@page import="com.edu.pe.utils.*"%>
<%@page import="com.edu.pe.modelo.*"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
        <title>Reporte</title>
        <jsp:include page="includes/Recursos.jsp" />
    </head>
    <body>
        <jsp:include page="includes/Header.jsp" />
        <%
            ArrayList<Consulta> lista = (ArrayList<Consulta>) request.getAttribute("consultas");
            if (lista == null) {
                lista = new ArrayList<>();
            }
            String estado = request.getAttribute("estado") == null ? "" : (String) request.getAttribute("estado");
        %>

        <div class="container container-web-page">
            <h3 class="font-weight-bold poppins-regular text-uppercase">Reporte Citas por Estado</h3>
            <hr>
            <div class="card div-bordered">
                <div class="card-body">
                    <form action="ControlConsulta" method="get">
                        <div class="row">
                            <div class="col-sm-3">
                                <label>Estado:</label> 
                                <select class="form-control" name="estado">
                                    <option value="">:::Seleccione:::</option>
                                    <option value="Pendiente" ${estado== "Pendiente" ? 'selected' : ''}>Pendiente</option>
                                    <option value="Atendido" ${estado== "Atendido" ? 'selected' : ''}>Atendido</option>
                                </select>
                            </div>
                            <div class="col-sm-9 mt-4" style="text-align: right;">
                                <button type="submit" class="btn btn-primary">Consultar</button>
                                <%
                                    if (lista.size() == 0) {
                                %>
                                <button class="btn btn-danger" disabled="">Exportar PDF</button>
                                <%
                                } else {
                                %>
                                <a href="ControlReporte?accion=generar_reporte&estado=<%=estado%>" class="btn btn-danger"><i class="fa fa-pdf"></i>Exportar PDF</a> 
                                <%
                                    }
                                %>

                            </div>
                            <input type="hidden" name="accion" value="reporte_estado">
                        </div>
                    </form>
                    <hr>
                    <div class="table-responsive mt-3">
                        <table class="table table-bordered table-striped" id="tabla">
                            <thead class="text-center">
                                <tr>
                                    <th># Consulta</th>
                                    <th>Medico</th>
                                    <th>Paciente</th>
                                    <th>Fecha Registro</th>
                                    <th>Fecha Atención</th>
                                    <th>Estado</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    for (Consulta c : lista) {
                                %>
                                <tr class="text-center">
                                    <td><%=c.getNroConsulta()%></td>
                                    <td><%=c.getMedico() == null ? "" : c.getMedico().nomCompletos()%></td>
                                    <td><%=c.getPaciente() == null ? "" : c.getPaciente().getNombres()%></td>
                                    <td><%=c.getFechaRegistro()%></td>
                                    <td><%=c.getFechaAtencion() == null ? "" : c.getFechaAtencion()%></td>
                                    <td><%=c.getEstado()%></td>
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

    <div class="modal fade" id="ModalDetalle" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">Consulta Medica</h5>
                    <button type="button" class="close"  data-mdb-dismiss="modal"  aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label>Medico:</label>
                        <label id="lbMedico" class="form-control">Sin asignación</label>
                    </div>
                    <div class="form-group">
                        <div class="row">
                            <div class="col-sm-6">
                                <label>Fecha Registro:</label>
                                <label id="lbFechaRegistro" class="form-control">Sin asignación</label>
                            </div>

                            <div class="col-sm-6">
                                <label>Fecha Atención:</label>
                                <label id="lbFechaAtencion" class="form-control">Sin asignación</label>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Motivo:</label>
                        <textarea id="lbMotivo" class="form-control" rows="4" disabled=""></textarea>
                    </div>
                    <div class="form-group">
                        <label>Diagnostico:</label>
                        <textarea id="lbDiagnostico" class="form-control" rows="4" disabled=""></textarea>
                    </div>
                    <div class="form-group">
                        <label>Tratamiento</label>
                        <textarea id="lbTratamiento" class="form-control" rows="4" disabled=""></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="CerrarModal()">Cerrar</button>
                </div>
            </div>
        </div>
    </div>
    <script src="assets/js/fnDataTable.js" type="text/javascript"></script>
    <script>
                        function Cargar(medico, fechaReg, fechaAten, motivo, tratamiento, diagnostico) {
                            $("#lbMedico").html(medico === "null" ? "Sin Asignación" : medico);
                            $("#lbFechaRegistro").html(fechaReg);
                            $("#lbFechaAtencion").html(fechaAten === "null" ? "Sin Asignación" : fechaAten);
                            $("#lbMotivo").val(motivo);
                            $("#lbDiagnostico").val(diagnostico === "null" ? "" : diagnostico);
                            $("#lbTratamiento").val(tratamiento === "null" ? "" : tratamiento);

                            $("#ModalDetalle").modal("show");
                        }

                        function CerrarModal() {
                            $("#ModalDetalle").modal("hide");
                        }

                        CargarDatatable("tabla");
    </script>

</html>