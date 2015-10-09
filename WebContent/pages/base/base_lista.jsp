<%@ include file="/taglibs.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		$("#bases").tablesorter({ 
			debug: false,
			headers: {4:{sorter:'date'}, 6: { sorter: false}},
	        cssHeader: "headerSort",
	        cssAsc: "headerSortUp",
	        cssDesc: "headerSortDown",
	        sortMultiSortKey: "shiftKey"
	    });
		
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
		

		$("#bases").fixedtableheader();

		$("#enviar_correo_base").click(function(){
			num_selecionados = $('input:checkbox[name=idbases]:checked').size();  
			if(num_selecionados>0){
				$("#dmMensajebase").dialog("open"); 
				$("#dmMensajebase").html(getHTMLLoaging16("Enviando correos ... "));
			    $.ajax({
			    	contentType: 'application/x-www-form-urlencoded; charset=iso-8859-1;', 
		            type: 'POST',
		            url: "${ctx}/page/base?action=base_mail",
		            data: $('#fListabases').serialize(),
		            dataType: "text",
		            error: function(jqXHR, textStatus, errorThrown) {
		                $("#dmMensajebase").html("Error: "+jqXHR.statusText);
			        },
		            success: function(data) {
		            	$("#dmMensajebase").html("Las bases seleccionadas han sido enviadas");
		            }	            
		        }); 
			}else{
				alert('Seleccione por lo menos una gestión');
			}
	        
		});
	
	});

	function eliminarBase(idbase) {		
		if(idbase==''){
			
		}else{
			if(confirm('¿Está seguro que desea eliminar la base de código ['+idbase+'], una vez eliminado no será posible volver activarla?')){
				$("#dmMensajeBase").dialog("open");
				$("#dmMensajeBase").html(getHTMLLoaging16(' Eliminando'));
				$.ajax({
					cache: false,
					contentType: 'application/x-www-form-urlencoded; charset=iso-8859-1;', 
		            type: 'post',            
		            url: '${ctx}/page/base?action=base_eliminar&idbase='+idbase,
		            data: '',
		            dataType: "text",
		            error: function(jqXHR, textStatus, errorThrown) {		            	       		
		                $("#dmMensajeBase").html(jqXHR.statusText);
			        },
		            success: function(data) {
		            	if(isNaN(parseInt(data))){
		            		$("#dmMensajeBase").html('Error desconocido');	
		                } else {
		                	$("#dmMensajeBase").dialog("close");
		                	$("#dmDetalleUsuario").dialog("close");
		                	actualizarBusquedaDeBase("#fBuscarBase");
		                }
		            }
		        });	 
			}
		}
	}

	function deshabilitarBase(idbase) {		
		if(idbase==''){
			
		}else{
			if(confirm('¿Está seguro que desea deshabilitar la base de código ['+idbase+']?')){
				$("#dmMensajeBase").dialog("open");
				$("#dmMensajeBase").html(getHTMLLoaging16(' Deshabilitando'));
				$.ajax({
					cache: false,
					contentType: 'application/x-www-form-urlencoded; charset=iso-8859-1;', 
		            type: 'post',            
		            url: '${ctx}/page/base?action=base_deshabilitar&idbase='+idbase,
		            data: '',
		            dataType: "text",
		            error: function(jqXHR, textStatus, errorThrown) {		            	       		
		                $("#dmMensajeBase").html(jqXHR.statusText);
			        },
		            success: function(data) {
		            	if(isNaN(parseInt(data))){
		            		$("#dmMensajeBase").html('Error desconocido');	
		                } else {
		                	$("#dmMensajeBase").dialog("close");
		                	$("#dmDetalleUsuario").dialog("close");
		                	actualizarBusquedaDeBase("#fBuscarBase");
		                }
		            }
		        });	 
			}
		}
	}

	function activarBase(idbase) {		
		if(idbase==''){
			
		}else{
			if(confirm('¿Está seguro que desea activar la base de código ['+idbase+']?')){
				$("#dmMensajeBase").dialog("open");
				$("#dmMensajeBase").html(getHTMLLoaging16(' Activando'));
				$.ajax({
					cache: false,
					contentType: 'application/x-www-form-urlencoded; charset=iso-8859-1;', 
		            type: 'post',            
		            url: '${ctx}/page/base?action=base_activar&idbase='+idbase,
		            data: '',
		            dataType: "text",
		            error: function(jqXHR, textStatus, errorThrown) {		            	       		
		                $("#dmMensajeBase").html(jqXHR.statusText);
			        },
		            success: function(data) {
		            	if(isNaN(parseInt(data))){
		            		$("#dmMensajeBase").html('Error desconocido');	
		                } else {
		                	$("#dmMensajeBase").dialog("close");
		                	$("#dmDetalleUsuario").dialog("close");
		                	actualizarBusquedaDeBase("#fBuscarBase");
		                }
		            }
		        });	 
			}
		}
	}	
	
