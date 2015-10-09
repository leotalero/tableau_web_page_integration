<%@ include file="/taglibs.jsp"%>
<script type="text/javascript">

	$(document).ready(function() {	
		$("#dmMensajeDesvinculacion").dialog({   				
			width: 400,
			height: 200,   				
			modal: true,
			autoOpen: false,
			resizable: true
		});
		
		
// 		if(length(contratorespuestas) > 0){
// 			$('#btnCrearPropiedadCorrespondencia').attr("disabled", false);
// 		}else{
// 			$('#btnCrearPropiedadCorrespondencia').attr("disabled", true);	
// 		}
		
		
		$('#btnCrearPropiedadCorrespondencia').attr("disabled", true);
		
		$("#btnCancelarNuevoFormulario").button();
		$("#btnGuardarEntrevista").button();
		$("#btnCrearPropiedadCorrespondencia").button();
		
		var icons = {
				 header: "ui-icon-circle-triangle-e",
				 activeHeader: "ui-icon-circle-triangle-s"
				 };
		
		 $( "#accordioneditable" ).accordion({
			 heightStyle: "fill",
		      icons: icons,
			collapsible: true
			 });
		 
		 $( "#accordionconrespuestaseditable" ).accordion({
			 heightStyle: "fill",
		      icons: icons,
			collapsible: true
			 });
		
		 $("#accordionconrespuestas").find("input,button,textarea").attr("disabled", "disabled");
		 
		 $("#fDesvinculacionEditar").validate({
				//errorLabelContainer: "#msnBuscarCargue",
				errorClass: "invalid",
				rules: {
					idestadodesvinculacion: {
						required: true,
						
						min:1
					},
					correoCorrespondencia:{
						required: true,
						maxlength:300,
					},
					direccionCorrespondencia:{
						required: true,
						maxlength:300,
					},
					observacionCorrespondencia:{
						required: false,
						maxlength:300
					}
					
				},
				messages: {
					idestadodesvinculacion: {
						required: "Seleccione una opción para el estado de desvinculación",
					},
					correoCorrespondencia:{
						required: "Campo requerido para envio de liquidación.",
						maxlength:"No puede ingresar mas de 300 caráteres.",
					},
					direccionCorrespondencia:{
						required: "Campo requerido para envio de liquidación.",
						maxlength:"No puede ingresar mas de 300 caráteres.",
					},
					observacionCorrespondencia:{
						maxlength:"No puede ingresar mas de 300 caráteres.",
					}
					
				},
				submitHandler: function(form) {				
					guardarDesvinculacion(form);
				}
			});
		 
	});
	function CancelarEditarDesvinculacion() {
		$('#dmNuevoFormulario').dialog('close');
		//AbreCrearform();actualiza pagina
	}
	 
	 function guardarDesvinculacion(form) {
		
		$("[name=btnGuardarEntrevista]").attr('disabled',true);;
		$("#dmMensajeDesvinculacion").dialog("open");
		$("#dmMensajeDesvinculacion").html(getHTMLLoaging16(' Creando'));
		$.ajax({
			cache: false,
			contentType: 'application/x-www-form-urlencoded; charset=iso-8859-1;', 
            type: $(form).attr('method'),            
            url: $(form).attr('action'),
            data: $(form).serialize(),
            dataType: "text",
            error: function(jqXHR, textStatus, errorThrown) {
            	$("[name=btnGuardarEntrevista]").attr('disabled',false);
            	$('#btnCrearPropiedadCorrespondencia').attr("disabled", false);
                $("#dmMensajeDesvinculacion").html(jqXHR.statusText);
	        },
            success: function(data) {    
            	if(validarEntero(data)){
            		
            		$("#dmMensajeDesvinculacion").dialog("close");
                	$("#dmGuardarDesvinculacion").dialog("close");
                	
                	visualizarDesvinculacion(data);
                } else {
                	$("[name=btnGuardarEntrevista]").attr('disabled',false);
                	$('#btnCrearPropiedadCorrespondencia').attr("disabled",false);
                    $("#dmMensajeDesvinculacion").html('Error desconocido');					
                }            		 
            }
        });
	}
	 
	 
	 	/**
		 * Crear Propiedad de Correspondencia.
		 */
		function crearPropiedadCorrespondenciaEmpleado(idempleado,idContrato){
// 			alert('idContrato = '+idContrato);
// 			alert('idEmpleado = '+idempleado);
		 	$("#dmNuevaPropiedadCorrespondencia").dialog("open");
		 	$("#dmNuevaPropiedadCorrespondencia").html(getHTMLLoaging30());
		 	
		 	$.ajax({
		 		cache: false,
		 		contentType: 'application/x-www-form-urlencoded; charset=iso-8859-1;', 
		         type: 'POST',
		         url: "${ctx}/page/empleado?action=empleadoNuevaPropiedadCorrespondencia&idempleado="+idempleado+"&idContrato="+idContrato,
		         dataType: "text",
		         error: function(jqXHR, textStatus, errorThrown) {
		             alert(jqXHR.statusText);
		         },
		         success: function(data) {		                    	                    	
		            	$("#dmNuevaPropiedadCorrespondencia").html(data);     
		         }
		     });
		}

		/**
		 *  
		 */
		function verEditarPropiedadCorrespondenciaEditar(idempleadopropiedad,idempleado,idContrato){
			$("#dmEditarPropiedad").dialog("open");
			$("#dmEditarPropiedad").html(getHTMLLoaging30());
			$.ajax({
				cache: false,
				contentType: 'application/x-www-form-urlencoded; charset=iso-8859-1;', 
		        type: 'POST',
		        url: "${ctx}/page/desvinculacion?action=editarPropiedadeCorrespondencia&idempleado="+idempleado+"&idempleadopropiedad="+idempleadopropiedad+"&idContrato="+idContrato,
		        dataType: "text",
		        error: function(jqXHR, textStatus, errorThrown) {
		            alert(jqXHR.statusText);
		        },
		        success: function(data) {		                    	                    	
		           	$("#dmEditarPropiedad").html(data);     
		        }
		    });
		}
		
		function actualizarPropiedades(idempleado){
			$("#dmPropiedades").html(getHTMLLoaging30());
			$.ajax({
				cache: false,
				contentType: 'application/x-www-form-urlencoded; charset=iso-8859-1;', 
		        type: 'POST',
		        url: "${ctx}/page/empleado?action=empleado_propiedades&idempleado="+idempleado,
		        dataType: "text",
		        error: function(jqXHR, textStatus, errorThrown) {
		            alert(jqXHR.statusText);
		        },
		        success: function(data) {
		        	//	$("#dmMensajeEmpleado").dialog("close");
		            $("#dmPropiedades").html(data);
		        }
		    });
		}
		
		
		
		/**
		 * Crear Propiedad de Correspondencia al editar la encuesta.
		 */
		function verCrearNuevaPropiedadCorrespondenciaEmpleado(idempleado,idContrato){
// 			alert('idContrato = '+idContrato);
// 			alert('idEmpleado = '+idempleado);
		 	$("#dmNuevaPropiedadCorrespondencia").dialog("open");
		 	$("#dmNuevaPropiedadCorrespondencia").html(getHTMLLoaging30());
		 	
		 	$.ajax({
		 		cache: false,
		 		contentType: 'application/x-www-form-urlencoded; charset=iso-8859-1;', 
		         type: 'POST',
		         url: "${ctx}/page/empleado?action=empleadoVerNuevaPropiedadCorrespondencia&idempleado="+idempleado+"&idContrato="+idContrato,
		         dataType: "text",
		         error: function(jqXHR, textStatus, errorThrown) {
		             alert(jqXHR.statusText);
		         },
		         success: function(data) {		                    	                    	
		            	$("#dmNuevaPropiedadCorrespondencia").html(data);     
		         }
		     });
		}
	 	
		
		function verEditarPropiedadCorrespondenciaEdit(idEmpleadoPropiedad,idEmpleado,idContrato){

			$("#dmDesvinculacionEditarPropiedad").dialog("open");
			$("#dmDesvinculacionEditarPropiedad").html(getHTMLLoaging30());
			$.ajax({
				cache: false,
				contentType: 'application/x-www-form-urlencoded; charset=iso-8859-1;', 
		        type: 'POST',
		        url: "${ctx}/page/desvinculacion?action=verEditarPropiedadCorrespondencia&idEmpleadoPropiedad="+idEmpleadoPropiedad+"&idEmpleado="+idEmpleado+"&idContrato="+idContrato,
		        dataType: "text",
		        error: function(jqXHR, textStatus, errorThrown) {
		            alert(jqXHR.statusText);
		        },
		        success: function(data) {		                    	                    	
		           	$("#dmDesvinculacionEditarPropiedad").html(data);     
		        }
		    });
		}
		
		
		/**
		 * Destabilita el registro de empleado_propiead (Correspondencia) por su idempleadopropiedad.
		 */
		function deshabilitarPropiedadCorrespondenciaEdit(idempleadopropiedad,idempleado,idContrato) {
// 			alert('Ajax a deshabilitar propiedad: con idcontrato = '+idContrato);
			if(idempleadopropiedad==''){
				
			}else{
				if(confirm('¿Esta seguro de deshabilitar la propiedad del empleado [${empleado.codempleado}] ${empleado.nombres} ${empleado.apellidos}?')){
					
					$.ajax({
						cache: false,
						contentType: 'application/x-www-form-urlencoded; charset=iso-8859-1;', 
			            type: 'post',            
			            url: '${ctx}/page/desvinculacion?action=deshabilitarPropiedadCorrespondencia&idempleadopropiedad='+idempleadopropiedad+'&idcontrato='+idContrato,
			            data: '',
			            dataType: "text",
			            error: function(jqXHR, textStatus, errorThrown) {       		
			                $("#dmMensajeEmpleado").html(jqXHR.statusText);
				        },
			            success: function(data) {
			            	if(validarEntero(data)){
// 								alert("Data = "+data);
								$("#dmMensajeEmpleado").dialog("close");
			                	$("#dmDesvinculacion").dialog("close");
			                	verDesvinculacion(data);
			                } else {
			                    $("#dmMensajeEmpleado").html('Error desconocido');					
			                }
			            }
			        });	 
				}
			}
		}
		
		/**
		 * Habilita un registro de la relación empleado_propiedad (Correspondencia) por su idempleadopropiedad.
		 */
		function habilitarPropiedadCorrespondenciaEdit(idempleadopropiedad,idempleado,idContrato) {		
			
			if(idempleadopropiedad==''){
				
			}else{
				if(confirm('¿Esta seguro de habilitar la propiedad del empleado [${empleado.codempleado}] ${empleado.nombres} ${empleado.apellidos}?')){
					
					$.ajax({
						cache: false,
						contentType: 'application/x-www-form-urlencoded; charset=iso-8859-1;', 
			            type: 'post',            
			            url: '${ctx}/page/desvinculacion?action=habilitarPropiedadCorrespondencia&idempleadopropiedad='+idempleadopropiedad+'&idContrato='+idContrato,
			            data: '',
			            dataType: "text",
			            error: function(jqXHR, textStatus, errorThrown) {      		
			                $("#dmMensajeEmpleado").html(jqXHR.statusText);
				        },
			            success: function(data) {
			            	if(validarEntero(data)){
			            		alert('Data:'+data);
			            		$("#dmMensajeEmpleado").dialog("close");
			                	$("#dmDesvinculacion").dialog("close");
			                	verDesvinculacion(data);
			                } else {
			                    $("#dmMensajeEmpleado").html('Error desconocido');					
			                }
			            }
			        });	 
				}
			}
		}
		
		/**
		 Esta función oculta y muestra el div de los datos de correspondencia segun lo siguiente:
	 	 - Lo muestra si y solo si el estado de desvinculación es PROCEDER RETIRO. ( Estado 1)
	 	 - Lo oculta si y solo si el estado de desvinculación es RETENER. (Estado 2)
		*/
		function manejarDivCorrespondencia(estadoDesvinculacion){
			if(estadoDesvinculacion == 1){ //Retener
				correoCorrespondencia.disabled = true;
				direccionCorrespondencia.disabled = true;
				observacionCorrespondencia.disabled = true;
				$("#divCorrespondencia").css("display", "none"); 
			}else if(estadoDesvinculacion == 2){//Proceder retiro
				correoCorrespondencia.disabled = false;
				direccionCorrespondencia.disabled = false;
				observacionCorrespondencia.disabled = false;
				$("#divCorrespondencia").css("display", "block"); 
			}
		}
		
