package com.edu.util;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

/**
 * Helper utilities for storing, resolving and deleting resource files.
 */
public final class FileStorageUtil {

    private static final String UPLOADS_FOLDER = "uploads";

    private FileStorageUtil() {
    }

    /**
     * Saves the provided file part into the configured uploads directory and returns the relative path
     * that should be stored in the database (e.g. {@code uploads/<uuid>_file.pdf}).
     */
    public static String storeFile(Part filePart, String originalFilename, ServletContext context) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            throw new IOException("No file content received for upload");
        }

        String cleanedName = extractFileName(originalFilename);
        String uniqueName = UUID.randomUUID() + "_" + cleanedName;
        Path uploadDir = getOrCreateUploadDirectory(context);
        Path target = uploadDir.resolve(uniqueName);

        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, target, StandardCopyOption.REPLACE_EXISTING);
        }

        return UPLOADS_FOLDER + "/" + uniqueName;
    }

    /**
     * Attempts to delete the file represented by the given relative path. Returns {@code true} when the
     * file existed and has been removed, {@code false} otherwise.
     */
    public static boolean deleteFile(String relativePath, ServletContext context) {
        Path absolute = resolveAbsolutePath(relativePath, context);
        if (absolute == null) {
            return false;
        }
        try {
            return Files.deleteIfExists(absolute);
        } catch (IOException e) {
            return false;
        }
    }

    /**
     * Resolves the absolute path for the provided relative resource path.
     */
    public static Path resolveAbsolutePath(String relativePath, ServletContext context) {
        if (relativePath == null || relativePath.isEmpty()) {
            return null;
        }

        if (relativePath.startsWith(UPLOADS_FOLDER + "/")) {
            String baseDir = System.getProperty("jboss.server.data.dir");
            if (baseDir != null && !baseDir.isEmpty()) {
                return Paths.get(baseDir).resolve(relativePath).normalize();
            }
        }

        String fallback = context.getRealPath("/" + relativePath);
        if (fallback == null) {
            return null;
        }
        return Paths.get(fallback);
    }

    private static Path getOrCreateUploadDirectory(ServletContext context) throws IOException {
        String baseDir = System.getProperty("jboss.server.data.dir");
        Path uploadPath;
        if (baseDir != null && !baseDir.isEmpty()) {
            uploadPath = Paths.get(baseDir, UPLOADS_FOLDER);
        } else {
            String fallback = context.getRealPath("/" + UPLOADS_FOLDER);
            if (fallback == null) {
                throw new IOException("Unable to resolve upload directory");
            }
            uploadPath = Paths.get(fallback);
        }

        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }
        return uploadPath;
    }

    private static String extractFileName(String originalFilename) {
        if (originalFilename == null) {
            return "file";
        }
        String cleaned = Paths.get(originalFilename).getFileName().toString();
        if (cleaned.isEmpty()) {
            return "file";
        }
        return cleaned;
    }
}
