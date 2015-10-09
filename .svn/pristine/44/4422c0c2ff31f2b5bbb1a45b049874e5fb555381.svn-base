package co.sistemcobro.constelacion.web;

import java.io.IOException;
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

import co.sistemcobro.all.util.Util;
import co.sistemcobro.constelacion.bean.Gestion;
import co.sistemcobro.constelacion.constante.ConstanteConstelacion;
import co.sistemcobro.constelacion.constante.GestionTipoBusquedaEnum;
import co.sistemcobro.constelacion.constante.GrupoConstelacionEnum;
import co.sistemcobro.constelacion.ejb.GestionEJB;
import co.sistemcobro.hermes.bean.UsuarioBean;

/**
 * 
 * @author Jony Hurtado
 * 
 */
@WebServlet(name = "GestionServlet", urlPatterns = { "/page/gestion" })
public class GestionServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private Logger logger = Logger.getLogger(GestionServlet.class);

	ResourceBundle config = ResourceBundle
			.getBundle(ConstanteConstelacion.FILE_CONFIG_CONSTELACION);

	@EJB
	private GestionEJB ventaEJB;

	public GestionServlet() {
		super();
	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		String action = request.getParameter("action");
		action = action == null ? "" : action;
		try {
			if (action.equals("gestion_buscar")) {
				buscarGestion(request, response);
			} else if (action.equals("gestion_principal")) {
				principalGestion(request, response);
			}

		} catch (Exception e) {
			logger.error(e.toString(), e.fillInStackTrace());
			response.sendError(1, e.getMessage());
		}
	}

	public void principalGestion(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		try {
			request.getRequestDispatcher(
					"../pages/gestion/gestion_busqueda.jsp").forward(request,
					response);

		} catch (Exception e) {
			logger.error(e.toString(), e.fillInStackTrace());
			response.sendError(1, e.getMessage());
		}
	}

	public void buscarGestion(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		UsuarioBean user = (UsuarioBean) session.getAttribute(ConstanteConstelacion.USUARIO_SESSION);

		try {
			String desde = request.getParameter("from");
			String hasta = request.getParameter("to");
			String cedula = request.getParameter("cedula");
			String obligacion = request.getParameter("obligacion");
			String nombrecliente = request.getParameter("nombrecliente");
			String tipobusqueda = request.getParameter("tipobusqueda");

			desde = desde == null ? "" : Util.stringToString(desde.trim(),
					"dd/MM/yyyy", "yyyyMMdd");
			hasta = hasta == null ? "" : Util.stringToString(hasta.trim(),
					"dd/MM/yyyy", "yyyyMMdd");

			cedula = cedula == null ? "" : cedula.trim();
			obligacion = obligacion == null ? "" : obligacion.trim();
			nombrecliente = nombrecliente == null ? "" : nombrecliente.trim();

			tipobusqueda = tipobusqueda == null ? "" : tipobusqueda;
			GestionTipoBusquedaEnum tipobus = GestionTipoBusquedaEnum
					.get(Integer.parseInt(tipobusqueda));

			String valor = "";
			if (tipobus.getIndex() == GestionTipoBusquedaEnum.CEDULA.getIndex()) {
				valor = cedula;
			} else if (tipobus.getIndex() == GestionTipoBusquedaEnum.CUSTCODE
					.getIndex()) {
				valor = obligacion;
			} else if (tipobus.getIndex() == GestionTipoBusquedaEnum.NOMBRECLIENTE
					.getIndex()) {
				nombrecliente = nombrecliente.replace(" ", "%");
				valor = "%" + nombrecliente + "%";
			}

			Integer idusuariocrea = 0;
			if (user.getUsuarioaplicacion().getIdgrupo() == GrupoConstelacionEnum.ASESOR_CONSTELACION
					.getIndex()) {
				idusuariocrea = user.getCodusuario();
			}

			/*List<Gestion> gestiones = ventaEJB.buscarGestiones(desde, hasta,
					idusuariocrea, valor, tipobus);

			request.setAttribute("gestiones", gestiones);*/
		} catch (Exception e) {
			logger.error(e.toString(), e.fillInStackTrace());
			response.sendError(1, e.getMessage());
		}

		request.getRequestDispatcher("../pages/gestion/gestion_lista.jsp")
				.forward(request, response);
	}

	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

}