</script>

<div align="left">
<c:choose>
		<c:when test="${empty preguntas}">
			<div class="msgInfo1" align="left">No existen preguntas.</div>
		</c:when>
		<c:otherwise>


<div></div>
<form name="fDesvinculacionEditar" id="fDesvinculacionEditar" action="${ctx}/page/desvinculacion" method="post">
<input type="hidden" name="action" value="guardar_Desvinculacion"/>
<input type="hidden" name="idcontrato" value="${contrato.idcontrato}"/>
<input type="hidden" name="idempleado" value="${contrato.idempleado}"/>
<button type="button" id=btnCancelarNuevoFormulario name="btnCancelarNuevoFormulario" onclick="CancelarEditarDesvinculacion();">Cancelar</button>&nbsp;&nbsp;&nbsp;

<br/>

<!------------------------------------
	Información del empleado.         
 ------------------------------------>
<fieldset><legend class="e6">Empleado</legend>
	<table border="0" width="100%" class="caja">
			<col style="width: 15%"/>
			<col/>
			
			
			<tr>
			<th nowrap="nowrap" style="text-align: right;">Tipo de identificación:</th>
			<td><c:out value="${empleado.identificaciontipo.abreviatura}"/> - <c:out value="${empleado.identificaciontipo.tipo}"/></td>
			</tr>
			<tr>
			<th nowrap="nowrap" style="text-align: right;">Num. Identificación:</th>
			<td><c:out value="${empleado.empleadoidentificacion.numeroidentificacion}"/></td>
			</tr>
			
			<tr>
			<th nowrap="nowrap" style="text-align: right;">Nombres:</th>
			<td><c:out value="${empleado.nombres}"/></td>
			</tr>
			<tr>
			<th nowrap="nowrap" style="text-align: right;">Apellidos:</th>
			<td><c:out value="${empleado.apellidos}"/></td>
			</tr>
			<tr>
				<th nowrap="nowrap" style="text-align: right;">Cargo:</th>
				<td><c:out value="${contrato.cargo.nombrecargo}"/></td>
				</tr>
				
				<tr>
				<th nowrap="nowrap" style="text-align: right;">Area:</th>
				<td><c:out value="${contrato.area.nombrearea}"/></td>
				</tr>
				<tr>
				<th nowrap="nowrap" style="text-align: right;">Area asignada:</th>
				<td><c:out value="${contrato.areaasignada.nombrearea}"/></td>
			</tr>
				
	</table>
