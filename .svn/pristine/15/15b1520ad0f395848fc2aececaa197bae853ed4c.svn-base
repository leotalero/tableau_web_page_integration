<%@ include file="/taglibs.jsp"%>



<script type="text/javascript">
	$(document)
			.ready(
					function() {
						$('#${ref_tableau}tableauViz').html('');
						initializeViz();
					});
						

	function initializeViz() {
		var placeholderDiv = document.getElementById("${ref_tableau}tableauViz");
		//var url2 = "http://${server}/trusted/${ticket}/views/ProyectoIntranet/Tendencias?:embed=y&:display_count=no&${parametros}";
		var url2 = "http://${server}/trusted/${ticket}/views/${ref_tableau}?display_count=no${parametros}&:refresh=y";
		viz = new tableauSoftware.Viz(placeholderDiv, url2);
		
	alert(url2);
	}				
</script>



<!--  <div  style="position:relative;top:0;left:0;height:100%; border:0;width: 100%" align="center"> -->

<!-- <div  style="position:relative;width: 100%" align="center"> -->

<div  style='position:relative; width: 95%; height: 100%;'>
 <fieldset><legend class="e6">Reporte</legend>

         <div  style="position:relative;height:100%;width: 100%"  id ="${ref_tableau}tableauViz"></div> 

</fieldset>
</div>