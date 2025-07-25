package util;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.Part;

public class FileUploadUtil {
    private static final String UPLOAD_DIR = "assets/images/products";
    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB
    
    public static String saveFile(HttpServletRequest request, Part filePart) throws IOException, ServletException {
        // Validate file exists and has content
        if (filePart == null || filePart.getSize() == 0) {
            return "/assets/images/no-image.png";
        }

        // Validate file size
        if (filePart.getSize() > MAX_FILE_SIZE) {
            throw new ServletException("File size exceeds maximum limit of 10MB");
        }

        // Validate file type
        String contentType = filePart.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            throw new ServletException("Only image files are allowed");
        }

        // Get the application's real path
        String applicationPath = request.getServletContext().getRealPath("");
        // Create upload directory in both webapp and real path
        Path uploadPath = Paths.get(applicationPath, UPLOAD_DIR);
        Path webappUploadPath = Paths.get(request.getServletContext().getRealPath("/"), UPLOAD_DIR);
        
        // Create directories if they don't exist
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }
        if (!Files.exists(webappUploadPath)) {
            Files.createDirectories(webappUploadPath);
        }
        
        // Generate unique filename with original extension
        String originalFileName = getFileName(filePart);
        String fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
        String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
        
        // Save the file to both locations
        Path filePath = uploadPath.resolve(uniqueFileName);
        Path webappFilePath = webappUploadPath.resolve(uniqueFileName);
        
        Files.copy(filePart.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
        Files.copy(filePart.getInputStream(), webappFilePath, StandardCopyOption.REPLACE_EXISTING);
        
        // Return relative path for database (context-relative)
        return "/" + UPLOAD_DIR + "/" + uniqueFileName;
    }
    
    public static void deleteFile(HttpServletRequest request, String filePath) throws IOException {
        if (filePath == null || filePath.isEmpty() || filePath.equals("/assets/images/no-image.png")) {
            return;
        }
        
        // Delete from both locations
        String applicationPath = request.getServletContext().getRealPath("");
        Path path1 = Paths.get(applicationPath, filePath.substring(1)); // Remove leading slash
        Path path2 = Paths.get(request.getServletContext().getRealPath("/"), filePath.substring(1));
        
        Files.deleteIfExists(path1);
        Files.deleteIfExists(path2);
    }
    
    private static String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp == null) {
            return "";
        }
        
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
}