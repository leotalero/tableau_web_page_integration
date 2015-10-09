<%@ include file="/taglibs.jsp"%>
<script type="text/javascript">

	$(document).ready(function() {
				
		$( "#dmDetalleGestion" ).dialog({   				
			width: 800,
			height: 640,   				
			modal: true,
			autoOpen: false,
			resizable: true
		});

		$( "#dmMensajeGestion" ).dialog({   				
			width: 400,
			height: 200,   				
			modal: true,
			autoOpen: false,
			resizable: true
		});

		$("#btnBuscarGestion").button();	
		$("#btnBuscarGestion").focus();			

		$("#fBuscarGestion").validate({
			errorLabelContainer: "#msnBuscarGestion",
			errorClass: "invalid",
			rules: {
				tipobusqueda:{
					required: true
				},
				cedula:{
					required: function(element){ return $("#tipobusquedagestion").val() == 2;} 
				},
				obligacion:{
					required: function(element){ return $("#tipobusquedagestion").val() == 3;} 
				},
				nombrecliente:{
					required: function(element){ return $("#tipobusquedagestion").val() == 4;} 
				},
				from:{
					required: function(element){ return $("#tipobusquedagestion").val() == 1;} 
				},
				to:{
					required: function(element){ return $("#tipobusquedagestion").val() == 1;} 
				}
			},
			messages: {
				tipobusqueda: {
					required: "Selecione un tipo de búsqueda."
				},
				cedula: {
					required: "Ingrese un valor."
				},
				obligacion: {
					required: "Ingrese un valor."
				},
				nombrecliente: {
					required: "Ingrese un valor."
				},
				from: {
					required: "Seleccione una fecha válida."
				},
				to: {
					required: "Seleccione una fecha válida."
				}
			},
			submitHandler: function(form) {				
				actualizarBusquedaDeGestion(form);
			}
		});

		var dates = $("#from_b_gestion, #to_b_gestion").datepicker({
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
					'Sep', 'Oct', 'Nov', 'Dic' ],
			onSelect: function( selectedDate ) {
						var option = this.id == "from_b_gestion" ? "minDate" : "maxDate",
							instance = $( this ).data( "datepicker" ),
							date = $.datepicker.parseDate(
								instance.settings.dateFormat ||
								$.datepicker._defaults.dateFormat,
								selectedDate, instance.settings );
						dates.not( this ).datepicker( "option", option, date );
			}
		});

		$("#tipobusquedagestion").change( function() {
			var data =  $(this).val();
			$(".classtipobusquedagestion").hide();
			if(data==1){
				$("#tipobusquedagestion_todos").show();
			} else if(data==2){
				$("#tipobusquedagestion_cedula").show();
			}else if(data==3){
				$("#tipobusquedagestion_cuenta").show();
			}else if(data==4){
				$("#tipobusquedagestion_nombre").show();
			}
			 
		});	
		
	});

	function visualizarDetalleGestion(idgestion){
		$("#dmDetalleGestion").dialog("open");  
		actualizarDetalleGestion(idgestion);
	}
	
	function actualizarDetalleGestion(idgestion){
		$("#dmDetalleGestion").html(getHTMLLoaging30());
		$.ajax({
			cache: false,
			contentType: 'application/x-www-form-urlencoded; charset=iso-8859-1;', 
            type: 'POST',
            url: "${ctx}/page/gestion?action=gestion_detalle&idgestion="+idgestion,
            dataType: "text",
            error: function(jqXHR, textStatus, errorThrown) {
                alert(jqXHR.statusText);
	        },
            success: function(data) {		                    	                    	
               	$("#dmDetalleGestion").html(data);     
            }
        });
	}

	function actualizarBusquedaDeGestion(form){
		$("#cajaBuscarGestion").html(getHTMLLoaging30()); 
       	$("#btnBuscarGestion").attr('disabled',true);	 				
		$.ajax({
			cache: false,
			contentType: 'application/x-www-form-urlencoded; charset=iso-8859-1;', 
            type: 'POST',
            url: $(form).attr('action'),
            data: $(form).serialize(),
            dataType: "text",
            error: function(jqXHR, textStatus, errorThrown) {
                alert(jqXHR.statusText);
	        },
            success: function(data) {
                $("#cajaBuscarGestion").html(data);
                $("#btnBuscarGestion").attr('disabled',false);	 
            }
        });
	}
	
</script>
<div id="dmDetalleGestion" title="Gestión"></div>
<div id="dmMensajeGestion" title="Mensaje"></div> 
<div align="center">
	<form name="fBuscarGestion" id="fBuscarGestion" action="${ctx}/page/gestion">
	<input type="hidden" name="action" value="gestion_buscar">
      <table style="width:100%">          
        <tr class="td3" valign="middle">
          <td height="33" align="right" valign="middle" width="300">
           	Buscar por: 
           	<select name="tipobusqueda" id="tipobusquedagestion">
           		<option value="1">Fecha de creación</option>
           		<option value="2">Número de identificación</option>
           		<option value="3">Número de cuenta</option>
           		<option value="4">Nombre del cliente</option>
           	</select>  
           	&nbsp;&nbsp; &nbsp;&nbsp;          
         </td>
         <td valign="middle" align="left" width="360">
             <div id="tipobusquedagestion_todos" class="classtipobusquedagestion">   
<%--            <select name="idestadogestion">
            		<option value="0">Todos</option>
            		 <c:forEach items="${gestionestados}" var="gestionestado" >
		            	<option value="${gestionestado.idgestionestado}"><c:out value="${gestionestado.nombre}" /></option>
		            </c:forEach>
            	</select>
            	&nbsp;&nbsp; --%>  
            	desde: <input type="text" name="from" 
				id="from_b_gestion" value="<fmt:formatDate value="${now}" pattern="dd/MM/yyyy" />" />
				&nbsp;&nbsp;hasta: <input type="text" name="to" id="to_b_gestion" 
				value="<fmt:formatDate value="${now}" pattern="dd/MM/yyyy" />" />
            </div>            
            <div id="tipobusquedagestion_cedula" class="classtipobusquedagestion" style="display: none;">
            	<input type="text" name="cedula">
            </div>
            <div id="tipobusquedagestion_cuenta" class="classtipobusquedagestion" style="display: none;">
            	<input type="text" name="obligacion">
            </div>
            <div id="tipobusquedagestion_nombre" class="classtipobusquedagestion" style="display: none;">
            	<input type="text" name="nombrecliente" size="40">
            </div>
            	
           </td>
          
          <td valign="middle" align="left">                       
           <button type="submit" id="btnBuscarGestion" name="btnBuscarGestion">Buscar gestión</button>
          </td>
         </tr>
       </table>
</form> 
<div  align="center" id="msnBuscarGestion" ></div>
</div> 
<div  align="center" id="cajaBuscarGestion">
</div>

