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
import co.sistemcobro.constelacion.bean.Pregunta;
import co.sistemcobro.constelacion.constante.ConstanteConstelacion;
import co.sistemcobro.constelacion.ejb.FormularioEJB;
import co.sistemcobro.constelacion.ejb.GestionEJB;
import co.sistemcobro.hermes.bean.UsuarioAplicacionBean;
import co.sistemcobro.hermes.constante.AplicacionEnum;
import co.sistemcobro.hermes.ejb.UsuarioEJB;

/**
 * 
 * @author Leonardo talero
 * 
 */
@WebServlet(name = "FormularioServlet", urlPatterns = { "/page/formulario" })
public class FormularioServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private Logger logger = Logger.getLogger(FormularioServlet.class);

	ResourceBundle config = ResourceBundle.getBundle(ConstanteConstelacion.FILE_CONFIG_CONSTELACION);
	
	
	@EJB
	private GestionEJB gestionEJB;

	@EJB
	private UsuarioEJB usuarioEJB;
	
	@EJB
	private PhContactEJB phContactEJB;
	@EJB
	private FormularioEJB formularioEJB;

	public FormularioServlet() {
		super();
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String action = request.getParameter("action");
		action = action == null ? "" : action;
		try {
			if (action.equals("formulario_principal")) {
				principalFormulario(request, response);
			} else if (action.equals("crear_formulario")) {
				crear_formulario(request, response);
            }

		} catch (Exception e) {
			logger.error(e.toString(), e.fillInStackTrace());
			response.sendError(1, e.getMessage());
		}
	}

	public void principalFormulario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {

		
			//request.setAttribute("bases", gestionEJB.getBases());
			///request.setAttribute("carguestipos", gestionEJB.getCarguesTipos());
			//request.setAttribute("areas", gestionEJB.getDimensionArea());
			//request.setAttribute("tiempotipos", gestionEJB.getDimensionTiempoTipo());
			
			//String[] estados = {EstadoEnum.ACTIVO.getIndexString()};
			//List<UsuarioAplicacionBean> usuariosaplicacion = usuarioEJB.getUsuariosPorAplicacion(AplicacionEnum.CONSTELACION.getIndex(), estados);

			//request.setAttribute("usuariosaplicacion", usuariosaplicacion);

			request.getRequestDispatcher("../pages/formulario/formulario_principal.jsp").forward(request, response);

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
    public void crear_formulario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
          //  String estado = request.getParameter("estado");
          //  estado = estado == null ? EstadoEnum.ACTIVO.getIndexString() : estado.trim();

          //  String idcargue = request.getParameter("idcargue");
          //  idcargue = idcargue == null ? "" : idcargue.trim();
            
          //  Cargue cargue = null;
            
        	Long idformularionuevo=formularioEJB.getIdformularioaCrear();
        	
            if ("".equals(idformularionuevo)) {
                throw new NullPointerException("Id formulario nuevo vacio.");
            } else {
            	
            	request.setAttribute("idformularionuevo", idformularionuevo);
            	
            	 List<Pregunta> preguntas = formularioEJB.getPreguntasporIdCuestionarioActivas(Long.valueOf("1"));
            	 request.setAttribute("preguntas", preguntas);
				request.getRequestDispatcher("../pages/formulario/formulario_nuevo.jsp").forward(request, response);
				
            	
            	
            }
            
          

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
