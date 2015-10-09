<%@ include file="/taglibs.jsp"%>
<script type="text/javascript">
	$(document)
			.ready(
					function() {

						$("#dmDetalleUsuario").dialog({   				
							width: 900,
							height: 600,   				
							modal: true,
							autoOpen: false,
							resizable: true
						});
						
						$("#dmDetallekpi").dialog({
							width : 800,
							height : 640,
							modal : true,
							autoOpen : false,
							resizable : true
						});

						$("#dmMensajekpi").dialog({
							width : 400,
							height : 200,
							modal : true,
							autoOpen : false,
							resizable : true
						});

						$("#btnBuscarkpi").button();
						$("#btnBuscarkpi").focus();

						$("#fBuscarkpi")
								.validate(
										{
											errorLabelContainer : "#msnBuscarkpi",
											errorClass : "invalid",
											rules : {
												tipobusqueda : {
													required : true
												},
												from : {
													required : function(element) {
														return $(
																"#tipobusquedakpi")
																.val() == 1;
													}
												},
												to : {
													required : function(element) {
														return $(
																"#tipobusquedakpi")
																.val() == 1;
													}
												},idarea : {
													required : true
												},idtiempotipo : {
													required : true
												},idindicador : {
													required : true
												}
											},
											messages : {
												tipobusqueda : {
													required : "Selecione un tipo de búsqueda."
												},
												from : {
													required : "Seleccione una fecha válida."
												},
												to : {
													required : "Seleccione una fecha válida."
												},
												idarea : {
													required : "Selecione un área."
												},
												idtiempotipo : {
													required : "Selecione una frecuencia."
												},
												idindicador : {
													required : "Selecione un indicador."
												},
											},
											submitHandler : function(form) {
												actualizarBusquedaDekpi(form);
											}
										});

						var dates = $("#from_b_kpi, #to_b_kpi")
								.datepicker(
										{
											dateFormat : "dd/mm/yy",
											/*maxDate : '0',*/
											numberOfMonths : 1,
											dayNamesMin : [ 'Do', 'Lu', 'Ma',
													'Mi', 'Ju', 'Vi', 'Sa' ],
											monthNames : [ 'Enero', 'Febrero',
													'Marzo', 'Abril', 'Mayo',
													'Junio', 'Julio', 'Agosto',
													'Septiembre', 'Octubre',
													'Noviembre', 'Diciembre' ],
											monthNamesShort : [ 'Ene', 'Feb',
													'Mar', 'Abr', 'May', 'Jun',
													'Jul', 'Ago', 'Sep', 'Oct',
													'Nov', 'Dic' ],
											onSelect : function(selectedDate) {
												var option = this.id == "from_b_kpi" ? "minDate"
														: "maxDate", instance = $(
														this)
														.data("datepicker"), date = $.datepicker
														.parseDate(
																instance.settings.dateFormat
																		|| $.datepicker._defaults.dateFormat,
																selectedDate,
																instance.settings);
												dates.not(this).datepicker(
														"option", option, date);
											}
										});

						$("#tipobusquedakpi").change(function() {
							var data = $(this).val();
							$(".classtipobusquedakpi").hide();
							if (data == 1) {
								$("#tipobusquedakpi_fecha").show();
							} else if (data == 2) {
								$("#tipobusquedakpi_fecha").show();
								$("#tipobusquedakpi_frecuencia").show();
							} else if (data == 3) {
								$("#tipobusquedakpi_fecha").show();
								$("#tipobusquedakpi_frecuencia").show();
							} else if (data == 4) {
								$("#tipobusquedakpi_fecha").show();
								$("#tipobusquedakpi_frecuencia").hide();
							} else if (data == 5) {
								$("#tipobusquedakpi_fecha").show();
								$("#tipobusquedakpi_frecuencia").show();
							} else if (data == 6) {
								$("#tipobusquedakpi_fecha").show();
							}

						});

					});

	function actualizarBusquedaDekpi(form) {
		$("#cajaBuscarkpi").html(getHTMLLoaging30());
		$("#btnBuscarkpi").attr('disabled', true);
		$
				.ajax({
					cache : false,
					contentType : 'application/x-www-form-urlencoded; charset=iso-8859-1;',
					type : 'POST',
					url : $(form).attr('action'),
					data : $(form).serialize(),
					dataType : "text",
					error : function(jqXHR, textStatus, errorThrown) {
						alert(jqXHR.statusText);
						$("#btnBuscarkpi").attr('disabled', false);
					},
					success : function(data) {
						$("#cajaBuscarkpi").html(data);
						$("#btnBuscarkpi").attr('disabled', false);
					}
				});
	}
