package co.sistemcobro.constelacion.web;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.ResourceBundle;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import co.sistemcobro.all.util.Util;
import co.sistemcobro.constelacion.bean.Base;
import co.sistemcobro.constelacion.bean.Calculado;
import co.sistemcobro.constelacion.bean.CalculadoValor;
import co.sistemcobro.constelacion.bean.DimensionUsuario;
import co.sistemcobro.constelacion.bean.HechoOperacion;
import co.sistemcobro.constelacion.constante.ConstanteConstelacion;
import co.sistemcobro.constelacion.constante.KpiTipoBusquedaEnum;
import co.sistemcobro.constelacion.dao.CalculadoDAO.FrecuenciaEnum;
import co.sistemcobro.constelacion.ejb.GestionEJB;

/**
 * 
 * @author Jony Hurtado
 * 
 */
@WebServlet(name = "KpiServlet", urlPatterns = { "/page/kpi" })
public class KpiServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String SPLIT = "£";
	private Logger logger = Logger.getLogger(KpiServlet.class);

	ResourceBundle config = ResourceBundle.getBundle(ConstanteConstelacion.FILE_CONFIG_CONSTELACION);

	@EJB
	private GestionEJB gestionEJB;

	public KpiServlet() {
		super();
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String action = request.getParameter("action");
		action = action == null ? "" : action;
		try {
			if (action.equals("kpi_buscar")) {
				buscarKpi(request, response);
			} else if (action.equals("kpi_principal")) {
				principalKpi(request, response);
			} else if (action.equals("usuario_detalle")) {
				logger.info("Entra a usuario detalle");
				detalleUsuario(request, response);
			}	 
		} catch (Exception e) {
			logger.error(e.toString(), e.fillInStackTrace());
			response.sendError(1, e.getMessage());
		}
	}

	public void buscarKpi(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			String tipobusqueda = request.getParameter("tipobusqueda");
			KpiTipoBusquedaEnum busqueda = KpiTipoBusquedaEnum.get(Integer.parseInt(tipobusqueda));

			if (busqueda.getIndex() == KpiTipoBusquedaEnum.KPI_USUARIOS.getIndex()) {
				generarKpiPorUsuario(request, response);
			}

		} catch (Exception e) {
			logger.error(e.toString(), e.fillInStackTrace());
			response.sendError(1, e.getMessage());
		}
	}
	

	public void generarKpiPorUsuario (HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {

			String desde = request.getParameter("from");
			String hasta = request.getParameter("to");
			String idfrecuencia = request.getParameter("idfrecuencia");
			String idarea = request.getParameter("idarea");
			
			String idtiempotipo = request.getParameter("idtiempotipo");
			String idindicador = request.getParameter("idindicador");
			
			idarea = idarea == null ? "" : idarea;
			idtiempotipo = idtiempotipo == null ? "" : idtiempotipo;
			idindicador = idindicador == null ? "" : idindicador;
			
			Integer idarea_tmp = 0;
			if ("".equals(idarea)) {
				throw new NullPointerException("Area requerida");
			} else {
				idarea_tmp = Integer.parseInt(idarea);
			}
			
			Integer idtiempotipo_tmp = 0;
			if ("".equals(idtiempotipo)) {
				throw new NullPointerException("Tiempo tipo requerida");
			} else {
				idtiempotipo_tmp = Integer.parseInt(idtiempotipo);
			}
			
			Integer idindicador_tmp = 0;
			if ("".equals(idindicador)) {
				throw new NullPointerException("Indicador requerida");
			} else {
				idindicador_tmp = Integer.parseInt(idindicador);
			}

			Calendar desde_t = Util.stringToCalendar(desde.trim(), "dd/MM/yyyy");
			Calendar hasta_t = Util.stringToCalendar(hasta.trim(), "dd/MM/yyyy");

			idfrecuencia = idfrecuencia == null ? "" : idfrecuencia.trim();
			FrecuenciaEnum frecuencia = FrecuenciaEnum.get(Integer.parseInt(idfrecuencia));

			List<Calculado> datos = new ArrayList<Calculado>();
			datos = gestionEJB.getKpiPorUsuario(desde_t, hasta_t, frecuencia,idarea_tmp,idtiempotipo_tmp,idindicador_tmp);

			
			/* Generando el sumarizado por columna*/
			if (null != datos && datos.size() > 0) {
				Calculado total = new Calculado();
				total.setIndicador(datos.get(0).getIndicador());
				List<CalculadoValor> valores = new ArrayList<CalculadoValor>();
				
				
				for (int i = 0; i < datos.get(0).getValores().size(); i++) {

					CalculadoValor totalvalor = new CalculadoValor();
					BigDecimal colindicador = new BigDecimal(0);
					BigDecimal colmeta = new BigDecimal(0);
					
					for (Calculado tmp : datos) {
						
						BigDecimal sumindicador = tmp.getValores().get(i).getValorindicador();
						BigDecimal summeta = tmp.getValores().get(i).getValormeta();
						
						if (null != sumindicador) {
							colindicador = colindicador.add(sumindicador);
						}
						if (null != summeta) {
							colmeta = colmeta.add(summeta);
						}
					}
					totalvalor.setValorindicador(colindicador);
					totalvalor.setValormeta(colmeta);
					valores.add(totalvalor);
				}
				
				total.setValores(valores); 

				Calendar desde_tmp = Calendar.getInstance();
				desde_tmp.setTime(desde_t.getTime());

				List<Timestamp> frequencias = new ArrayList<Timestamp>();
				int nundias = 0;
				String formato = "";
				while (desde_tmp.before(hasta_t)) {
					frequencias.add(Util.calendarToTimeStamp(desde_tmp));
					if (frecuencia.getIndex() == FrecuenciaEnum.DIA.getIndex()) {
						nundias++;
						desde_tmp.add(Calendar.DAY_OF_MONTH, 1);
						formato = "dd/MM/yyyy";
					} else if (frecuencia.getIndex() == FrecuenciaEnum.MES.getIndex()) {
						nundias++;
						desde_tmp.add(Calendar.MONTH, 1);
						formato = "MM/yyyy";
					} else if (frecuencia.getIndex() == FrecuenciaEnum.ANIO.getIndex()) {
						nundias++;
						desde_tmp.add(Calendar.YEAR, 1);
						formato = "yyyy";
					} else {
						break;
					}
				}

				if (frecuencia.getIndex() == FrecuenciaEnum.DIA.getIndex()) {
					frequencias.add(Util.calendarToTimeStamp(desde_tmp));
					nundias++;
					formato = "dd/MM/yyyy";
				} else if (frecuencia.getIndex() == FrecuenciaEnum.MES.getIndex()) {
					if (desde_t.get(Calendar.DAY_OF_MONTH) >= hasta_t.get(Calendar.DAY_OF_MONTH)) {
						frequencias.add(Util.calendarToTimeStamp(desde_tmp));
						nundias++;
						formato = "MM/yyyy";
					}
				} else if (frecuencia.getIndex() == FrecuenciaEnum.ANIO.getIndex()) {
					if ((desde_t.get(Calendar.MONTH) >= hasta_t.get(Calendar.MONTH) && desde_t.get(Calendar.DAY_OF_MONTH) >= hasta_t.get(Calendar.DAY_OF_MONTH)) || nundias == 0) {
						frequencias.add(Util.calendarToTimeStamp(desde_tmp));
						nundias++;
						formato = "yyyy";
					}
				}
				request.setAttribute("formato", formato);
				request.setAttribute("frequencias", frequencias);
				request.setAttribute("total", total);
				request.setAttribute("hasta",hasta);
				request.setAttribute("desde",desde);
			}
			request.setAttribute("datos", datos);

			request.getRequestDispatcher("../pages/kpi/kpi_usuarios.jsp").forward(request, response);

		} catch (Exception e) {
			logger.error(e.toString(), e.fillInStackTrace());
			response.sendError(1, e.getMessage());
		}
	}

	public void principalKpi(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {

			request.setAttribute("areas", gestionEJB.getDimensionArea());
			request.setAttribute("tiempotipos", gestionEJB.getDimensionTiempoTipo());
			request.setAttribute("indicadores", gestionEJB.getDimensionIndicador());
			
			request.getRequestDispatcher("../pages/kpi/kpi_busqueda.jsp").forward(request, response);

		} catch (Exception e) {
			logger.error(e.toString(), e.fillInStackTrace());
			response.sendError(1, e.getMessage());
		}
	}
	
	public void detalleUsuario(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {

			String idusuario = request.getParameter("idusuario");
			String desde = request.getParameter("desde");
			String hasta = request.getParameter("hasta");
			
			idusuario = idusuario == null ? "" : idusuario.trim();
			Integer idusuario_tmp;
			if ("".equals(idusuario)) {
				throw new NullPointerException("idusuario requerida");
			} else {
				idusuario_tmp = Integer.parseInt(idusuario);
			}
			
			Calendar desde_t = Util.stringToCalendar(desde.trim(), "dd/MM/yyyy");
			Calendar hasta_t = Util.stringToCalendar(hasta.trim(), "dd/MM/yyyy");
			
			
			
			FrecuenciaEnum frecuencia = FrecuenciaEnum.get(8);
			
			List<Calculado> datos = new ArrayList<Calculado>();
			
			DimensionUsuario  usuario = new DimensionUsuario();
			
			usuario = gestionEJB.getUsuarioPorId(idusuario_tmp);
			
			datos = gestionEJB.getHechosPorIdusuario(desde_t,hasta_t,frecuencia,idusuario_tmp);
			
			if (null != datos && datos.size() > 0) {
				Calculado total = new Calculado();
				
				List<CalculadoValor> valores = new ArrayList<CalculadoValor>();
				
				
				for (int i = 0; i < datos.get(0).getValores().size(); i++) {

					CalculadoValor totalvalor = new CalculadoValor();
					BigDecimal colindicador = new BigDecimal(0);
					BigDecimal colmeta = new BigDecimal(0);
					
					for (Calculado tmp : datos) {
						
						BigDecimal sumindicador = tmp.getValores().get(i).getValorindicador();
						BigDecimal summeta = tmp.getValores().get(i).getValormeta();
						
						if (null != sumindicador) {
							colindicador = colindicador.add(sumindicador);
						}
						if (null != summeta) {
							colmeta = colmeta.add(summeta);
						}
					}
					totalvalor.setValorindicador(colindicador);
					totalvalor.setValormeta(colmeta);
					valores.add(totalvalor);
				}
			
				total.setValores(valores);
				
			Calendar desde_tmp = Calendar.getInstance();
			desde_tmp.setTime(desde_t.getTime());
			
			List<Timestamp> frequencias = new ArrayList<Timestamp>();
			int nundias = 0;
			String formato = "";
			while (desde_tmp.before(hasta_t)) {
				frequencias.add(Util.calendarToTimeStamp(desde_tmp));
				if (frecuencia.getIndex() == FrecuenciaEnum.DIA.getIndex()) {
					nundias++;
					desde_tmp.add(Calendar.DAY_OF_MONTH, 1);
					formato = "dd/MM/yyyy";
				} else if (frecuencia.getIndex() == FrecuenciaEnum.MES.getIndex()) {
					nundias++;
					desde_tmp.add(Calendar.MONTH, 1);
					formato = "MM/yyyy";
				} else if (frecuencia.getIndex() == FrecuenciaEnum.ANIO.getIndex()) {
					nundias++;
					desde_tmp.add(Calendar.YEAR, 1);
					formato = "yyyy";
				} else {
					break;
				}
			}

			if (frecuencia.getIndex() == FrecuenciaEnum.DIA.getIndex()) {
				frequencias.add(Util.calendarToTimeStamp(desde_tmp));
				nundias++;
				formato = "dd/MM/yyyy";
			} else if (frecuencia.getIndex() == FrecuenciaEnum.MES.getIndex()) {
				if (desde_t.get(Calendar.DAY_OF_MONTH) >= hasta_t.get(Calendar.DAY_OF_MONTH)) {
					frequencias.add(Util.calendarToTimeStamp(desde_tmp));
					nundias++;
					formato = "MM/yyyy";
				}
			} else if (frecuencia.getIndex() == FrecuenciaEnum.ANIO.getIndex()) {
				if ((desde_t.get(Calendar.MONTH) >= hasta_t.get(Calendar.MONTH) && desde_t.get(Calendar.DAY_OF_MONTH) >= hasta_t.get(Calendar.DAY_OF_MONTH)) || nundias == 0) {
					frequencias.add(Util.calendarToTimeStamp(desde_tmp));
					nundias++;
					formato = "yyyy";
				}
			}
			
			
			request.setAttribute("formato", formato);
			request.setAttribute("frequencias", frequencias);
			request.setAttribute("total", total);
			
			}	
			
			request.setAttribute("usuario", usuario);
			request.setAttribute("datos", datos);
			
			request.getRequestDispatcher("../pages/kpi/kpi_usuario.jsp").forward(request, response);

		} catch (Exception e) {
			logger.error(e.toString(), e.fillInStackTrace());
			response.sendError(1, e.getMessage());
		}
	}
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	
}