</fieldset>
<br/>
<!---------------------------------
	Encuesta de desvinculación. 
 ---------------------------------->
<fieldset>
<legend class="e6">Formulario de Estrategia</legend>

	

	
	
	<div id="accordionconrespuestaseditable">
		<c:forEach items="${preguntas}" var="pregunta" varStatus="loop">
					<h3 align="center">${pregunta.pregunta}</h3>
					<div>
					<p>
					
							
					 <c:if test="${pregunta.idpreguntatipo == 2}">
									 
						<table style="border: 2;float:none; ; width: 100%" id="correspondencias" class="tExcel tRowSelect">
									  
							<tr>
							
						
							 <td>
								<textarea  id="respupreguntaeditar${pregunta.idpregunta}" name="respupreguntaeditar${pregunta.idpregunta}" cols=110 rows=8 maxlength="3950" spellcheck="true" >${contrarespuesta.respuesta.texto} </textarea>
							
								<%--  <c:forEach items="${contratorespuestas}" var="contrarespuesta" varStatus="loop">
									<c:if test="${contrarespuesta.respuesta.pregunta.idpregunta==pregunta.idpregunta}">
										<script type="text/javascript">
									
										//document.getElementById("respupreguntaeditar${pregunta.idpregunta}").value="${contrarespuesta.respuesta.texto}"; 
										 document.getElementById("respupreguntaeditar${pregunta.idpregunta}").value="${contrarespuesta.respuesta.texto}"; 
										
										</script>
									 </c:if>
								 </c:forEach> --%>
								 
							</td>
								
							</tr>	
							
						</table>
					 </c:if>
						
					<c:if test="${pregunta.idpreguntatipo == 1}">
					<select style="border: 2;float:none; ; width: 100%" name="idopcion">
					
					<option value=""></option>
						<c:forEach items="${pregunta.opciones}" var="opcion" varStatus="loop">
							<option value="${opcion.idopcion}"><c:out value="${opcion.opcion}"/></option>
						 </c:forEach>
						 
						 
						</select>
					 </c:if>
					
					
					</p>
					</div>
					
		</c:forEach>
					</div>

	
	


<br/>

<!-- --------------------------- -->
<!-- Datos de correspondencia    -->
<!-- --------------------------- -->

<br/>
<!-- Boton de guardar la encuesta -->
<div align="center">
	<button type="submit" id="btnGuardarEntrevista" name="btnGuardarEntrevista">Guardar</button>
</div>

</fieldset>
<br/>

</form>

<br/>
</c:otherwise>
</c:choose>
</div>
<div style="padding: 30px 0px;"></div>
<div id="dmMensajeDesvinculacion" title="Mensaje"></div>
