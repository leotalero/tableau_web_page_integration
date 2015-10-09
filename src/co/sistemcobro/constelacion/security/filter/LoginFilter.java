package co.sistemcobro.constelacion.security.filter;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Random;

import javax.ejb.EJB;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.SerializationUtils;
import org.apache.log4j.Logger;
import org.apache.log4j.MDC;

import co.sistemcobro.all.constante.EstadoEnum;
import co.sistemcobro.all.exception.DatoException;
import co.sistemcobro.all.exception.LogicaException;
import co.sistemcobro.all.exception.SessionException;
import co.sistemcobro.all.util.Base64TC;
import co.sistemcobro.hermes.bean.AccesoHistorial;
import co.sistemcobro.hermes.bean.AplicacionBean;
import co.sistemcobro.hermes.bean.ContrasenaHistorial;
import co.sistemcobro.hermes.bean.DirectivaRed;
import co.sistemcobro.hermes.bean.Red;
import co.sistemcobro.hermes.bean.Sessionserial;
import co.sistemcobro.hermes.bean.UsuarioBean;
import co.sistemcobro.hermes.constante.AccesoTipoEnum;
import co.sistemcobro.hermes.constante.AplicacionEnum;
import co.sistemcobro.hermes.constante.Constante;
import co.sistemcobro.hermes.ejb.UsuarioEJB;

import com.octo.captcha.module.servlet.image.SimpleImageCaptchaServlet;

/**
 * @author
 * 
 */

@WebFilter(filterName = "LoginFilter", urlPatterns = { "/page/*" })
public class LoginFilter implements Filter {

	private Logger logger = Logger.getLogger(LoginFilter.class);

	@EJB
	private UsuarioEJB usuario;

	public void destroy() {
		logger.info("destory");
		

	}

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
	    Boolean flagvalidaciondesession=false;
		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse resp = (HttpServletResponse) response;
		resp.setHeader("Pragma", "No-cache");
		resp.setHeader("Cache-Control", "no-cache");
		resp.setDateHeader("Expires", 1); 
		HttpSession session = req.getSession();
		Integer ina = session.getMaxInactiveInterval();
		Integer random = (Integer)session.getAttribute("random");
		if(random==null){
			 Random randomGenerator = new Random();
			  int randomNum = randomGenerator.nextInt((1000 - 1) + 1) + 1;
			 session.setAttribute("random", randomNum);
		}
		Long ct = session.getCreationTime();
		Date horacreacion = new Date(ct);
		Long lat = session.getLastAccessedTime();
		Date ultimoacceso = new Date(lat);
		
		AplicacionBean aplicacion = (AplicacionBean) req.getServletContext().getAttribute(Constante.APLICACION_SESSION);
		AplicacionBean aplicaciontemp;
		
