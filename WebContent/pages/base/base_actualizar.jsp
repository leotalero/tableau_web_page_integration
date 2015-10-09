<%@ include file="/taglibs.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		$("#btnActualizarCancelarBase").button();
		$("#btnActualizarBase").button();

		$("#fActualizarBase").validate({
			//errorLabelContainer: "#msnBuscarCargue",
			errorClass: "invalid",
			rules: {
				fechamaximagestion:{
					required: true
				}
				
			},
			submitHandler: function(form) {				
				actualizarBase(form);
			}
		});

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
	$("#btnActualizarCancelarBase").click(function(){
		$('#dmDetalleEditarBase').dialog('close');
	});
	
	function actualizarBase(form) {
		
		$.ajax({
			cache: false,
			contentType: 'application/x-www-form-urlencoded; charset=iso-8859-1;', 
            type: $(form).attr('method'),            
            url: $(form).attr('action'),
            data: $(form).serialize(),
            dataType: "text",
            error: function(jqXHR, textStatus, errorThrown) {
                $("#dmMensajeBase").html(jqXHR.statusText);
	        },
            success: function(data) {   
            	/*$('#dmDetalleEditarBase').dialog('close');
            	visualizarDetalleBase('${base.idbase}');*/
            	if(validarEntero(data)){
                	$('#dmDetalleEditarBase').dialog('close');
                	visualizarDetalleBase(data);            		
                } else {
                	
                    $("#dmMensajeBase").html('Error desconocido');					
                }           		 
            }
        });
	}
	
	
	var dates = $("#fActualizarBase [name=fechamaximagestion]").datepicker({
		dateFormat : "dd/mm/yy",
		numberOfMonths: 1,
		minDate : '0',
		dayNamesMin : [ 'Do', 'Lu', 'Ma', 'Mi',
				'Ju', 'Vi', 'Sa' ],
		monthNames : [ 'Enero', 'Febrero', 'Marzo',
				'Abril', 'Mayo', 'Junio', 'Julio',
				'Agosto', 'Septiembre', 'Octubre',
				'Noviembre', 'Diciembre' ],
		monthNamesShort : [ 'Ene', 'Feb', 'Mar',
				'Abr', 'May', 'Jun', 'Jul', 'Ago',
				'Sep', 'Oct', 'Nov', 'Dic' ],
		onSelect: function( selectedDate ) {
					var option = this.id == "from_b_base" ? "minDate" : "maxDate",
						instance = $( this ).data( "datepicker" ),
						date = $.datepicker.parseDate(
							instance.settings.dateFormat ||
							$.datepicker._defaults.dateFormat,
							selectedDate, instance.settings );
					dates.not( this ).datepicker( "option", option, date );
		}
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
<form name="fActualizarBase" id="fActualizarBase" action="${ctx}/page/base">
<input type="hidden" name="action" value="base_actualizar"/>
<input type="hidden" name="idbase" value="${base.idbase}"/>
<table width="100%">
<tr>
<td align="right">
<button type="button" id="btnActualizarCancelarBase" name="btnActualizarCancelarBase" onclick="visualizarDetalleBase(${base.idbase});">Cancelar</button>&nbsp;<button type="submit" id="btnActualizarBase" name="btnActualizarBase">Guardar</button>
</td>
</tr>
</table>
	
<fieldset><legend class="e6">Base</legend>
<table border="0" width="100%" class="caja">
<col style="width: 15%"/>
<col/>
<tr>
<th nowrap="nowrap" style="text-align: left;">Id Base</th>
<td><c:out value="${base.idbase}"/></td>
</tr>
<tr>
<th nowrap="nowrap" style="text-align: left;">Producto</th>
<td><c:out value="${base.producto}"/></td>
</tr>
<tr>
<th nowrap="nowrap" style="text-align: left;">Nombre</th>
<td><c:out value="${base.nombre}"/></td>
</tr>
<tr>
<th nowrap="nowrap" style="text-align: left;">Fecha máxima gestión</th>
<td><input type="text" name="fechamaximagestion" id="fechamaximagestion" value="<fmt:formatDate value='${base.fechamaximagestion}' pattern='dd/MM/yyyy'/>" size="12"/></td>
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
</form>
<br/>
<fieldset><legend class="e6">Cargues</legend>
<table id="detalleBaseCargues" border="0" width="100%" class="tExcel tRowSelect">
<col style="width: 5%"/>
<col style="width: 10%"/>
<col />
<col style="width: 15%"/>
<col style="width: 10%"/>
<col style="width: 9%"/>
<tr>
<th>Id cargue</th>
<th>Tipo</th>
<th>Cargue</th>
<th>Fecha</th>
<th>U. crea</th>
<th>Estado</th>
</tr>
<tbody>
<c:forEach items="${base.cargues}" var="cargue" varStatus="loop">
<tr>
<td><c:out value="${cargue.idcargue}"/></td>
<td><c:out value="${cargue.carguetipo.nombre}"/></td>
<td><c:out value="${cargue.nombre}"/></td>
<td><fmt:formatDate value="${cargue.fechacrea}" pattern="dd/MM/yyyy H:mm"/></td>
<td><c:out value="${cargue.idusuariocrea}"/></td>
<td><c:out value="${cargue.estado}"/></td>
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

