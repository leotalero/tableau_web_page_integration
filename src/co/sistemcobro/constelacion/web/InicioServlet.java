package co.sistemcobro.constelacion.web;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.InetAddress;
import java.util.Date;
import java.util.List;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import sun.misc.BASE64Encoder;
import co.sistemcobro.all.exception.DatoException;
import co.sistemcobro.all.exception.LogicaException;
import co.sistemcobro.all.util.Base64TC;
import co.sistemcobro.hermes.bean.GrupoBean;
import co.sistemcobro.hermes.bean.UsuarioAplicacionBean;
import co.sistemcobro.hermes.bean.UsuarioBean;
import co.sistemcobro.hermes.bean.UsuarioPreguntaSeguraBean;
import co.sistemcobro.hermes.constante.ClaveCambioEnum;
import co.sistemcobro.hermes.constante.Constante;
import co.sistemcobro.hermes.ejb.UsuarioEJB;
import co.sistemcobro.rrhh.bean.EmpleadoBean;
import co.sistemcobro.rrhh.ejb.EmpleadoEJB;
import co.sistemcobro.constelacion.bean.Proyecto;
import co.sistemcobro.constelacion.ejb.TableauReportesEJB;
import co.sistemcobro.constelacion.util.FtpUtilRecursos;

/**
 * 
 * @author Jony Hurtado
 * 
 */
