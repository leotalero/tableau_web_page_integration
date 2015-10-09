package co.sistemcobro.constelacion.web;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
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

import co.sistemcobro.all.constante.EstadoEnum;
import co.sistemcobro.all.exception.LogicaException;
import co.sistemcobro.all.util.Util;
import co.sistemcobro.constelacion.bean.Base;
import co.sistemcobro.constelacion.constante.BaseTipoBusquedaEnum;
import co.sistemcobro.constelacion.constante.ConstanteConstelacion;
import co.sistemcobro.constelacion.ejb.GestionEJB;
import co.sistemcobro.hermes.bean.UsuarioBean;

/**
 * 
 * @author Jony Hurtado
 * 
 */

@WebServlet(name = "BaseServlet", urlPatterns = { "/page/base" })
public class BaseServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private Logger logger = Logger.getLogger(BaseServlet.class);

	@EJB
	private GestionEJB gestionEJB;

	public BaseServlet() {
		super();
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String action = request.getParameter("action");
		action = action == null ? "" : action;
		try {
			if (action.equals("base_buscar")) {
				buscarBase(request, response);
			} else if (action.equals("base_detalle")) {
				detalleBase(request, response);
			} else if (action.equals("base_principal")) {
				principalBase(request, response);
			} else if (action.equals("base_nuevo")) {
				nuevoBase(request, response);
			} else if (action.equals("base_insertar")) {
				insertarBase(request, response);
			} else if (action.equals("base_eliminar")) {
				eliminarBase(request, response);
			} else if (action.equals("base_activar")) {
				activarBase(request, response);
			} else if (action.equals("base_deshabilitar")) {
				deshabilitarBase(request, response);
			} else if (action.equals("base_editar")) {
					editarBase(request, response);
			}
			

		} catch (Exception e) {
			logger.error(e.toString(), e.fillInStackTrace());
			response.sendError(1, e.getMessage());
		}
	}

	public void activarBase(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		UsuarioBean user = (UsuarioBean) session.getAttribute(ConstanteConstelacion.USUARIO_SESSION);
		try {
			String idbase = request.getParameter("idbase");

			idbase = idbase == null ? "" : idbase.trim();

			Base base = new Base();
			base.setIdbase(Integer.parseInt(idbase));
			base.setIdusuariomod(user.getCodusuario());
			

			Integer resultado = gestionEJB.activarBase(base);
			if (resultado > 0) {
				PrintWriter out = response.getWriter();
				out.println("" + base.getIdbase());
				out.close();
			} else {
				throw new LogicaException("Error al activar la base [" + idbase + "].");
			}

		} catch (LogicaException e) {

			response.sendError(1, e.toString());
		} catch (Exception e) {

			response.sendError(1, e.toString());
		}
	}

	public void eliminarBase(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		UsuarioBean user = (UsuarioBean) session.getAttribute(ConstanteConstelacion.USUARIO_SESSION);
		try {
			String idbase = request.getParameter("idbase");

			idbase = idbase == null ? "" : idbase.trim();

			Base base = new Base();
			base.setIdbase(Integer.parseInt(idbase));
			base.setIdusuariomod(user.getCodusuario());

			Integer resultado = gestionEJB.eliminarBase(base);
			if (resultado > 0) {
				PrintWriter out = response.getWriter();
				out.println("" + base.getIdbase());
				out.close();
			} else {
				throw new LogicaException("Error al eliminar la base [" + idbase + "].");
			}

		} catch (LogicaException e) {

			response.sendError(1, e.toString());
		} catch (Exception e) {

			response.sendError(1, e.toString());
		}
	}

	public void deshabilitarBase(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		UsuarioBean user = (UsuarioBean) session.getAttribute(ConstanteConstelacion.USUARIO_SESSION);
		try {
			String idbase = request.getParameter("idbase");

			idbase = idbase == null ? "" : idbase.trim();

			Base base = new Base();
			base.setIdbase(Integer.parseInt(idbase));
			base.setIdusuariomod(user.getCodusuario());

			Integer resultado = gestionEJB.deshabilitarBase(base);
			if (resultado > 0) {
				PrintWriter out = response.getWriter();
				out.println("" + base.getIdbase());
				out.close();
			} else {
				throw new LogicaException("Error al deshabilitar la base [" + idbase + "].");
			}

		} catch (LogicaException e) {

			response.sendError(1, e.toString());
		} catch (Exception e) {

			response.sendError(1, e.toString());
		}
	}

	public void insertarBase(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		UsuarioBean user = (UsuarioBean) session.getAttribute(ConstanteConstelacion.USUARIO_SESSION);
		try {
			String nombre = request.getParameter("nombre");
			
		
			
			Base base = new Base();
			base.setNombre(nombre);
			base.setIdusuariocrea(user.getCodusuario());
			base.setEstado((short) EstadoEnum.ACTIVO.getIndex());

			Integer resultado = gestionEJB.insertarBase(base);
			if (resultado < 1) {
				throw new Exception("Error al grabar los datos de asignación.");
			}
			PrintWriter out = response.getWriter();
			out.println(base.getIdbase());
			out.close();

		} catch (LogicaException e) {
			logger.error("67876> " + e.toString(), e.fillInStackTrace());
			response.sendError(1, e.toString());
		} catch (Exception e) {
			logger.error("teset> " + e.toString(), e.fillInStackTrace());
			response.sendError(1, e.toString());
		}

	}

	public void detalleBase(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {

			String idbase = request.getParameter("idbase");
			idbase = idbase == null ? "" : idbase.trim();
			Integer idbase_tmp;
			if ("".equals(idbase)) {
				throw new NullPointerException("IDBASE requerida");
			} else {
				idbase_tmp = Integer.parseInt(idbase);
			}
			Base base = gestionEJB.getBasePorId(idbase_tmp);
			
			request.setAttribute("base", base);

			request.getRequestDispatcher("../pages/base/base_detalle.jsp").forward(request, response);

		} catch (Exception e) {
			logger.error(e.toString(), e.fillInStackTrace());
			response.sendError(1, e.getMessage());
		}
	}
	
	public void editarBase(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {

			String idbase = request.getParameter("idbase");
			idbase = idbase == null ? "" : idbase.trim();
			Integer idbase_tmp;
			if ("".equals(idbase)) {
				throw new NullPointerException("IDBASE requerida");
			} else {
				idbase_tmp = Integer.parseInt(idbase);
			}
			Base base = gestionEJB.getBasePorId(idbase_tmp);
			
			request.setAttribute("base", base);

			request.getRequestDispatcher("../pages/base/base_actualizar.jsp").forward(request, response);

		} catch (Exception e) {
			logger.error(e.toString(), e.fillInStackTrace());
			response.sendError(1, e.getMessage());
		}
	}
	
	public void principalBase(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			request.getRequestDispatcher("../pages/base/base_busqueda.jsp").forward(request, response);

		} catch (Exception e) {
			logger.error(e.toString(), e.fillInStackTrace());
			response.sendError(1, e.getMessage());
		}
	}

	public void nuevoBase(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			
			request.getRequestDispatcher("../pages/base/base_nuevo.jsp").forward(request, response);

		} catch (Exception e) {
			logger.error(e.toString(), e.fillInStackTrace());
			response.sendError(1, e.getMessage());
		}
	}

	public void buscarBase(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			String desde = request.getParameter("from");
			String hasta = request.getParameter("to");

			String tipobusqueda = request.getParameter("tipobusqueda");

			tipobusqueda = tipobusqueda == null ? "" : tipobusqueda;
			desde = desde == null ? "" : Util.stringToString(desde.trim(), "dd/MM/yyyy", "yyyyMMdd");
			hasta = hasta == null ? "" : Util.stringToString(hasta.trim(), "dd/MM/yyyy", "yyyyMMdd");

			BaseTipoBusquedaEnum tipobus = BaseTipoBusquedaEnum.get(Integer.parseInt(tipobusqueda));

			if (tipobus.getIndex() == BaseTipoBusquedaEnum.FECHA_CREACION.getIndex()) {

			}

			String[] estados = { EstadoEnum.ACTIVO.getIndexString(), EstadoEnum.DESHABILITADO.getIndexString(), EstadoEnum.ELIMINADO.getIndexString() };
			List<Base> bases = gestionEJB.buscarBases(desde, hasta, tipobus, estados);
			request.setAttribute("bases", bases);

		} catch (Exception e) {
			logger.error(e.toString(), e.fillInStackTrace());
			response.sendError(1, e.getMessage());
		}

		request.getRequestDispatcher("../pages/base/base_lista.jsp").forward(request, response);
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

}
