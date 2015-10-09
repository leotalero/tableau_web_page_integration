<%@ include file="/taglibs.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {

		$("#dmDetalleCargue").dialog({
			width : 800,
			height : 640,
			modal : true,
			autoOpen : false,
			resizable : true
		});

		$("#dmMensajeCargue").dialog({
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

		$("#fSubirCargue").validate({
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

		$("#fSubirCargue [name=idcarguetipo]").change( function() {
			var data =  $(this).val();
			$(".classtipocargue").hide();
			$("#tipocargue_base").show();
			$("#dimension_area").show();
		});	

	});

	function cargarBase(form) {
		$("#dmMensajeCargue").dialog("open");
		var date = new Date();
		var mensaje = $("#dmMensajeCargue"); 
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
<div id="dmDetalleCargue" title="Gestión"></div>
<div id="dmMensajeCargue" title="Mensaje"></div>

<div align="center">
<div class="td3" style="padding: 10px;">

<div style="padding-bottom: 10px; " align="left">
<span class="enlace" id="lnkUpdateCarguePage">Actualizar página</span>,&nbsp;
</div>

<form name="fSubirCargue" id="fSubirCargue" action="${ctx}/page/archivo"
	enctype="multipart/form-data" method="post">
<table style="width: 100%" class="caja">
	<col style="width: 200;" />
	<col style="width: 200;" />
	<col style="width: 200;" />
	<col />
	<col style="width: 200;" />
	<col style="width: 200;" />
	<tr>
		<th align="right">Tipo Cargue:</th>
		<td><select name="idcarguetipo">
			<option value=""></option>
			<c:forEach items="${carguestipos}" var="carguetipo">
				<option value="${carguetipo.idcarguetipo}"><c:out	value="${carguetipo.nombre}" /></option>
			</c:forEach>
		</select></td>
		
		<th align="right">Datos:</th>
		<td>
		<div id="tipocargue_base"> 
		<b>Base:</b> 
		<select name="idbase">
			<option value=""></option>
			<c:forEach items="${bases}" var="base">
				<option value="${base.idbase}">[<fmt:formatDate
					value="${base.fechacrea}" pattern="dd/MM/yyyy HH:mm" />] <c:out
					value="${base.nombre}" /></option>
			</c:forEach>
		</select>
		<br/>
		</div>
		
		<div id="dimension_area"> 
		<b>Area:</b> 
		<select name="iddimensionarea">
			<option value=""></option>
			<c:forEach items="${areas}" var="area">
				<option value="${area.iddimensionarea}"><c:out	value="${area.nombrearea}" /></option>
			</c:forEach>
		</select>
		<br/>
		</div>
		
		<div id="dimension_tiempotipo"> 
		<b>Tiempo:</b> 
		<select name="iddimensiontiempotipo">
			<option value=""></option>
			<c:forEach items="${tiempotipos}" var="tiempotipo">
				<option value="${tiempotipo.iddimensiontiempotipo}"><c:out	value="${tiempotipo.iddimensiontiempotipo}" /> - <c:out	value="${tiempotipo.nombretiempotipo}" /></option>
			</c:forEach>
		</select>
		<br/>
		</div>
		
		<div id="fecha_de_cargue">    
       <b>Fecha:</b>  
       		<input type="text" name="fechacargue" id="fechacargue" value="" />
       </div>
		
		</td>		
		<th align="right">Archivo:</th>
		<td><input type="file" name="archivo" id="archivobase"></td>
	</tr>	
	<tr>
		<td colspan="6" align="center">
		<button type="submit" id="btnSubirCargue" name="btnSubirCargue">Cargar
		archivo</button>
		</td>
	</tr>
</table>
<div align="center" id="msnSubirCargue"></div>
</form>
<div style="padding: 10px;"  align="left">
<b>Ejemplo de archivos de cargue:</b>
<ul>
<li><a href="${ctx}/archivo/Ejemplo_cargue_hechos_constelacion_201409212028.xlsx" target="_blank">Ejemplo_cargue_hechos_constelacion_201409212028.xlsx</a></li>
</ul>
</div>
<br/>
<div align="left">



</div>
</div>

</div>

<div align="center" id="cajaBuscarCargue"></div>


