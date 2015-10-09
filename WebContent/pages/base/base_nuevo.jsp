<%@ include file="/taglibs.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		$("[name=btnCrearBase]").button();	
		$("[name=btnCrearCancelarBase]").button();

		$("#fCrearBase").validate({
			//errorLabelContainer: "#msnBuscarCargue",
			errorClass: "invalid",
			rules: {
				nombre:{
					required: true
				},
				productos:{
					required: true
				},
				fechamaximagestion:{
					required: true
				}
				
			},
			
			submitHandler: function(form) {				
				crearBase(form);
			}
		});

	});

	function crearBase(form) {
		$("[name=btnCrearBase]").attr('disabled',true);
		$("[name=btnCrearCancelarBase]").attr('disabled',true);
		$("#dmMensajeBase").dialog("open");
		$("#dmMensajeBase").html(getHTMLLoaging16(' Creando'));
		$.ajax({
			cache: false,
			contentType: 'application/x-www-form-urlencoded; charset=iso-8859-1;', 
            type: $(form).attr('method'),            
            url: $(form).attr('action'),
            data: $(form).serialize(),
            dataType: "text",
            error: function(jqXHR, textStatus, errorThrown) {
            	$("[name=btnCrearBase]").attr('disabled',false);
        		$("[name=btnCrearCancelarBase]").attr('disabled',false);
                $("#dmMensajeBase").html(jqXHR.statusText);
	        },
            success: function(data) {    
            	if(validarEntero(data)){
            		$("#dmMensajeBase").dialog("close");
                	$("#dmNuevoBase").dialog("close");
            		visualizarDetalleBase(data);
                } else {
                	$("[name=btnCrearBase]").attr('disabled',false);
            		$("[name=btnCrearCancelarBase]").attr('disabled',false);
                    $("#dmMensajeBase").html('Error desconocido');					
                }            		 
            }
        });
	}
	
	var dates = $("#fCrearBase [name=fechamaximagestion]").datepicker({
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
				'Sep', 'Oct', 'Nov', 'Dic' ]
		
	});	

	
</script>
<div align="left">

<div>
</div>

<form name="fCrearBase" id="fCrearBase" action="${ctx}/page/base" method="post">

<input type="hidden" name="action" value="base_insertar"/>
<br/>
<fieldset><legend class="e6">Base</legend>
<table border="0" width="100%" class="caja">
<col style="width: 15%"/>
<col/>

<tr>
<th nowrap="nowrap" style="text-align: left;">Nombre</th>
<td><input type="text" name="nombre" value="" style="width: 90%;"/></td>
</tr>

</table>
</fieldset>
<br/>


<div><button type="button" id="btnCrearCancelarBase" name="btnCrearCancelarBase" onclick="$('#dmNuevoBase').dialog('close');">Cancelar</button>&nbsp;&nbsp;&nbsp;<button type="submit" id="btnCrearBase" name="btnCrearBase">Crear</button></div>
</form>

</div>
<div style="padding: 30px 0px;"></div>