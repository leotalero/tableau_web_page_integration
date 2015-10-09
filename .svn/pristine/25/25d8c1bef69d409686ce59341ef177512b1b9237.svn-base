package co.sistemcobro.constelacion.run;

import java.io.IOException;
import java.net.MalformedURLException;
import java.sql.Timestamp;
import java.text.DecimalFormatSymbols;
import java.util.Date;
import java.util.HashSet;

import co.sistemcobro.all.exception.CsvException;
import co.sistemcobro.all.util.Csv;
import co.sistemcobro.all.util.Util;

public class Main {
	public static void main(String[] args) throws MalformedURLException,IOException {
		
		
		int x = (int)(Math.random()*40);
		
		System.out.println("Main.main() "+x);
		
		
		
		String y = "hola\nmun\tdo";
		
		System.out.println("string 1:  "+y);
		
		
		y=y.replaceAll("[\n\r]|[\t]|[\n]", "");
		
		
		System.out.println("string 3:  "+y);
		
	}
}
/*
//URL url = new
		// URL("http://localhost:8080/elespectador/mail/correo?action=mail_ticket_detalle&idticket=3&token=1234");
		// URLConnection con = url.openConnection();
		//
		// BufferedReader in = new BufferedReader(new InputStreamReader(
		// con.getInputStream()));
		//
		// String linea;
		// while ((linea = in.readLine()) != null) {
		// System.out.println(linea);
		// }

		Timestamp value = null;
		String tmp = "2014-03-20 00:00:00.000";
		String formato = "yyyy-MM-dd HH:mm:ss.S";
		try {
			value = Util.stringToTimestamp(tmp, formato);
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		System.out.println("value:"+value);


	}

	public static String getSplit(String part) {

		// String partHeader = part.getHeader("content-disposition");
		// System.out.println("partHeader: " + partHeader);
		// for (String cd : partHeader.split(";")) {
		String findfile[] = part.split("\\\\");
		if (findfile.length > 0) {
			return part.substring(part.lastIndexOf("\\") + 1).trim()
					.replace("\"", "");
		} else {
			return part.replace("\"", "");
		}
		// }

	}

	public static String getFileName(String file) {
		System.out.println("file:" + file);
		String value = "";
		if (null != file) {
			int a = file.lastIndexOf(".");
			if (-1 == a) {
				value = file;
			} else {
				value = file.substring(0, a);
			}
		}
		return value;
	}

	public static String getFileExtension(String file) {
		System.out.println("file:" + file);
		String value = "";
		if (null != file) {
			int a = file.lastIndexOf(".");
			if (-1 < a) {
				value = file.substring(a + 1, file.length());
			}
		}
		return value;*/