</script>
<div id="dmDetallekpi" title="Gestión"></div>
<div id="dmDetalleUsuario" title="Usuario"></div>
<div id="dmMensajekpi" title="Mensaje"></div>
<div align="center">
	<form name="fBuscarkpi" id="fBuscarkpi" action="${ctx}/page/kpi"
		method="post">
		<input type="hidden" name="action" value="kpi_buscar">
		<table width="100%" border="0">
			<tr class="td3" valign="middle">
				<td height="33" align="right" valign="middle" width="200">
					Buscar por: <select name="tipobusqueda" id="tipobusquedakpi">
						<option value="1">KPI por usuarios</option>
				</select> &nbsp;&nbsp; &nbsp;&nbsp;
				</td>
				<td valign="middle" align="left" width="950">
					<div id="tipobusquedakpi_fecha" class="classtipobusquedakpi">

						área: <select name="idarea">
							<option value=""></option>
							<c:forEach items="${areas}" var="area">
								<option value="${area.iddimensionarea}">
									<c:out value="${area.iddimensionarea}" /> - <c:out value="${area.nombrearea}" />
								</option>
							</c:forEach>
						</select>
						
						&nbsp;&nbsp;indicador: <select name="idindicador">
							<option value=""></option>
							<c:forEach items="${indicadores}" var="indicador">
								<option value="${indicador.iddimensionindicador}">
									<c:out value="${indicador.iddimensionindicador}" /> - <c:out value="${indicador.nombreindicador}" />
								</option>
							</c:forEach>
						</select> 


						&nbsp;&nbsp;desde: <input type="text" name="from" id="from_b_kpi" style="width: 70px;"
							value="<fmt:formatDate value="${now}" pattern="dd/MM/yyyy" />" />
							
						&nbsp;&nbsp;hasta: <input type="text" name="to" id="to_b_kpi"  style="width: 70px;"
							value="<fmt:formatDate value="${now}" pattern="dd/MM/yyyy" />" />
							
						&nbsp;&nbsp;frecuencia: <select name="idtiempotipo">
							<option value=""></option>
							<c:forEach items="${tiempotipos}" var="tiempotipo">
								<option value="${tiempotipo.iddimensiontiempotipo}">
									<c:out value="${tiempotipo.iddimensiontiempotipo}" /> - <c:out value="${tiempotipo.nombretiempotipo}" />
								</option>
							</c:forEach>
						</select> 
						
						
						<span id="tipobusquedakpi_frecuencia" class="classtipobusquedakpi"
							style="display: none;"> &nbsp;&nbsp;frecuencia: <select
							name="idfrecuencia">
								<option value="8">Diario</option>
								<option value="6">Mensual</option>
								<option value="4">Anual</option>
						</select>
						</span>


					</div>					

				</td>				
					
				<td valign="middle" align="left">
					<button type="submit" id="btnBuscarkpi" name="classtipobusquedakpi">Buscar</button>
				</td>
			</tr>
		</table>
	</form>
	<div align="center" id="msnBuscarkpi"></div>
</div>
<div align="center" id="cajaBuscarkpi"></div>

