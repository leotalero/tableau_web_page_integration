package co.sistemcobro.constelacion.web;

import java.io.IOException;
import java.util.List;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import co.sistemcobro.all.constante.EstadoEnum;
import co.sistemcobro.hermes.bean.UsuarioAplicacionBean;
import co.sistemcobro.hermes.constante.AplicacionEnum;
import co.sistemcobro.hermes.ejb.UsuarioEJB;

/**
 * 
 * @author Jony Hurtado
 * 
 */

@WebServlet(name = "UsuarioServlet", urlPatterns = { "/page/usuario" })
public class UsuarioServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private Logger logger = Logger.getLogger(UsuarioServlet.class);

	@EJB
	private UsuarioEJB usuarioEJB;

	public UsuarioServlet() {
		super();
	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		String action = request.getParameter("action");
		action = action == null ? "" : action;
		try {
			if (action.equals("usuario_buscar")) {
				buscarUsuario(request, response);
			}

		} catch (Exception e) {
			logger.error(e.toString(), e.fillInStackTrace());
			response.sendError(1, e.getMessage());
		}
	}

	public void buscarUsuario(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		try {
			String[] estados = { EstadoEnum.ACTIVO.getIndexString() };
			List<UsuarioAplicacionBean> usuariosaplicacion = usuarioEJB
					.getUsuariosPorAplicacion(
							AplicacionEnum.CONSTELACION.getIndex(), estados);

			request.setAttribute("usuariosaplicacion", usuariosaplicacion);

			request.getRequestDispatcher("../pages/usuario/usuario_lista.jsp")
					.forward(request, response);

		} catch (Exception e) {
			logger.error(e.toString(), e.fillInStackTrace());
			response.sendError(1, e.getMessage());
		}

	}

	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

}
