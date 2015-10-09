<%@ include file="/taglibs.jsp"%>
<script type="text/javascript">

	$("#btnEditarCancelarBase").button();
	$("#btnEditarBase").button();
	
	
	
	function visualizarDetalleEditarBase(idbase){
		actualizarDetalleEditarBase(idbase);
	}
	
	function actualizarDetalleEditarBase(idbase){
		$("#dmDetalleEditarBase").html(getHTMLLoaging30());
		$.ajax({
			cache: false,
			contentType: 'application/x-www-form-urlencoded; charset=iso-8859-1;', 
            type: 'POST',
            url: "${ctx}/page/base?action=base_editar&idbase="+idbase,
            dataType: "text",
            error: function(jqXHR, textStatus, errorThrown) {
                alert(jqXHR.statusText);
	        },
            success: function(data) {	
            	$("#dmDetalleBase").dialog("close");
            	$("#dmDetalleEditarBase").dialog("open");
               	$("#dmDetalleEditarBase").html(data);     
            }
        });
	}
	
	function eliminarCargue(estado, idcargue, idbase){
		if(confirm('¿Está seguro que desea eliminar el cargue de código ['+idcargue+'], una vez eliminado no será posible volver activarla?')){
			editarCargue(estado, idcargue, idbase);
		}		
	}
	
	function desactivarCargue(estado, idcargue, idbase){
		if(confirm('¿Está seguro que desea deshabilitar el cargue de código ['+idcargue+']?')){
			editarCargue(estado, idcargue, idbase);
		}		
	}
	
	function editarCargue(estado, idcargue, idbase){
		var baseActiva = idbase;
		
		$.ajax({
			cache: false,
			contentType: 'application/x-www-form-urlencoded; charset=iso-8859-1;', 
            type: 'POST',
            dataType : 'text',
            url: "${ctx}/page/cargue?action=cargue_editar&estado="+estado+"&idcargue="+idcargue,
            error: function(jqXHR, textStatus, errorThrown) {
                alert(jqXHR.statusText);
	        },
            success: function(data) {
            	$("#dmDetalleBase").dialog("close");
            	visualizarDetalleBase(baseActiva);
            }
        });
	}
	
	function sincronizarCargue(idcargue, idbase){
		var baseActiva = idbase;
		if(confirm('Confirme para proceder a sincronizar los contactos a Altitude, recuerde que este proceso puede bloquear momentáneamente la Base de Datos de Gestión. Se recomienda ejecutar este proceso cuando haya la menor cantidad de asesores gestionando.')){
		$("#dmMensajeBase").dialog("open"); 
		$("#dmMensajeBase").html(getHTMLLoaging30());
		$.ajax({
			cache: false,
			contentType: 'application/x-www-form-urlencoded; charset=iso-8859-1;', 
            type: 'POST',
            dataType : 'text',
            url: "${ctx}/page/cargue?action=cargue_sincronizar&idbase="+idbase+"&idcargue="+idcargue,
            error: function(jqXHR, textStatus, errorThrown) {
                //alert(jqXHR.statusText);
                $("#dmMensajeBase").html(""+jqXHR.statusText);
	        },
            success: function(data) {
            	$("#dmMensajeBase").html(data);
            }
        });
		}
	}
	
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
		$("[name=btnEjecutarAsignacion]").button();

		$("#detalleBaseCargues").tablesorter({ 
			debug: false,
	        //headers: {3:{sorter:'datetime'}},
	        cssHeader: "headerSort",
	        cssAsc: "headerSortUp",
	        cssDesc: "headerSortDown",
	        sortMultiSortKey: "shiftKey"
	    });

		$("#detalleBaseCargues").fixedtableheader();

		$("#fEjecutarAsignacion").validate({
			errorLabelContainer : "#msnBuscarPriorizacion",
			errorClass : "invalid",
			rules : {			
			},
			messages : {				
			},
			submitHandler : function(form) {
				ejecutarAsignacion(form);
			}
		});
		
	});

	
</script>
<div align="left">
<c:choose>
		<c:when test="${empty base}">
			<div class="msgInfo1" align="left">No existe la base.</div>
		</c:when>
		<c:otherwise>

