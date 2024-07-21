<script>
    <%
        if (request.getSession().getAttribute("error") != null) {
    %>
    Swal.fire(
            'Error',
            '<%=request.getSession().getAttribute("error")%>',
            'error'
            );
    <%
            request.getSession().setAttribute("error", null);
        }
    %>

    <%
        if (request.getSession().getAttribute("success") != null) {
    %>
    Swal.fire(
            'Mensaje',
            '<%=request.getSession().getAttribute("success")%>',
            'success'
            );
    <%
            request.getSession().setAttribute("success", null);
        }
    %>
</script>