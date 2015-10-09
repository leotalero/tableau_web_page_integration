<%@ include file="/taglibs.jsp"%>
<script type="text/javascript">
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
		<c:forEach items="${frequencias}" var="frecuencia" varStatus="loop">			
			$("#textovertical_fU_${loop.index}").flipv();
		</c:forEach>
		
		
		$("#reportesUsuario").tablesorter({ 
			debug: false,
	        cssHeader: "headerSort",
	        cssAsc: "headerSortUp",
	        cssDesc: "headerSortDown",
	        sortMultiSortKey: "shiftKey"
	    });

		$("#reportesUsuario").fixedtableheader();

		$("#checkAllCorreo").click(function(){
		      $(".option_correo").attr('checked', $('#checkAllCorreo').is(':checked'));   
		});

		$("#enviar_correo_gestion").click(function(){
			num_selecionados = $('input:checkbox[name=idreportes]:checked').size();  
			if(num_selecionados>0){
				$("#dmMensajeReporte").dialog("open"); 
				$("#dmMensajeReporte").html(getHTMLLoaging16("Enviando correos ... "));
			    $.ajax({
			    	contentType: 'application/x-www-form-urlencoded; charset=iso-8859-1;', 
		            type: 'POST',
		            url: "${ctx}/page/gestion?action=gestion_mail",
		            data: $('#fListaReportes').serialize(),
		            dataType: "text",
		            error: function(jqXHR, textStatus, errorThrown) {
		                $("#dmMensajeReporte").html("Error: "+jqXHR.statusText);
			        },
		            success: function(data) {
		            	$("#dmMensajeReporte").html("Las reportes seleccionadas han sido enviadas");
		            }	            
		        }); 
			}else{
				alert('Seleccione por lo menos una gestión');
			}
	        
		});
	
	});

	$(document).ready(function() {
		<c:forEach items="${frequencias}" var="frecuencia" varStatus="loop">			
			$("#textovertical_f_${loop.index}").flipv();
		</c:forEach>
		
		
		$("#reportes").tablesorter({ 
			debug: false,
	        cssHeader: "headerSort",
	        cssAsc: "headerSortUp",
	        cssDesc: "headerSortDown",
	        sortMultiSortKey: "shiftKey"
	    });

		$("#reportes").fixedtableheader();

		if ($("#reporteLlamadaGrafica").length){
			reporteLlamadaGrafica = new Highcharts.Chart({	
				chart : {
			        renderTo: 'reporteLlamadaGrafica',
			        defaultSeriesType: 'line',
			        height: 380
				}, 
				title: {
			        text: 'Gráfica de Llamadas' 
			    }, 
			    tooltip: {
			        formatter: function() {
		                   return '<b>'+ this.series.name +'</b><br/>'+
		                   '<b>'+this.x +': '+'</b>'+ this.y ;
		        	}
		      	}, 
		      	credits: {
			        enabled: false
			    }, 
			    exporting: {
			        enabled: false
			    },
		      	legend: {
		            layout: 'vertical',
		            align: 'right',
		            verticalAlign: 'middle',
		            borderWidth: 0
		         },
		     	yAxis: {
			        title: {
			            text: 'Número de llamadas'
			        }
			    }, 
			    xAxis: {
				    title: {
			            text: 'Días de la Semana'
			        },
			        categories: [${categoria}]
				},
				series: [${series}]
		
			});	
		}
	
	});
	function visualizarDetalleUsuario(idusuario,desde,hasta){
		$("#dmDetalleUsuario").dialog("open");  
		$.ajax({
			cache: false,
			contentType: 'application/x-www-form-urlencoded; charset=iso-8859-1;', 
            type: 'POST',
            dataType : 'text',
            url: "${ctx}/page/kpi?action=usuario_detalle&idusuario="+idusuario+"&desde="+desde+"&hasta="+hasta,
            error: function(jqXHR, textStatus, errorThrown) {
                alert(jqXHR.statusText);
	        },
            success: function(data) {
            	$("#dmDetalleUsuario").html(data);   
            }
        });

	
	}

	
