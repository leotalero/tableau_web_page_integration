<%@ include file="/taglibs.jsp"%>
<script type="text/javascript">

	$(document).ready(function() {
		$("#dmNuevoFormulario").dialog({
			width : 800,
			height : 640,
			modal : true,
			autoOpen : false,
			resizable : true
		});
		
		$("[name=btnNuevoFormulario]").button();
		
		
		

		$("#dmMensajeFormulario").dialog({
			width : 400,
			height : 200,
			modal : true,
			autoOpen : false,
			resizable : true
		});

		var dates = $("#fechacargue").datepicker({
			dateFormat : "dd/mm/yy",
			maxDate : '0',
			numberOfMonths: 1,
			dayNamesMin : [ 'Do', 'Lu', 'Ma', 'Mi',
					'Ju', 'Vi', 'Sa' ],
			monthNames : [ 'Enero', 'Febrero', 'Marzo',
					'Abril', 'Mayo', 'Junio', 'Julio',
					'Agosto', 'Septiembre', 'Octubre',
					'Noviembre', 'Diciembre' ],
			monthNamesShort : [ 'Ene', 'Feb', 'Mar',
					'Abr', 'May', 'Jun', 'Jul', 'Ago',
					'Sep', 'Oct', 'Nov', 'Dic' ]
		});
		
		$("#btnSubirCargue").button();

		$("#lnkUpdateCarguePage").click(function() {
			recargarTabOpcion($("#tabsOpciones").tabs( "option", "selected" ));
		});

		$("#FfomularioEstrategia").validate({
			//errorLabelContainer: "#msnBuscarCargue",
			errorClass: "invalid",
			rules: {
				idbase:{
					required: true
				},
				idcarguetipo:{
					required: true
				},
				archivo:{
					required: true
				},
				iddimensionarea:{
					required: true
				},
				iddimensiontiempotipo:{
					required: true
				},
				fechacargue:{
					required: true
				}
			},
			messages: {
				idbase: {
					required: "Seleccione una base."
				},
				idcarguetipo: {
					required: "Seleccione un tipo de cargue."
				},			
				archivo: {
					required: "Seleccione un archivo."
				},
				iddimensionarea:{
					required: "Seleccione un area."
				},
				iddimensiontiempotipo:{
					required: "Seleccione un tipo de tiempo."
				},
				fechacargue:{
					required: "Ingrese una fecha."
				}
			},
			submitHandler: function(form) {				
				//actualizarBusquedaDeCargue(form);
				cargarBase(form);
			}
		});

		$("#FfomularioEstrategia [name=idcarguetipo]").change( function() {
			var data =  $(this).val();
			$(".classtipocargue").hide();
			$("#tipocargue_base").show();
			$("#dimension_area").show();
		});	

	});
	function CrearFormulario() {		
		
		visualizarCrearformulario();		

	}


	function visualizarCrearformulario(){
	$("#dmNuevoFormulario").dialog("open");  
	AbreCrearform();
	}


	function AbreCrearform() {		

	$("#dmNuevoFormulario").html(getHTMLLoaging30());
	$.ajax({
		cache: false,
		contentType: 'application/x-www-form-urlencoded; charset=iso-8859-1;', 
	    type: 'POST',
	    url: "${ctx}/page/formulario?action=crear_formulario",
	    dataType: "text",
	    error: function(jqXHR, textStatus, errorThrown) {
	        alert(jqXHR.statusText);
	    },
	    success: function(data) {	
	    	
	       	$("#dmNuevoFormulario").html(data);     
	    }
	});
	}
	
	
	
	function cargarBase(form) {
		$("#dmMensajeFormulario").dialog("open");
		var date = new Date();
		var mensaje = $("#dmMensajeFormulario"); 
	    var iframe_nombre = "upload_iframe_"+date.getTime();
	    var iframe_id = iframe_nombre;

	    var iframe = document.createElement("iframe");
	    iframe.setAttribute("id", iframe_nombre);
	    iframe.setAttribute("name", iframe_nombre);
	    iframe.setAttribute("width", "0");
	    iframe.setAttribute("height", "0");
	    iframe.setAttribute("border", "0");
	    iframe.setAttribute("style", "width: 0; height: 0; border: none;");
	    // Add to document...

	    form.parentNode.appendChild(iframe);

	    window.frames[iframe_nombre].name = iframe_nombre;

	    iframeId = document.getElementById(iframe_id);

	    // Add event...
	    var eventHandler = function () {
				if (iframeId.detachEvent) iframeId.detachEvent("onload", eventHandler);
	            else iframeId.removeEventListener("load", eventHandler, false);
	            // Message from server...
	            if (iframeId.contentDocument) {		            
	                content = iframeId.contentDocument.body.innerHTML;
	            } else if (iframeId.contentWindow) {
	                content = iframeId.contentWindow.document.body.innerHTML;
	            } else if (iframeId.document) {
	                content = iframeId.document.body.innerHTML;
	            }
	            mensaje.html('<div>'+content+'</div>'); 
	            $("#archivobase").val("");
	            // Del the iframe...
	            setTimeout('iframeId.parentNode.removeChild(iframeId)', 250);
	    };
	    if (iframeId.addEventListener) iframeId.addEventListener("load", eventHandler, true);
	    if (iframeId.attachEvent) iframeId.attachEvent("onload", eventHandler);
	    // Set properties of form...
	    form.setAttribute("target", iframe_nombre);
	    //form.setAttribute("action", action_url);
	    //form.setAttribute("method", "post");
	    //form.setAttribute("enctype", "multipart/form-data");
	    //form.setAttribute("encoding", "iso-8859-1");

	    // Submit the form...
	    form.submit();
	 
	    mensaje.html(getHTMLLoaging16("Cargando ... ")); 
	}