@WebServlet(name = "InicioServlet", urlPatterns = { "/page/inicio" })
public class InicioServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private Logger logger = Logger.getLogger(InicioServlet.class);

	@EJB
	private UsuarioEJB usuarioEJB;

	@EJB
	private EmpleadoEJB empleadoEJB;
	@EJB
	private TableauReportesEJB tableauEJB;
	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public InicioServlet() {
		super();
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
		action = action == null ? "" : action;
		try {

			if (action.equals("ingresar")) {
				ingresar(request, response);
			} else if (action.equals("expirado")) {
				expirado(request, response);
			} else if (action.equals("salir")) {
				salir(request, response);
			}

		} catch (Exception e) {
			logger.error(e.toString(), e.fillInStackTrace());
		}
	}

	public void salir(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		try {
			session = request.getSession(false);
			session.invalidate();
			request.getRequestDispatcher("/index.jsp").forward(request, response);

		} catch (Exception e) {
			logger.error(e.toString(), e.fillInStackTrace());
		}
	}

	public void expirado(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		try {
			session = request.getSession(false);
			session.invalidate();
			request.getRequestDispatcher("/expirado.jsp").forward(request, response);

		} catch (Exception e) {
			logger.error(e.toString(), e.fillInStackTrace());
		}
	}

	public void ingresar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		try {
			UsuarioBean usuariosession = (UsuarioBean) session.getAttribute(Constante.USUARIO_SESSION);
			Integer diasrestacambiarcontrasena=0;
			UsuarioBean usuario = usuarioEJB.getUsuario(usuariosession.getIdusuario());
			List<UsuarioAplicacionBean> usuarioaplicaciones = usuarioEJB.getUsuarioAplicacionPorIdusuarioconLink(usuario.getIdusuario());
			
			if(usuariosession.getUsuarioini()!=null){
				 diasrestacambiarcontrasena = usuariosession.getUsuarioini().getDiasrestacambiarcontrasena();
					
			}
			 List<UsuarioPreguntaSeguraBean> usuariopreguntas = usuarioEJB.getPreguntasPoridUsuario(Long.valueOf(usuariosession.getIdusuario()));
			if (usuariosession == null) {
				// Por seguridad, si la variable de usuariosession es null se envia al login.jsp
				request.getRequestDispatcher("../pages/login.jsp").forward(request, response);
			} else if (usuariosession.getClaveCambio() == ClaveCambioEnum.FUERZA_EL_CAMBIO_DE_CLAVE.getIndex()) {
				// Si el perfil de usuario esta especificado que debe de cambiar la clave se le envia al respectivo jsp.
				logger.info("El usuario tiene activo la política de forzar el cambio de su clave [" + usuariosession.getIdusuario() + ":" + usuariosession.getUsuario() + "] ");
				
				request.setAttribute("directivacontrasena", usuarioEJB.getDirectivaContrasenaPorIdusuario(usuariosession.getIdusuario()));
				request.getRequestDispatcher("../pages/hermes/cambiar_contrasena_expirada.jsp").forward(request, response);
				// } else if (tieneContrasenaExpirada(usuariosession)) {
			} else if (0 == diasrestacambiarcontrasena) {
				// Si la clave del usuario a expirado.
				logger.info("A expirado la vigencia máxima de su clave [" + usuariosession.getIdusuario() + ":" + usuariosession.getUsuario() + "]");
				request.setAttribute("directivacontrasena", usuarioEJB.getDirectivaContrasenaPorIdusuario(usuariosession.getIdusuario()));
				request.getRequestDispatcher("../pages/hermes/cambiar_contrasena_expirada.jsp").forward(request, response);
			} 
			if (usuariopreguntas.size()<3) {
				// Si el usuario no tiene respuestas a 3 preguntas de seguridad
				logger.info("necesita completar las preguntas de seguridad [" + usuariosession.getIdusuario() + ":" + usuariosession.getUsuario() + "]");
				request.setAttribute("preguntas", usuarioEJB.getPreguntasdeSeguridad());
				request.getRequestDispatcher("../portales/hermesseguridad/preguntas_seguridad.jsp").forward(request, response);
			}
			else {
				String idsession = (String)session.getAttribute(Constante.IDSESSION);
				String idaccesohistorico = (String)session.getAttribute(Constante.IDACCESOHISTORICO);
				request.setAttribute("usuarioaplicaciones", usuarioaplicaciones);
				request.setAttribute("idsession", idsession);
				Date fecha = new Date();
				String idaccesohistoricocod = idaccesohistorico+"_"+fecha.getTime();
				Base64TC base64=new Base64TC();
				String cod = base64.codificar(idaccesohistoricocod);
				request.setAttribute("idaccesohistorico", cod);
				String codidentificacion = usuario.getCodigoidentificacion();
				String fotourlencode = getpicture(codidentificacion);
				request.setAttribute("fotourlencode", fotourlencode);
				List<EmpleadoBean> empleados = empleadoEJB.buscarEmpleadosporCodigoIdentificacion(codidentificacion);
				GrupoBean grupo = usuariosession.getUsuarioaplicacion().getGrupo();
				//GrupoBean grupo = usuariocompleto.getUsuarioaplicacion().getGrupo();
				List<Long> proyectosLong = null;
				if(grupo.getIdgrupo()==1){
					proyectosLong = tableauEJB.getAllProyectos();	
					
				}else{
					 proyectosLong = tableauEJB.getProyectosporCodHermes(usuario.getCodusuario().toString());	
				}
				
				EmpleadoBean empleado =new EmpleadoBean();
				if(empleados!=null){
					empleado=empleados.get(0);
					
			
					request.setAttribute("empleado", empleado);
					
				}	
				
				List<Proyecto> proyectos = tableauEJB.getProyectosporId(proyectosLong);
				request.setAttribute("proyectos", proyectos);
				request.getRequestDispatcher("/pages/inicio.jsp").forward(request, response);
				
			}
			//InetAddress localHost = InetAddress.getLocalHost();
			//System.out.println(localHost.getHostAddress());
		     
		} catch (Exception e) {
			logger.error(e.toString(), e.fillInStackTrace());
		
			
		}
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}
	
	
	private String getpicture(String codidentificacion) {
		List<EmpleadoBean> empleados;
		String fotourlencode=null;
		try {
			empleados = empleadoEJB.buscarEmpleadosporCodigoIdentificacion(codidentificacion);
			
			EmpleadoBean empleado =new EmpleadoBean();
			if(empleados!=null){
				empleado=empleados.get(0);
				
				for(int i=0;i<=3;i++){//intenta 3 veces la conexion
					
					try {
						if(FtpUtilRecursos.checkconexion()){
							logger.info("ingresa ftp");
							
							 String rutaftp="imagen/foto";
							 if(empleado.getFotonombre()!=null){
								 
								 
								 byte[] foto = null;
								try {
									logger.info("intenta descargar archivo");
									foto = FtpUtilRecursos.downloadFTP(empleado.getFotonombre(), rutaftp);
									logger.info(" descarga archivo");
								
								} catch (Exception e) {
									
									// TODO Auto-generated catch block
									e.printStackTrace();
								}
								    
						   			if (foto!=null) {///sube doc
						   			 //FileOutputStream fileOuputStream =new FileOutputStream(fileimagen); 
								   	  //  fileOuputStream.write(foto);
								   	  //  fileOuputStream.close();
						   				logger.info("codifca");
								   	 BASE64Encoder encoder = new BASE64Encoder();
									 
							           fotourlencode = encoder.encode(foto);
							          fotourlencode="data:image/jpeg;base64,"+fotourlencode;
						   	    
						   	    
								 }else{
									 
								 }
							 }else{
								 
							 }
							
						
						
						
								break;
									
							}else{
								throw new LogicaException("Error recibiendo archivo de FTP");
							}
					} catch (FileNotFoundException e) {
						// TODO Auto-generated catch block
						logger.info("error archivo"+e);
						e.printStackTrace();
					} catch (IOException e) {
						logger.info("eexeption"+e);
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					}
			}
			
		} catch (DatoException e) {
			logger.info("dato"+e);
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (LogicaException e) {
			logger.info("logical"+e);
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return fotourlencode;
		
	
	
		
	}

}
