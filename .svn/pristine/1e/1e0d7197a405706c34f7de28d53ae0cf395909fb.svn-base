package co.sistemcobro.constelacion.web;

import java.io.IOException;
import java.net.Inet4Address;
import java.util.ArrayList;
import java.util.List;
import java.util.ResourceBundle;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import co.sistemcobro.all.util.TableauServlet;
import co.sistemcobro.constelacion.bean.ClienteFiltro;
import co.sistemcobro.constelacion.bean.Proyecto;
import co.sistemcobro.constelacion.constante.ConstanteConstelacion;
import co.sistemcobro.constelacion.ejb.GestionEJB;
import co.sistemcobro.constelacion.ejb.TableauReportesEJB;
import co.sistemcobro.hermes.bean.GrupoBean;
import co.sistemcobro.hermes.bean.UsuarioBean;
import co.sistemcobro.hermes.constante.Constante;
import co.sistemcobro.hermes.ejb.UsuarioEJB;

/**
 * 
 * @author Leonardo Talero
 * 
 */
@WebServlet(name = "TableauServlet", urlPatterns = { "/page/tableau" })
public class TableauPaginasServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String SPLIT = "£";
	private Logger logger = Logger.getLogger(TableauPaginasServlet.class);

	ResourceBundle config = ResourceBundle.getBundle(ConstanteConstelacion.FILE_CONFIG_CONSTELACION);
	final String userg=config.getString("rrhh.tableau.userG");
	final String wgserver=config.getString("rrhh.tableau.server");
	
	@EJB
	private GestionEJB gestionEJB;
	@EJB
	private TableauReportesEJB tableauEJB;


	@EJB
	private UsuarioEJB usuarioEJB;
	
	public TableauPaginasServlet() {
		super();
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String action = request.getParameter("action");
		action = action == null ? "" : action;
		try {
			if (action.equals("tableau")) {
				tableau(request, response);
			} /*else if (action.equals("kpi_principal")) {
				principalKpi(request, response);
			} else if (action.equals("usuario_detalle")) {
				logger.info("Entra a usuario detalle");
				detalleUsuario(request, response);
			}	 */
		} catch (Exception e) {
			logger.error(e.toString(), e.fillInStackTrace());
			response.sendError(1, e.getMessage());
		}
	}

	public void tableau(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		try {
			UsuarioBean usuariosession = (UsuarioBean) session.getAttribute(Constante.USUARIO_SESSION);
			UsuarioBean usuario = usuarioEJB.getUsuario(usuariosession.getIdusuario());
		
			TableauServlet ts = new TableauServlet();
			// final String user = "SISTEMCOBRO"+"\\"+"dtroncoso";	
			String ref_tableau="";
			String idempleado = request.getParameter("idempleado");
			String idproyecto = request.getParameter("idproyecto");
			if(idempleado!=null && idproyecto!=null){
				
				GrupoBean grupo = usuariosession.getUsuarioaplicacion().getGrupo();
				//GrupoBean grupo = usuariocompleto.getUsuarioaplicacion().getGrupo();
				List<Long> proyectosLong = null;
				if(grupo.getIdgrupo()==1){
					List<Long> proyecto=new ArrayList<Long>();
					proyecto.add(Long.valueOf(idproyecto));
					List<Proyecto> pro = tableauEJB.getProyectosporId(proyecto);
					if(pro!=null){
						
						ref_tableau=pro.get(0).getRef_tabeau();	
					}
					
				}else{
						
				}
				
				 List<ClienteFiltro> clientefiltros = tableauEJB.getClienteFiltroyIdproyecto(usuario.getCodusuario().toString(),Long.valueOf(idproyecto));
					
				 
				 
					String iplocalt = Inet4Address.getLocalHost().getHostAddress();
					String ticket= ts.getTrustedTicket(wgserver, userg, iplocalt);
					//String parametros="Cola=Soporte,Desarrollo";
					if(ticket.equals("-1")){
						throw new Exception("no tiene acceso al servidor ticket no valido");
						
						
					}
					request.setAttribute("ticket", ticket);
					String parametros="";
					 request.setAttribute("server", wgserver);
					 String nombrefiltro="",tempnombrefiltro="";
					 for(ClienteFiltro cf:clientefiltros){
						String nombreproyecto=cf.getProyecto().getNombreproyecto(); 
						ref_tableau=cf.getProyecto().getRef_tabeau(); 
						if(cf.getFiltro().getNombrefiltro()!=null && cf.getValor()!=null ){
							 nombrefiltro=cf.getFiltro().getNombrefiltro(); 
								String valor=cf.getValor(); 
								if(valor.equals("0")){
									
								}else{
									if(nombrefiltro.equals(tempnombrefiltro)){
										parametros+=","+valor;
									}else{
										parametros+="&"+nombrefiltro+"="+valor;
									}
								}
								
									
						}
						
						tempnombrefiltro=nombrefiltro;
						 
					 }
					 
					
					 
					 request.setAttribute("parametros", parametros+"&:refresh=y");
					 request.setAttribute("ref_tableau", ref_tableau);
					request.getRequestDispatcher("../pages/tableau/dashboard.jsp").forward(
							request, response);
			}
			
		} catch (Exception e) {
			logger.error(e.toString(), e.fillInStackTrace());
			response.sendError(1, e.getMessage());
		}
		
	}
	

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	
}