		try {
			aplicaciontemp = usuario.getAplicacionPorIdaplicacion(aplicacion.getIdaplicacion());
			req.setAttribute("favicon", aplicaciontemp.getFavicon());
		} catch (LogicaException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		MDC.put("aplicacion", aplicacion.getNombreexterno());
		String ip= req.getRemoteAddr();
		String publicip = request.getParameter("publicip");
		MDC.put("ip",ip);
		
		 Cookie[] cookies = req.getCookies();
		 String  sessionId="";
     
		 if (cookies != null)
        {
            for (Cookie cook : cookies)
            {
                if ("JSESSIONID".equalsIgnoreCase(cook.getName()))
                {
                   sessionId = cook.getValue();
                    break;
                }
            }
        }
		String idsession = req.getParameter("idsession");
		session.setAttribute(Constante.IDSESSION, idsession);
		String idaccesohistorico =(String)session.getAttribute(Constante.IDACCESOHISTORICO);
		
			
		
		 
			if(idaccesohistorico==null){
				String idaccesohistoricocod = req.getParameter("ahui");
				if(idaccesohistoricocod!=null){
					Base64TC base64=new Base64TC();
					String temp = base64.decodificar(idaccesohistoricocod);
					String[] parts = temp.split("_");
					idaccesohistorico =parts[0];
				}
				
			}else{
			session.setAttribute(Constante.IDACCESOHISTORICO, idaccesohistorico);
			}
		Sessionserial sessionserial = null;
		if(idaccesohistorico!=null){
			AccesoHistorial accesohistorial;
					try {
						accesohistorial = usuario.getAccesoHistorialUltimosPorId(Long.valueOf(idaccesohistorico));
							if(accesohistorial!=null && accesohistorial.getEstadosession()==EstadoEnum.ACTIVO.getIndex()){
									sessionserial = (Sessionserial) SerializationUtils.deserialize( accesohistorial.getSessionserializada());
									
							}
							 if(sessionserial!=null){
								 session = req.getSession();
									//session=sessionserial.getSession();
								 String useragent = req.getHeader("User-Agent");
								 String useragentsesionserial = sessionserial.getUseragent();
								 String ipsesionserial = sessionserial.getIp();
									if(useragent.equals(useragentsesionserial) && ip.equals(ipsesionserial)){
										// session.setAttribute(Constante.USUARIO_SESSION,sessionserial.getExiste());
										 flagvalidaciondesession=true;	
										 session.setAttribute(Constante.IDACCESOHISTORICO, String.valueOf(accesohistorial.getIdaccesohistorial()));
											
									}else{
										
									}
								 
									
						 }else{
							 session.removeAttribute(Constante.USUARIO_SESSION);
						}
						
					} catch (NumberFormatException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} catch (DatoException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} catch (LogicaException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
			}
		
		try {

			/* TODO: Boorar este codigo temporal */
			aplicacion.setDirectivaacceso(usuario.getDirectivaAccesoPorIdaplicacion(aplicacion.getIdaplicacion()));

			//if (session != null && !session.isNew()) {
			if (session != null) {
				UsuarioBean user = (UsuarioBean) session.getAttribute(Constante.USUARIO_SESSION);
				
				if (null == user) {
					 String u=null;
					 String c=null;
					if(sessionserial!=null && flagvalidaciondesession==true){
						 u = sessionserial.getUsuario().getUsuario();
						 c = sessionserial.getUsuario().getClave();

					}else{
						int numerorandom=Integer.valueOf(req.getParameter("random"));
						if(random==numerorandom){
							u = req.getParameter("usuario");
							c = req.getParameter("clave");
							  req.removeAttribute("usuario");
							 req.removeAttribute("clave");
						}
						
					 //req.
					}
					
					Integer iscaptchaactive = (Integer) session.getAttribute(Constante.CAPTCHA_ACTIVADO);
					if (iscaptchaactive == null) {
						iscaptchaactive = 0;
					}

					if (null != u && null != c) {
						// Se valida el captcha
						final String captcha = req.getParameter("captcha");
						if (aplicacion.getDirectivaacceso().getValidarcaptchaenlogin() == 1 || iscaptchaactive == 1) {
							if (captcha == null) {
								logger.info("[usuario:" + u + ", idaplicacion:" + aplicacion.getIdaplicacion() + "] Digite el texto de la imagen (captcha).");
								throw new SessionException("Digite el texto de la imagen.");
							} else {
								boolean captchaPassed = SimpleImageCaptchaServlet.validateResponse(req, captcha);
								if (!captchaPassed) {
									logger.info("[usuario:" + u + ", idaplicacion:" + aplicacion.getIdaplicacion() + "] El texto de la imagen (captcha) es incorrecto.");
									throw new SessionException("El texto de la imagen es incorrecto.");
								}
							}
						}

						UsuarioBean usuariotemporal = usuario.getUsuarioPorUsuario(u);
						if (null != usuariotemporal) {

							// Se valida si el usuario esta bloqueado
							if (aplicacion.getDirectivaacceso().getNumintentosbloqueo() > 0) {
								List<AccesoHistorial> bloqueos = usuario.getAccesoHistorialUltimosPorIdsusuarioYTipo(usuariotemporal.getIdusuario(), AccesoTipoEnum.ACCCESO_BLOQUEADO.getIndex(), 1);
								if (bloqueos.size() > 0) {
									AccesoHistorial accesoHistorial = bloqueos.get(0);
									ContrasenaHistorial contrasenaHistorial = usuario.getContrasenaHistorialUltimoPorIdsusuario(usuariotemporal.getIdusuario());
									req.setAttribute("bloqueotiempotrascurrido", accesoHistorial.getTiempotrascurrido());
									logger.info("[usuario:" + u + ", idaplicacion:" + aplicacion.getIdaplicacion() + "] BLOQUEO: Tiempotrascurrido: " + accesoHistorial.getTiempotrascurrido() + ", Tiempomaximobloqueo: " + aplicacion.getDirectivaacceso().getTiempomaximobloqueo());
									if (aplicacion.getDirectivaacceso().getTiempomaximobloqueo() > 0) {
										if ((accesoHistorial.getTiempotrascurrido() <= aplicacion.getDirectivaacceso().getTiempomaximobloqueo())) {
											if (contrasenaHistorial.getFechacrea().before(accesoHistorial.getFechacrea())) {
												logger.info("[usuario:" + u + ", idaplicacion:" + aplicacion.getIdaplicacion() + "] Usuario bloqueado.");
												throw new SessionException("["
														+ u
														+ "] Usuario bloqueado."
														+ (aplicacion.getDirectivaacceso().getVerbloqueotiempotrascurrido() == 1 && (aplicacion.getDirectivaacceso().getTiempomaximobloqueo() - accesoHistorial.getTiempotrascurrido()) > 0 ? " Intente en  "
																+ (aplicacion.getDirectivaacceso().getTiempomaximobloqueo() - accesoHistorial.getTiempotrascurrido()) + " minutos." : ""));
											}
										}
									}
								}
							}

							/* Registramos el acceso */
							AccesoHistorial accesohistorial = new AccesoHistorial();
							accesohistorial.setIdusuario(usuariotemporal.getIdusuario());
							accesohistorial.setIdaplicacion(aplicacion.getIdaplicacion());
							accesohistorial.setIdaccesotipo(AccesoTipoEnum.VERIFICANDO.getIndex());
							accesohistorial.setIdusuariocrea(usuariotemporal.getCodusuario());
							accesohistorial.setEstado(EstadoEnum.ACTIVO.getIndex());
							usuario.insertaAccesoHistorial(accesohistorial);

							UsuarioBean activo = usuario.isUsuario(u, c);
							if (null != activo) {
								/* Seteamos la variable iscaptchaactive a 0 */
								session.setAttribute(Constante.CAPTCHA_ACTIVADO, 0);

								/* Validamos si tiene acceso a la apliaci�n */
								UsuarioBean existe = usuario.tieneAccesoAplicacionConInit(activo.getIdusuario(), AplicacionEnum.get(aplicacion.getIdaplicacion()));
								//validamos la directiva de red ip publica
								if(existe==null){
									throw new SessionException("El usuario no tiene acceso a la aplicaci�n");
									
								}
								
								Integer iddirectivared = existe.getUsuarioaplicacion().getIddirectivared();
								String ipacomparar;
								if(publicip==null ){
									ipacomparar=ip;
								}else{
									if(publicip.equals("")){
										ipacomparar=ip;
									}else{
										ipacomparar=publicip;
									}
								}
								
								if(iddirectivared!=0 && iddirectivared!=4 ){
									DirectivaRed directivared = usuario.getDirectivaRedporId(iddirectivared);
									List<Red> redes = usuario.getRedpporIdDirectiva(directivared.getIddirectivared());
									directivared.setRedes(redes);
									String flagentrada = null;
									for(Red x:redes){
										String ipdered = x.getIp();
										ipdered=ipdered.replace("*", "");
										if(ipdered.equals("*")){
											flagentrada="si";
											break;
										}else{
											ipdered=ipdered.replace("*", "");
											
											
											if(ipacomparar.matches("(?i)"+ipdered+".*")){
												flagentrada="si";
												break;
											}else{
												flagentrada="no";
												
											}
										}
										
									}
									if(flagentrada.equals("no")){
										throw new SessionException("Desde la ip:["+ipacomparar+"] no tiene permitido el acceso a la aplicaci�n");
										
									}
									
									
								}else{
									Integer iddirectivaredgrupo = existe.getUsuarioaplicacion().getGrupo().getIddirectivared();
									DirectivaRed directivaredgrupo = usuario.getDirectivaRedporId(iddirectivaredgrupo);
									
									List<Red> redes = usuario.getRedpporIdDirectiva(iddirectivaredgrupo);
								
									directivaredgrupo.setRedes(redes);
									String flagentrada = null;
									for(Red x:redes){
										String ipdered = x.getIp();
										if(ipdered.equals("*")){
											flagentrada="si";
											break;
										}else{
											ipdered=ipdered.replace("*", "");
											
											
											if(ipacomparar.matches("(?i)"+ipdered+".*")){
												flagentrada="si";
												break;
											}else{
												flagentrada="no";
												
											}
										}
										
										
									}
									
									if(flagentrada.equals("no")){
										throw new SessionException("Desde la ip:["+ipacomparar+"] no tiene permitido el acceso a la aplicaci�n");
										
									}
									
									
									
							}
								
								MDC.put("usuario", u);
								if (null != existe) {
									session.setAttribute(Constante.USUARIO_SESSION, existe);
									logger.info("Usuario cargado a " + aplicacion.getNombreexterno() + " [idusuario:" + existe.getIdusuario() + ":" + existe.getUsuario() + "]");
									/* Actualizamos el registro de acceso satisfactorio */
									accesohistorial.setIdaccesotipo(AccesoTipoEnum.ACCCESO_CONCEDIDO.getIndex());
									accesohistorial.setIdusuariomod(usuariotemporal.getCodusuario());
									String idaccesohistoricodeotraaplicacion = (String)session.getAttribute(Constante.IDACCESOHISTORICO);
									if(idaccesohistoricodeotraaplicacion==null){
										
									}else{
										accesohistorial.setCodigosessiondb(idaccesohistoricodeotraaplicacion);
									}
									usuariotemporal.setClave(c);
									 sessionserial=new Sessionserial();
									sessionserial.setUsuario(usuariotemporal);
									sessionserial.setExiste(existe);
									 int a = session.getMaxInactiveInterval();
									sessionserial.setIp(ip);
									String useragent = req.getHeader("User-Agent");
									sessionserial.setUseragent(useragent);
									byte[] data = SerializationUtils.serialize(sessionserial);
									accesohistorial.setSessionserializada(data);
									accesohistorial.setEstadosession(EstadoEnum.ACTIVO.getIndex());
									usuario.actualizarAccesoHistorial(accesohistorial);
									session.setAttribute(Constante.IDACCESOHISTORICO, String.valueOf(accesohistorial.getIdaccesohistorial()));
									//usuario.actualizarAccesoHistorial(accesohistorial);
								} else {
									/* Actualizamos el registro de acceso fallido */
									accesohistorial.setIdaccesotipo(AccesoTipoEnum.NO_CUENTA_CON_PERMISO.getIndex());
									accesohistorial.setIdusuariomod(usuariotemporal.getCodusuario());
									usuario.actualizarAccesoHistorial(accesohistorial);
									logger.info("Usuario no cuenta con permisos para la aplicaci�n [usuario:" + u + ", idaplicacion:" + aplicacion.getIdaplicacion() + "]");
									throw new SessionException("[" + u + "] No cuenta con permisos para el uso de esta aplicaci�n.");
								}
							} else {
								/* Actualizamos el registro de acceso fallido */
								accesohistorial.setIdaccesotipo(AccesoTipoEnum.AUTENTICACION_FALLIDA.getIndex());
								accesohistorial.setIdusuariomod(usuariotemporal.getCodusuario());
								usuario.actualizarAccesoHistorial(accesohistorial);

								/* Se analiza los intentos fallidos */
								List<AccesoHistorial> intentosfallidos = usuario.getAccesoHistorialUltimosPorIdsusuarioYTipo(usuariotemporal.getIdusuario(), AccesoTipoEnum.AUTENTICACION_FALLIDA.getIndex(), aplicacion.getDirectivaacceso().getNumintentosbloqueo());
								List<AccesoHistorial> intentosfallidosdesdeelultimoingreso = usuario.getAccesoHistorialUltimosPorIdsusuarioTipoYBase(usuariotemporal.getIdusuario(), AccesoTipoEnum.AUTENTICACION_FALLIDA.getIndex(), AccesoTipoEnum.ACCCESO_CONCEDIDO.getIndex());
								Integer intentosfallidosporperiodo = 0;

								if (aplicacion.getDirectivaacceso().getNumintentosbloqueo() > 0) {
									if (intentosfallidosdesdeelultimoingreso.size() <= aplicacion.getDirectivaacceso().getNumintentosbloqueo()) {
										intentosfallidosporperiodo = intentosfallidosdesdeelultimoingreso.size();
									} else {
										intentosfallidosporperiodo = intentosfallidosdesdeelultimoingreso.size() % aplicacion.getDirectivaacceso().getNumintentosbloqueo();
									}
								} else {
									intentosfallidosporperiodo = intentosfallidosdesdeelultimoingreso.size();
								}
								logger.info("[usuario:" + u + ", idaplicacion:" + aplicacion.getIdaplicacion() + "] LOGUEO: intentos fallidos desde el ultimo ingreso:" + intentosfallidosdesdeelultimoingreso.size() + ", intentos fallidos por periodo:" + intentosfallidosporperiodo
										+ ", Numintentosbloqueo: " + aplicacion.getDirectivaacceso().getNumintentosbloqueo());

								/* Se activa el captcha por intentos fallidos seg�n configuraci�n */
								if (aplicacion.getDirectivaacceso().getValidarcaptchenintentosfallidos() > 0) {
									if (intentosfallidosporperiodo >= aplicacion.getDirectivaacceso().getValidarcaptchenintentosfallidos()) {
										session.setAttribute(Constante.CAPTCHA_ACTIVADO, 1);
									}
								}

								/* Se verifica si se debe bloquear al usuario */
								if (aplicacion.getDirectivaacceso().getNumintentosbloqueo() > 0) {
									if (intentosfallidos.size() == aplicacion.getDirectivaacceso().getNumintentosbloqueo()) {
										AccesoHistorial accesobloqueo = new AccesoHistorial();
										accesobloqueo.setIdusuario(usuariotemporal.getIdusuario());
										accesobloqueo.setIdaplicacion(aplicacion.getIdaplicacion());
										accesobloqueo.setIdaccesotipo(AccesoTipoEnum.ACCCESO_BLOQUEADO.getIndex());
										accesobloqueo.setIdusuariocrea(usuariotemporal.getCodusuario());
										accesobloqueo.setEstado(EstadoEnum.ACTIVO.getIndex());
										usuario.insertaAccesoHistorial(accesobloqueo);
										throw new SessionException("[" + u + "] Usuario bloqueado por l�mite de intentos.");
									}
								}
								throw new SessionException("[" + u + "] Usuario y/o clave incorrecta." + (aplicacion.getDirectivaacceso().getVerintentosfallidos() == 1 ? " Intento " + (intentosfallidosporperiodo) + "." : ""));
							}

						} else {
							throw new SessionException("[" + u + "] Usuario y/o clave incorrecta.");
						}

					} else {
						throw new Exception("Nueva sessi�n");
					}
				} else {
					MDC.put("usuario", user.getUsuario());
					logger.info("Empleado ya se encuentra cargado en " + aplicacion.getNombreexterno());
				}
				chain.doFilter(request, response);
			} else {
				throw new Exception("Su sesi�n caduco, por favor vuelva a loguearse");
			}
		} catch (SessionException e) {
			logger.error(e.getMessage());
			req.setAttribute("errorTitle", e.getTitle());
			req.setAttribute("errorMsg", e.getMessage());
			 Random randomGenerator = new Random();
			  int randomNum = randomGenerator.nextInt((1000 - 1) + 1) + 1;
			 session.setAttribute("random", randomNum);
			req.setAttribute("random", randomNum);
			req.getRequestDispatcher("../pages/login.jsp").forward(req, resp);
		} catch (Exception e) {
			logger.error(e.getMessage());
			req.setAttribute("errorTitle", "Exception");
			req.setAttribute("errorMsg1", "Su sesi�n caduco, por favor vuelva a loguearse");
			  Random randomGenerator = new Random();
			  int randomNum = randomGenerator.nextInt((1000 - 1) + 1) + 1;
			 session.setAttribute("random", randomNum);
			req.setAttribute("random", randomNum);
			
			req.getRequestDispatcher("../pages/login.jsp").forward(req, resp);
		}

	}
	public void init(FilterConfig filterConfig) throws ServletException {

	}

	

}