</script>
<div align="left" >

<c:choose>
		<c:when test="${fn:length(bases) eq 0}">
			<div class="msgInfo1" align="left">No se encontraron coincidencias.</div>
		</c:when>		
		<c:otherwise>
			<div>
			<div id="base_acciones" style="padding: 5px 0px 0px 0px;">			
<%--			<b>Ventas selecionadas:</b>&nbsp;&nbsp;&nbsp;<span class="enlace" id="enviar_correo_base">enviar por correo</span>--%>
			
			<div style="float: right;"><span class="texto1">Ordenar múltiples columnas: (Shift+[clic columna])</span></div>
			</div>
			<div style="clear: both;"></div>
			<div id="divbases" >
			<table width="100%" border="0" id="bases" class="tExcel tRowSelect">
			  <col style="width: 150px;"/>
			  <col style="width: 250px;"/>
			  <col style="width: 150px;"/>
			  <col style="width: 250px;"/>
			  <col style="width: 5px;"/>
			  <thead>
			  <tr class="td3">
<%--			  	<th><input type="checkbox" id="checkAllCorreo" style="cursor: pointer;"> </th>--%>
				<th>Id base</th>
			  	<th>Nombre</th>	
			  	<th>Creado por</th>	  				  	
			  	<th>Fecha crea</th>
			  	<th>Estado</th>
			  	<th>Acción</th>
			  </tr>
			  </thead>
			  <tbody>
			  <c:forEach items="${bases}" var="base" varStatus="loop">
			  <tr>
<%--			  	<td align="center"><input type="checkbox" name="idbases" class="option_correo" value="${base.idbase}"> </td>--%>
			  	<td><c:out value="${base.idbase}"/></td>
			  	<td><c:out value="${base.nombre}"/></td>
			  	<td><c:out value="${base.idusuariocrea}"/></td>
			  	<td><fmt:formatDate value="${base.fechacrea}" pattern="dd/MM/yyyy H:mm"/></td>
			  	<td><c:out value="${base.estado==1?'Eliminado':base.estado==2?'Activo':base.estado==3?'Desactivado':'Indefinido'}"/></td>			  	
			  	<td valign="middle" align="left">
				  	<c:choose>
				  	<c:when test="${base.estado==2}">				  	
				  		<span class="enlace" onclick="visualizarDetalleBase(${base.idbase});" title="Detalle"><img alt="Detalle" src="${ctx}/imagen/control_editar.gif"></span>
					  	&nbsp;&nbsp;
					  	<span class="enlace" onclick="deshabilitarBase(${base.idbase});" title="Deshabilitar"><img alt="Deshabilitar" src="${ctx}/imagen/control_deshabilitar.gif"></span>
				  	</c:when>
				  	
				  	<c:when test="${base.estado==3}">				  	
				  		<span class="enlace" onclick="activarBase(${base.idbase});" title="Activar"><img alt="Activar" src="${ctx}/imagen/control_habilitar.gif"></span>
					  	&nbsp;&nbsp;
					  	<span class="enlace" onclick="eliminarBase(${base.idbase});" title="Eliminar Definitivo"><img alt="Eliminar Definitivo" src="${ctx}/imagen/control_eliminar.gif"></span>
				  	</c:when>
				  	<c:otherwise>
				  	</c:otherwise>	
				  	</c:choose>
				  			  	
			  	</td>
			  </tr>			 
			  </c:forEach>			  
			  </tbody>
			</table>
			</div>
			</div>
	</c:otherwise>
</c:choose> 
</div>