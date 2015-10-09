<%@ include file="/taglibs.jsp"%>
<script type="text/javascript">
	$.tablesorter.addParser({ 
	    id: 'datetime', 
	    is: function(s) { 
	        return false; 
	    }, 
	    format: function(s) { 
	    	if (s.length > 0) {
	    		return $.tablesorter.formatFloat(Date.parseExact(s,'dd/MM/yyyy H:mm').getTime());
	    	} else {
	    	    return 0;
	    	}
	    }, 
	    type: 'numeric' 
	});
	
	$(document).ready(function() {
		$("#usuariosaplicacion").tablesorter({ 
			debug: false,
	        headers: {7:{sorter:'datetime'},8:{sorter:'datetime'}},
	        cssHeader: "headerSort",
	        cssAsc: "headerSortUp",
	        cssDesc: "headerSortDown",
	        sortMultiSortKey: "shiftKey"
	    });

		$("#usuariosaplicacion").fixedtableheader();
	
	});
	
</script>
<div align="left" >

<c:choose>
		<c:when test="${fn:length(usuariosaplicacion) eq 0}">
			<div class="msgInfo1" align="left">No se encontraron coincidencias.</div>
		</c:when>		
		<c:otherwise>
			<div>
			<div id="usuarioaplicacion_acciones" style="padding: 5px 0px 0px 0px;">			
<%--			<b>Ventas selecionadas:</b>&nbsp;&nbsp;&nbsp;<span class="enlace" id="enviar_correo_usuarioaplicacion">enviar por correo</span>--%>
			
			<div style="float: right;"><span class="texto1">Ordenar múltiples columnas: (Shift+[clic columna])</span></div>
			</div>
			<div style="clear: both;"></div>
			<div id="divusuariosaplicacion" >
			<table width="100%" border="0" id="usuariosaplicacion" class="tExcel tRowSelect">
			  <col style="width: 20px;"/>
			  <col style="width: 50px;"/>
			  <col style="width: 50px;"/>
			  <col />
			  <col style="width: 55px;"/>
			  <col style="width: 55px;"/>
			  <col style="width: 220px;"/>
			  <col style="width: 120px;"/>
			  <col style="width: 120px;"/>
			  <col style="width: 50px;"/>
			  <thead>
			  <tr class="td3">
			    <th>#</th>
				<th>Codusuario</th>			  	  				  	
			  	<th>Usuario</th>
			  	<th>Nombre</th>
			  	<th>Ext. Altitude</th>
			  	<th>Ext. X-lite</th>
			  	<th>Grupo</th>
			  	<th>Fechacrea</th>
			  	<th>Fechamod</th>
			  	<th>Estado</th>
			  </tr>
			  </thead>
			  <tbody>
			  <c:forEach items="${usuariosaplicacion}" var="usuarioaplicacion" varStatus="loop">
			  <tr style="color: ${usuarioaplicacion.estado==2?'':'red'};">
			  	<td><c:out value="${loop.index+1}"/></td>
			  	<td><c:out value="${usuarioaplicacion.usuario.codusuario}"/></td>			  	
			  	<td><c:out value="${usuarioaplicacion.usuario.usuario}"/></td>	  
			  	<td><c:out value="${usuarioaplicacion.usuario.nombre}"/></td>
			  	<td><c:out value="${usuarioaplicacion.usuario.extensionaltitude==0?'':usuarioaplicacion.usuario.extensionaltitude}"/></td>	
			  	<td><c:out value="${usuarioaplicacion.usuario.extensionxlite==0?'':usuarioaplicacion.usuario.extensionxlite}"/></td>
			  	<td><c:out value="${usuarioaplicacion.grupo.nombre}"/> / <c:out value="${usuarioaplicacion.grupo.grupotipo.nombre}"/></td>
			  	<td><fmt:formatDate value="${usuarioaplicacion.fechacrea}" pattern="dd/MM/yyyy H:mm"/></td>
			  	<td><fmt:formatDate value="${usuarioaplicacion.fechamod}" pattern="dd/MM/yyyy H:mm"/></td>
			  	<td><c:out value="${usuarioaplicacion.estado==2?'Activo':'Deshabilitado'}"/></td>
			  </tr>			 
			  </c:forEach>			  
			  </tbody>
			</table>
			</div>
			</div>
	</c:otherwise>
</c:choose> 
</div>