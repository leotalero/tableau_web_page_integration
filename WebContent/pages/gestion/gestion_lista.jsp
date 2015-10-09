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

	$.tablesorter.addParser({ 
	    id: 'date_ddMMyyyy', 
	    is: function(s) { 
	        return false; 
	    }, 
	    format: function(s) { 
	    	if (s.length > 0) {
	    		return $.tablesorter.formatFloat(Date.parseExact(s,'dd/MM/yyyy').getTime());
	    	} else {
	    	    return 0;
	    	}
	    }, 
	    type: 'numeric' 
	});
	
	$(document).ready(function() {
		$("#gestiones").tablesorter({ 
			debug: false,
	        headers: {9:{sorter:'datetime'}, 10:{sorter:'datetime'}, 14:{sorter:'date_ddMMyyyy'}, 15:{sorter:'datetime'}},
	        cssHeader: "headerSort",
	        cssAsc: "headerSortUp",
	        cssDesc: "headerSortDown",
	        sortMultiSortKey: "shiftKey"
	    });

		$("#gestiones").fixedtableheader();

		$("#checkAllCorreo").click(function(){
		      $(".option_correo").attr('checked', $('#checkAllCorreo').is(':checked'));   
		});
	
	});

	function eliminarGestion(cedula){
		if(confirm("¿Desea eliminar al gestion con cédula "+cedula+"?")){
			$.ajax({
	            type: 'POST',
	            url: "${ctx}/servlet/gestion?action=gestion_eliminar&cedula="+cedula,
	            dataType: "text",
	            success: function(data) {		                    	                    	
	            	actualizarBuscquedaDeGestion('#fBuscarGestion');   
	            }
	        });
		}
	}	
	
</script>
<div align="left" >

<c:choose>
		<c:when test="${fn:length(gestiones) eq 0}">
			<div class="msgInfo1" align="left">No se encontraron coincidencias.</div>
		</c:when>		
		<c:otherwise>
			<div>
			<form name="fListaGestiones" id="fListaGestiones">
			<div id="gestion_acciones" style="padding: 5px 0px 0px 0px;">			
			
			<div style="float: right;"><span class="texto1">Ordenar múltiples columnas: (Shift+[clic columna])</span></div>
			</div>
			<div style="clear: both;"></div>
			<div id="divGestions" >
			<table style="width:100%; border:0;" id="gestiones" class="tExcel tRowSelect">
			  <thead>
			  <tr class="td3">
			  	<th><span title="Id gestión">IG</span></th>
			  	<th><span title="Sucursal">Suc.</span></th>
			  	<th><span title="Campaña">Camp.</span></th>
			  	<th><span title="Easycode">Easy</span></th>
			  	<th><span title="Identificación">Ident.</span></th>
			  	<th>Nombre</th>
			  	<th>Cuenta</th>
			  	<th>Tipificación</th>
			  	<th>Tel. marcado</th>
			  	<th>Fecha inicio</th>
			  	<th>Fecha fin</th>	
			  	<th>Monto real</th>		  	
			  	<th>Valor promesa</th>
			  	<th>Num. cuotas</th>
			  	<th>Fecha última cuota</th>
			  	<th>Fecha agendamiento</th>	
			  	<th>Observación</th>		  	
			  	<th>U. Altitude</th>		  	
			  	
			  </tr>
			  </thead>
			  <tbody>
			  <c:forEach items="${gestiones}" var="gestion" varStatus="loop">
			  <tr>
			  	<td><c:out value="${gestion.idgestion}"/></td>
			  	<td><c:out value="${gestion.idsucursal}"/></td>
			  	<td><span title="${gestion.campanaaltitude}"><c:out value="${gestion.idcampanaaltitude}"/></span></td>
			  	<td><c:out value="${gestion.easycodealtitude}"/></td>
			  	<td><c:out value="${gestion.obligacion.cedula}"/></td>
			  	<td><c:out value="${gestion.obligacion.nombrecliente}"/></td>
			  	<td><c:out value="${gestion.obligacion.cuenta}"/></td>
			  	<td><c:out value="${gestion.tipificacion.concatenado}"/></td>
			  	<td align="right"><c:out value="${gestion.telefonomarcado}"/></td>
			  	<td><fmt:formatDate value="${gestion.fechainicio}" pattern="dd/MM/yyyy H:mm"/></td>
			  	<td><fmt:formatDate value="${gestion.fechafin}" pattern="dd/MM/yyyy H:mm"/></td>
			  	<td align="right"><fmt:parseNumber value="${gestion.montoreal}" pattern="###,###,###"/></td>
			  	<td align="right"><fmt:parseNumber value="${gestion.valorpromesa}" pattern="###,###,###"/></td>
			  	<td><c:out value="${gestion.numcuotas}"/></td>
			  	<td><fmt:formatDate value="${gestion.fechaultimacuota}" pattern="dd/MM/yyyy"/></td>
			  	<td><fmt:formatDate value="${gestion.fechaagendamiento}" pattern="dd/MM/yyyy H:mm"/></td>
			  	<td><c:out value="${gestion.observacion}"/></td>
			  	<td><span title="${gestion.fullnamealtitude}"><c:out value="${gestion.usernamealtitude}"/></span></td>			  	
			  </tr>			 
			  </c:forEach>			  
			  </tbody>
			</table>
			</div>
			</form>
			</div>
	</c:otherwise>
</c:choose> 
</div>