</script>
<div align="left" >
<table width="100%">
<tr>
</tr>
</table>
</form>	
<fieldset><legend class="e6">Usuario</legend>
<table border="0" width="100%" class="caja">
<col style="width: 15%"/>
<col/>
<tr>
<th nowrap="nowrap" style="text-align: left;">Id Usuario</th>
<td><c:out value="${usuario.iddimensionusuario}"/></td>
</tr>
<tr>
<th nowrap="nowrap" style="text-align: left;">Nombre</th>
<td><c:out value="${usuario.nombre}"/></td>
</tr>
<tr>
<tr>
<th nowrap="nowrap" style="text-align: left;">Número identificación  
</th>
<td><c:out value="${usuario.numeroidentificacion}"/></td>
</tr>
</table>
</br>

<c:choose>
		<c:when test="${fn:length(datos) eq 0}">
			<div class="msgInfo1" align="left">No se encontraron coincidencias.</div>
		</c:when>		
		<c:otherwise>
			<div>
			<form name="fListaReportes" id="fListaReportes">
			<div id="gestion_acciones" style="padding: 5px 0px 0px 0px;">			
<%--			<b>Ventas selecionadas:</b>&nbsp;&nbsp;&nbsp;<span class="enlace" id="enviar_correo_gestion">enviar por correo</span>--%>
			
			<div style="float: right;"><span class="texto1">Ordenar múltiples columnas: (Shift+[clic columna])</span></div>
			</div>
			<div style="clear: both;"></div>
			<div id="divReportes" >
			<table width="100%" border="0" id="reportesUsuario" class="tExcel tRowSelect">
			  <thead>
			  <tr class="td3">
			  	<th>Área</th>
			  	<th>Indicador</th>
			  	<c:forEach items="${frequencias}" var="frecuencia" varStatus="loop">
					<th class="cabecera" colspan="3"><span id='textovertical_fU_${loop.index}' class="270-degrees" ><fmt:formatDate value="${frecuencia}" pattern="${formato}"/></span></th>
				</c:forEach>
			  	<th colspan="3">Total</th>
			  </tr>
			  </thead>
			  <tbody>

			  
			  <c:forEach items="${datos}" var="dato" varStatus="loop">
			  <tr>
			  	<td><c:out value="${dato.area.nombrearea}"/></td>
			  	<td><c:out value="${dato.indicador.nombreindicador}"/></td>
			  	<c:forEach items="${dato.valores}" var="valor">
			  		<c:choose>
				  		<c:when test="${not empty valor.porcentaje}">
							<td align="right" title="Meta: <fmt:formatNumber type="number" pattern="${dato.indicador.formatovalormeta}" value="${valor.valormeta}"/>" >
								<fmt:formatNumber type="number" pattern="${dato.indicador.formatovalorindicador}" value="${valor.valorindicador}"/>
							</td>
							<td align="right">
								<fmt:formatNumber type="number" pattern="${dato.indicador.formatovalorporcentaje}" value="${valor.porcentaje}"/>%
							</td>
							<td align="center">
								<img alt="<c:out value="${valor.semaforo}"/>" src="${ctx}/imagen/<c:out value="${valor.semaforo}"/>" style="width: 14px; height: 14px;">
							</td>
						</c:when>		
						<c:otherwise>
							<td align="right">	
							</td>
							<td align="right">	
							</td>
							<td align="center">
							</td>
						</c:otherwise>
					</c:choose>
				</c:forEach>	
					
				<c:choose>
				  		<c:when test="${not empty dato.totalporcentaje}">	  	
						  	<th align="right" title="Meta: <fmt:formatNumber type="number" pattern="${dato.indicador.formatovalormeta}" value="${dato.totalvaloresMeta}" />"><fmt:formatNumber type="number" pattern="${dato.indicador.formatovalorindicador}" value="${dato.totalvaloresIndicador}" /></th>			  	
						  	<th align="right"><fmt:formatNumber type="number" pattern="${dato.indicador.formatovalorporcentaje}" value="${dato.totalporcentaje}" />%</th>
						  	<th align="center"><img alt="<c:out value="${dato.totalsemaforo}"/>" src="${ctx}/imagen/<c:out value="${dato.totalsemaforo}"/>" style="width: 14px; height: 14px;"></th>	
					  	</c:when>	
					  	<c:otherwise>
							<td align="right">	
							</td>
							<td align="right">	
							</td>
							<td align="center">
							</td>
						</c:otherwise>
				</c:choose>
			  </tr>		 
			  </c:forEach>			  
			  </tbody>
			  <tfoot>

			</table>
			</div>
			</form>
			</div>
			
			<!--<div align="left" style="padding: 10px;"></div>
			<div id="reporteLlamadaGrafica" title="Gráfico"></div>  -->
	</c:otherwise>
</c:choose> 

</fieldset>
</div>