</script>
<div id="dmNuevoFormulario" title="Formulario Estrategia"></div>
<div id="dmMensajeFormulario" title="Mensaje"></div>

<div align="center">
<div class="td3" style="padding: 10px;">

<div style="padding-bottom: 10px; " align="left">
<span class="enlace" id="lnkUpdateCarguePage">Actualizar página</span>,&nbsp;
</div>
<%-- <c:if test="${empleado.estado==2}">
			
</c:if>	 --%>
<button type="button" id="btnNuevoFormulario" name="btnNuevoFormulario" onclick="CrearFormulario(${empleado.idempleado});">Nuevo</button>&nbsp;&nbsp;&nbsp;
<form name="FfomularioEstrategia" id="FfomularioEstrategia" action="${ctx}/page/formulario"
	 method="post">
	 <fieldset><legend class="e6">Historico</legend>
		<table style="width:100%" border="0" id="historico" class="tExcel tRowSelect">
			  
			  <col style="width: 20px;"/>
			  <col style="width: 20px;"/>
		 	  <col style="width: 20px;"/>
			  <col style="width: 30px;"/>
			  <col style="width: 50px;"/>
			  <col style="width: 50px;"/>
			 
			
			  <thead>
			  <tr class="td3">
			    <th>#</th>			    
				<th><span title="Código de usuario">Código de usuario</span></th>
				<th><span title="Estado usuario">Estado</span></th>
				<th><span title="Actual">Documento actual</span></th>
				<th><span title="Tipo de Documento">Tipo de documento</span></th>	
			  	<th><span title="Número de identificación">Identificación</span></th>
			  				  				  	
			  	<th>Nombres</th>
			  	<th>Apellidos</th>
			  	<th>Fecha nacimiento</th>
			  	<th>Fechacrea</th>
			  	<th>Usuario crea.</th>
			   	<th>Fechamod</th>	
			  	<th>Usuario mod.</th>			  	
			  	<th>Acciones</th>
			  </tr>
			  </thead>
			  <tbody>
			  <c:forEach items="${empleados}" var="empleado" varStatus="loop">
			  <tr style="color: ${empleado.estado==2?'':'red'};">
			  	<td><c:out value="${loop.index+1}"/></td>			  		
			  	<td><c:out value="${empleado.codempleado}"/></td>
			  	<td><c:out value="${empleado.estado==2?'+':usuario.estado==3?'.':'-'}"/></td>
			  	<td><c:out value="${empleado.empleadoidentificacion.actual==1?'+':empleado.empleadoidentificacion.actual==3?'.':'-'}"/></td>  
			 	<td><c:out value="${empleado.identificaciontipo.abreviatura}"/> - <c:out value="${empleado.identificaciontipo.tipo}"/></td>	
			  	<td><c:out value="${empleado.empleadoidentificacion.numeroidentificacion}"/></td>	
			  	<td><c:out value="${empleado.nombres}"/> </td>
			    <td><c:out value="${empleado.apellidos} "/></td>
			    <td><fmt:formatDate value="${empleado.fechanacimiento}" pattern="dd/MM/yyyy"/></td>
			  	<td><fmt:formatDate value="${empleado.fechacrea}" pattern="dd/MM/yyyy H:mm"/></td>
			  	<td><c:out value="${empleado.idusuariocrea} "/></td>
			 	<td><fmt:formatDate value="${empleado.fechamod}" pattern="dd/MM/yyyy H:mm"/></td>	
			  	<td><c:out value="${empleado.idusuariomod} "/></td>		  		  	
			  	<td valign="middle" align="center"><span class="enlace" onclick="visualizarDetalleEmpleado(${empleado.idempleado});" title="Detalle"><img alt="Detalle" src="${ctx}/imagen/ico-editar.gif"></span></td>	
			  </tr>			 
			  </c:forEach>			  
			  </tbody>
			</table>
</fieldset>

</form>

<div align="left">



</div>
</div>

</div>

<div align="center" id="cajaBuscarCargue"></div>


