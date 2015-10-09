package co.sistemcobro.constelacion.web;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.ejb.EJB;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import org.apache.log4j.Logger;
import org.apache.poi.poifs.filesystem.OfficeXmlFileException;

import co.sistemcobro.all.exception.LogicaException;
import co.sistemcobro.all.util.Archivo;
import co.sistemcobro.all.util.Util;
import co.sistemcobro.altitude.bean.PhContactBean;
import co.sistemcobro.altitude.ejb.PhContactEJB;
import co.sistemcobro.hermes.bean.Cuenta;
import co.sistemcobro.hermes.bean.UsuarioBean;
import co.sistemcobro.hermes.bean.UsuarioCuenta;
import co.sistemcobro.hermes.ejb.UsuarioEJB;
import co.sistemcobro.constelacion.bean.Base;
import co.sistemcobro.constelacion.bean.Gestion;
import co.sistemcobro.constelacion.bean.Hecho;
import co.sistemcobro.constelacion.constante.CargueTipoEnum;
import co.sistemcobro.constelacion.constante.ConstanteConstelacion;
import co.sistemcobro.constelacion.constante.EstadoCargueEnum;
import co.sistemcobro.constelacion.ejb.GestionEJB;

/**
 * 
 * @author Jony Hurtado
 * 
 */
@WebServlet(name = "ArchivoServlet", urlPatterns = { "/page/archivo" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 200, maxRequestSize = 1024 * 1024 * 200)
public class ArchivoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private Logger logger = Logger.getLogger(ArchivoServlet.class);

	@EJB
	private GestionEJB gestionEJB;

	@EJB
	private PhContactEJB phContactEJB;

	@EJB
	private UsuarioEJB usuarioEJB;
	

	public ArchivoServlet() {
		super();
	}

	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {

		String action = Archivo.getParameter(request.getPart("idcarguetipo"));
		action = action == null ? "" : action;
		try {
			if (action.equals(CargueTipoEnum.HECHOS.getIndexString())) {
				cargarHechos(request, response);
			}
		} catch (Exception e) {
			logger.error(e.toString(), e.fillInStackTrace());
			response.sendError(1, e.getMessage());
		}
	}

	


	public void cargarHechos(HttpServletRequest request,
		HttpServletResponse response) throws ServletException, IOException {
		PrintWriter writer = response.getWriter();

		HttpSession session = request.getSession(false);
		UsuarioBean user = (UsuarioBean) session.getAttribute(ConstanteConstelacion.USUARIO_SESSION);

		try {
			Date start = new Date();

			String idbase = Archivo.getParameter(request.getPart("idbase"));
			String idarea = Archivo.getParameter(request
					.getPart("iddimensionarea"));
			String idtiempotipo = Archivo.getParameter(request
					.getPart("iddimensiontiempotipo"));
			String fechacargue = Archivo.getParameter(request
					.getPart("fechacargue"));

			idarea = idarea == null ? "" : idarea;
			idtiempotipo = idtiempotipo == null ? "" : idtiempotipo;
			idbase = idbase == null ? "" : idbase;
			fechacargue = fechacargue == null ? "" : Util.stringToString(fechacargue.trim(),
					"dd/MM/yyyy", "yyyyMMdd");
			
			Integer idbase_tmp = 0;
			if ("".equals(idbase)) {
				throw new NullPointerException("Base requerida");
			} else {
				idbase_tmp = Integer.parseInt(idbase);
			}
			Integer idarea_tmp = 0;
			if ("".equals(idarea)) {
				throw new NullPointerException("Area requerida");
			} else {
				idarea_tmp = Integer.parseInt(idarea);
			}
			Integer idtiempotipo_tmp = 0;
			if ("".equals(idtiempotipo)) {
				throw new NullPointerException("Tipo de Tiempo requerida");
			} else {
				idtiempotipo_tmp = Integer.parseInt(idtiempotipo);
			}

			/* Obteniendo el archivo */
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmm");
			Part part = request.getPart("archivo");
			InputStream is = part.getInputStream();
			int k = is.available();
			byte[] b = new byte[k];
			is.read(b);
			String file = Archivo.getFullName(part);
			String filename = sdf.format(new Date()) + "_"
					+ Archivo.getFileName(file);
			String fileextension = Archivo.getFileExtension(file);
			file = filename + "." + fileextension;
			logger.info("Nombre de la base cargada: " + file);

			File archivo = new File(ConstanteConstelacion.ROOT_FILE_TEMPORARY
					+ File.separator + file);
			FileOutputStream os = new FileOutputStream(archivo);
			os.write(b);
			is.close();

			List<Hecho> hechos = gestionEJB.cargarHechos(archivo, idbase_tmp, idarea_tmp, idtiempotipo_tmp, fechacargue, user.getCodusuario());
			
			Integer idcargue = 0;
			if (hechos.size() > 0) {
				
				idcargue = hechos.get(0).getIdcargue();
				logger.info("idcargue " + idcargue);
			}
			
			gestionEJB.cargarHechosOperacion(idtiempotipo_tmp,idcargue,fechacargue);
			
			String mensaje = "";
			
			Date end = new Date();
			long diferencia = ((end.getTime() - start.getTime()) / 1000) + 1;
			mensaje += "Se cargaron  [" + hechos.size() + "] Registros. ";
			mensaje += "Todo en [" + diferencia + "] segundo(s). ";
			logger.info(mensaje);
			writer.write(mensaje);
			

		} catch (IOException e) {
			logger.error(e.toString(), e.fillInStackTrace());
			writer.write(e.getMessage());
		} catch (Exception e) {
			logger.error(e.toString(), e.fillInStackTrace());
			writer.write(e.getMessage());
		} finally {
			writer.close();
		}
	}

	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

}