<div>
<!--<span class="titulo_h1" title="Id Acuerdo"><b>[#<c:out value="${acuerdo.idacuerdo}"/>]</b></span> &nbsp;&nbsp;-->
<!--<span class="titulo_h1" title="Nombre"><b><c:out value="${acuerdo.cliente.nombre}"/> <c:out value="${acuerdo.cliente.apellido}"/></b></span>-->
</div>

<div>

</div>

<br/>
<form name="fEditarBase" id="fEditarBase" action="${ctx}/page/base">
<table width="100%">
<tr>
</tr>
</table>
</form>	
<fieldset><legend class="e6">Base</legend>
<table border="0" width="100%" class="caja">
<col style="width: 15%"/>
<col/>
<tr>
<th nowrap="nowrap" style="text-align: left;">Id Base</th>
<td><c:out value="${base.idbase}"/></td>
</tr>
<tr>
<th nowrap="nowrap" style="text-align: left;">Nombre</th>
<td><c:out value="${base.nombre}"/></td>
</tr>
<tr>
<tr>
<th nowrap="nowrap" style="text-align: left;">Fecha creación</th>
<td><fmt:formatDate value="${base.fechacrea}" pattern="dd/MM/yyyy H:mm"/></td>
</tr>
<tr>
<th style="text-align: left;">Estado</th>
<td><c:out value="${base.estado}"/></td>
</tr>
</table>
</fieldset>
<br/>
<fieldset><legend class="e6">Cargues</legend>
<table id="detalleBaseCargues" border="0" width="100%" class="tExcel tRowSelect">
<col style="width: 5%"/>
<col style="width: 10%"/>
<col />
<col style="width: 15%"/>
<col style="width: 10%"/>
<col style="width: 7%"/>
<col style="width: 9%"/>
<col style="width: 9%"/>
<tr>
<th>Id cargue</th>
<th>Tipo</th>
<th>Cargue</th>
<th>Fecha</th>
<th>Registros cargados</th>
<th>U. crea</th>
<th>Estado</th>
<th>Accion</th>
</tr>
<tbody>
<c:forEach items="${base.cargues}" var="cargue" varStatus="loop">
<tr>
<td><c:out value="${cargue.idcargue}"/></td>
<td><c:out value="${cargue.carguetipo.nombre}"/></td>
<td><c:out value="${cargue.nombre}"/></td>
<td><fmt:formatDate value="${cargue.fechacrea}" pattern="dd/MM/yyyy H:mm"/></td>
<td><c:out value="${cargue.registroscargados}"/></td>
<td><c:out value="${cargue.idusuariocrea}"/></td>
<td><c:out value="${cargue.estado}"/></td>
<td>
			<c:if test="${cargue.estado == 2}">
				<span class="enlace" title="Deshabilitar" onclick="javascript:desactivarCargue('3',${cargue.idcargue}, ${base.idbase});"><img alt="Deshabilitar" src="${ctx}/imagen/control_deshabilitar.gif"></span>
				&nbsp;
				<c:if test="${cargue.carguetipo.idcarguetipo == 1}">
					<span class="enlace" title="Sincronizar" onclick="javascript:sincronizarCargue(${cargue.idcargue}, ${base.idbase});"><img alt="Sincronizar" src="${ctx}/imagen/control_sincronizar.gif"></span>
				</c:if>
			</c:if>
			<c:if test="${cargue.estado == 3}">
				<span class="enlace" title="Eliminar" onclick="javascript:eliminarCargue('1',${cargue.idcargue}, ${base.idbase});"><img alt="Eliminar" src="${ctx}/imagen/control_eliminar.gif"></span>
				&nbsp;
				<span class="enlace" title="Activar" onclick="javascript:editarCargue('2',${cargue.idcargue}, ${base.idbase});"><img alt="Activar" src="${ctx}/imagen/control_habilitar.gif"></span>
			</c:if>
		</td>
</tr>			 
</c:forEach>
		  
</tbody>
</table>
</fieldset>
<br/>



</c:otherwise>
</c:choose>
</div>
<div style="padding: 30px 0px;"></div>

