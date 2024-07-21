package com.edu.pe.utils;

import java.io.File;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;

public class Utileria {

    public static String RUTA_IMAGEN = "src\\main\\webapp\\assets\\img\\consultas\\";
    public static String RUTA_APP_IMAGEN = "assets\\img\\consultas\\";
    public static String RUTA_REPORTE = "src\\main\\java\\com\\edu\\pe\\reportes\\";

    public static String guardarArchivo(String ruta, Part archivoPart, String nombreArchivo) {
        try {
            File archivo = new File(ruta);

            if (!archivo.exists()) {
                archivo.mkdirs();
            }

            Path path = Paths.get(ruta + nombreArchivo);
            archivo = new File(path.toAbsolutePath().toString());
            archivo.toPath();

            try (InputStream input = archivoPart.getInputStream()) {
                Files.copy(input, archivo.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            return "";
        }
        return nombreArchivo;
    }

    public static String RutaAbsoluta(HttpServletRequest request, String carpeta) {
        String ruta = request.getServletContext().getRealPath("");
        return ruta.substring(0, ruta.indexOf("target")) + carpeta;
    }

    public static String RutaAbsoluta(HttpServletRequest request) {
        String ruta = request.getServletContext().getRealPath("");
        return ruta.substring(0, ruta.indexOf("target"));
    }

    public static String NomImagen() {
        return String.format("img-%08d", GenerarNumero()) + ".jpg";
    }

    public static int GenerarNumero() {
        int inicio = 10000000, fin = 99999999;
        return (int) (Math.random() * (fin - inicio + 1) + inicio);
    }
}
