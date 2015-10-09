<%@ include file="/taglibs.jsp"%>
<script type="text/javascript">

	$(document).ready(function() {
				
		$("#dmDetalleBase").dialog({   				
			width: 900,
			height: 600,   				
			modal: true,
			autoOpen: false,
			resizable: true
		});
		
		$("#dmDetalleEditarBase").dialog({   				
			width: 900,
			height: 600,   				
			modal: true,
			autoOpen: false,
			resizable: true
		});
		
		$("#dmMensajeBase").dialog({   				
			width: 400,
			height: 200,   				
			modal: true,
			autoOpen: false,
			resizable: true
		});

		$("#dmNuevoBase").dialog({   				
			width: 900,
			height: 250,   				
			modal: true,
			autoOpen: false,
			resizable: true
		});

		$("#dmEditarBase").dialog({   				
			width: 900,
			height: 600,   				
			modal: true,
			autoOpen: false,
			resizable: true
		});
		
		$("#btnNuevoBase").button();
		$("#btnBuscarBase").button();
		$("#btnBuscarBase").focus();

		$("#btnNuevoBase").click(function(){
			$("#dmNuevoBase").dialog("open");
			$("#dmNuevoBase").html(getHTMLLoaging30());
			$.ajax({
				cache: false,
				contentType: 'application/x-www-form-urlencoded; charset=iso-8859-1;', 
	            type: 'POST',
	            url: "${ctx}/page/base?action=base_nuevo",
	            dataType: "text",
	            error: function(jqXHR, textStatus, errorThrown) {
	                alert(jqXHR.statusText);
		        },
	            success: function(data) {		                    	                    	
	               	$("#dmNuevoBase").html(data);     
	            }
	        });
		});

		$("#fBuscarBase").validate({
			errorLabelContainer: "#msnBuscarBase",
			errorClass: "invalid",
			rules: {
				tipobusqueda:{
					required: true
				},				
				from:{
					required: function(element){ return $("#tipobusquedabase").val() == 1;} 
				},
				to:{
					required: function(element){ return $("#tipobusquedabase").val() == 1;} 
				}
			},
			messages: {
				tipobusqueda: {
					required: "Selecione un tipo de búsqueda."
				},				
				from: {
					required: "Seleccione una fecha válida."
				},
				to: {
					required: "Seleccione una fecha válida."
				}
			},
			submitHandler: function(form) {				
				actualizarBusquedaDeBase(form);
			}
		});

		var dates = $("#from_b_base, #to_b_base").datepicker({
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
						var option = this.id == "from_b_base" ? "minDate" : "maxDate",
							instance = $( this ).data( "datepicker" ),
							date = $.datepicker.parseDate(
								instance.settings.dateFormat ||
								$.datepicker._defaults.dateFormat,
								selectedDate, instance.settings );
						dates.not( this ).datepicker( "option", option, date );
			}
		});	

		$("#tipobusquedabase").change( function() {
			var data =  $(this).val();
			$(".classtipobusquedabase").hide();
			if(data==1){
				$("#tipobusquedabase_creacion").show();
			}
			 
		});		
		
	});

	function visualizarDetalleBase(idbase){
		$("#dmDetalleBase").dialog("open");  
		actualizarDetalleBase(idbase);
	}
	
	function actualizarDetalleBase(idbase){
		$("#dmDetalleBase").html(getHTMLLoaging30());
		$.ajax({
			cache: false,
			contentType: 'application/x-www-form-urlencoded; charset=iso-8859-1;', 
            type: 'POST',
            url: "${ctx}/page/base?action=base_detalle&idbase="+idbase,
            dataType: "text",
            error: function(jqXHR, textStatus, errorThrown) {
                alert(jqXHR.statusText);
	        },
            success: function(data) {		                    	                    	
               	$("#dmDetalleBase").html(data);     
            }
        });
	}


	function actualizarBusquedaDeBase(form){
		$("#cajaBuscarBase").html(getHTMLLoaging30()); 
       	$("#btnBuscarBase").attr('disabled',true);	 				
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
                $("#cajaBuscarBase").html(data);
                $("#btnBuscarBase").attr('disabled',false);	 
            }
        });
	}
	
	function validarEntero(valor){ 
    	valor = parseInt(valor);
     	//Compruebo si es un valor numérico 
     	if (isNaN(valor)) { 
           	 //entonces (no es numero) devuelvo el valor cadena vacia 
           	 return false;
     	}else{ 
           	 //En caso contrario (Si era un número) devuelvo el valor 
           	 return true;
     	} 
	}
</script>
<div id="dmDetalleBase" title="Detalle Base"></div>
<div id="dmDetalleEditarBase" title="Editar Base"></div>
<div id="dmMensajeBase" title="Mensaje"></div>
<div id="dmNuevoBase" title="Nueva Base"></div>
<div id="dmEditarBase" title="Editar Base"></div>
<div align="center">
	<table cellspacing="2"  width="100%" border="0" cellpadding="2">
	<col />
	<col style="width: 5px;"/>
	<col style="width: 200px;"/>	
	<tr  valign="middle">
	<td class="td3">
	<form name="fBuscarBase" id="fBuscarBase" action="${ctx}/page/base">
	<input type="hidden" name="action" value="base_buscar">
      <table width="100%" border="0">          
        <tr class="td3" valign="middle">
          <td height="33" align="right" valign="middle" width="300">
           	Buscar por: 
           	<select name="tipobusqueda" id="tipobusquedabase">
           		<option value="1">Fecha de creación</option>
           	</select>  
           	&nbsp;&nbsp; &nbsp;&nbsp;          
         </td>
         <td valign="middle" align="left" width="360">
	            <div id="tipobusquedabase_creacion" class="classtipobusquedabase">   
	            	<jsp:useBean id="newDateDesde" class="java.util.Date"/>
		      		<jsp:setProperty name="newDateDesde" property="time" value="${newDateDesde.time-15552000000}" />
		      		<%--15552000000 = 1000*180*24*60*60 (180 días)	 --%>
	            	desde: <input type="text" name="from" 
					id="from_b_base" value="<fmt:formatDate value="${newDateDesde}" pattern="dd/MM/yyyy" />" />
					&nbsp;&nbsp;hasta: <input type="text" name="to" id="to_b_base" 
					value="<fmt:formatDate value="${now}" pattern="dd/MM/yyyy" />" />
	            </div> 
            	
           </td>          
          <td valign="middle" align="left">                       
           <button type="submit" id="btnBuscarBase" name="btnBuscarBase">Buscar base</button>
          </td>
         </tr>
       </table>
       </form> 
       </td>
       <td></td>
		<td valign="middle" align="center" class="td3">
		 		<button type="submit" id="btnNuevoBase" name="btnNuevoBase">Nueva base</button>
		</td>
	</tr>
	</table>
	

<div  align="center" id="msnBuscarBase" ></div>
</div> 
<div  align="center" id="cajaBuscarBase">
</div>

