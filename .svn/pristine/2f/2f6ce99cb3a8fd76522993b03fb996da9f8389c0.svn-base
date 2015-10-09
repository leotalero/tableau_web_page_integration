package co.sistemcobro.constelacion.web;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.ResourceBundle;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import co.sistemcobro.all.constante.EstadoEnum;
import co.sistemcobro.all.exception.LogicaException;
import co.sistemcobro.altitude.bean.PhContactBean;
import co.sistemcobro.altitude.ejb.PhContactEJB;
import co.sistemcobro.constelacion.bean.Cargue;
import co.sistemcobro.constelacion.constante.ConstanteConstelacion;
import co.sistemcobro.constelacion.ejb.GestionEJB;
import co.sistemcobro.hermes.bean.UsuarioAplicacionBean;
import co.sistemcobro.hermes.constante.AplicacionEnum;
import co.sistemcobro.hermes.ejb.UsuarioEJB;

/**
 * 
 * @author Jony Hurtado
 * 
 */
@WebServlet(name = "CargueServlet", urlPatterns = { "/page/cargue" })
public class CargueServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private Logger logger = Logger.getLogger(CargueServlet.class);

	ResourceBundle config = ResourceBundle.getBundle(ConstanteConstelacion.FILE_CONFIG_CONSTELACION);
	
	
	@EJB
	private GestionEJB gestionEJB;

	@EJB
	private UsuarioEJB usuarioEJB;
	
	@EJB
	private PhContactEJB phContactEJB;

	public CargueServlet() {
		super();
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String action = request.getParameter("action");
		action = action == null ? "" : action;
		try {
			if (action.equals("cargue_principal")) {
				principalCargue(request, response);
			} else if (action.equals("cargue_editar")) {
            	cargueEditar(request, response);
            }

		} catch (Exception e) {
			logger.error(e.toString(), e.fillInStackTrace());
			response.sendError(1, e.getMessage());
		}
	}

	public void principalCargue(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {

		
			request.setAttribute("bases", gestionEJB.getBases());
			request.setAttribute("carguestipos", gestionEJB.getCarguesTipos());
			request.setAttribute("areas", gestionEJB.getDimensionArea());
			request.setAttribute("tiempotipos", gestionEJB.getDimensionTiempoTipo());
			
			String[] estados = {EstadoEnum.ACTIVO.getIndexString()};
			List<UsuarioAplicacionBean> usuariosaplicacion = usuarioEJB.getUsuariosPorAplicacion(AplicacionEnum.CONSTELACION.getIndex(), estados);

			request.setAttribute("usuariosaplicacion", usuariosaplicacion);

			request.getRequestDispatcher("../pages/cargue/cargue_principal.jsp").forward(request, response);

		} catch (Exception e) {
			logger.error(e.toString(), e.fillInStackTrace());
			response.sendError(1, e.getMessage());
		}
	}
   

    
    /**
     * metodo que permite editar un cargue existente
     * @param request
     * @param response
     * @throws ServletException
     * @throws IOException
     */    
    public void cargueEditar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String estado = request.getParameter("estado");
            estado = estado == null ? EstadoEnum.ACTIVO.getIndexString() : estado.trim();

            String idcargue = request.getParameter("idcargue");
            idcargue = idcargue == null ? "" : idcargue.trim();
            
            Cargue cargue = null;
            
            if ("".equals(idcargue)) {
                throw new NullPointerException("Id cargue requerido.");
            } else {
            	cargue = new Cargue();
            	cargue.setIdcargue(new Integer(idcargue));
            	cargue.setEstado(new Short(estado));
            }
            
            List<Cargue> cargues = new ArrayList<Cargue>();
            cargues.add(cargue);
            Integer resultado = gestionEJB.deshabilitarCargue(cargues);
            if (resultado < 1) {
                throw new Exception("Error al editar la cargue.");
            }
            PrintWriter out = response.getWriter();
            out.println("Cargue número "+cargue.getIdcargue()+" fue modificada correctamente.");
            out.close();

        } catch (LogicaException e) {
            logger.error("Atrapó la excepcion en cargueEditar logicaEx: ", e);
            response.sendError(1, e.toString());
        } catch (Exception e) {
            logger.error("Atrapó la excepcion en cargueEditar Ex: ", e);
            response.sendError(1, e.toString());
        }
    }
	   
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

}
