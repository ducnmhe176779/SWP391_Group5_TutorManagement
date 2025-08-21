/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import entity.HistoryLog;
import model.DAOHistoryLog;
import jakarta.servlet.http.HttpServletRequest;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Utility class để ghi log hoạt động
 *
 * @author Heizxje
 */
public class LogUtil {
    
    private static final Logger LOGGER = Logger.getLogger(LogUtil.class.getName());
    
    /**
     * Ghi log hoạt động với thông tin user
     */
    public static void logActivity(Integer userId, Integer roleId, String action, String description, HttpServletRequest request) {
        try {
            DAOHistoryLog dao = new DAOHistoryLog();
            
            HistoryLog log = new HistoryLog();
            log.setUserId(userId);
            log.setRoleId(roleId);
            log.setAction(action);
            log.setDescription(description);
            log.setIpAddress(getClientIPAddress(request));
            log.setUserAgent(getUserAgent(request));
            
            boolean success = dao.addLog(log);
            if (success) {
                LOGGER.info("Activity logged successfully: " + action + " by user " + userId);
            } else {
                LOGGER.warning("Failed to log activity: " + action + " by user " + userId);
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error logging activity: " + action, e);
        }
    }
    
    /**
     * Ghi log đăng nhập
     */
    public static void logLogin(Integer userId, Integer roleId, HttpServletRequest request) {
        logActivity(userId, roleId, "LOGIN", "User logged in successfully", request);
    }
    
    /**
     * Ghi log đăng xuất
     */
    public static void logLogout(Integer userId, Integer roleId, HttpServletRequest request) {
        logActivity(userId, roleId, "LOGOUT", "User logged out", request);
    }
    
    /**
     * Ghi log tạo mới
     */
    public static void logCreate(Integer userId, Integer roleId, String entity, String details, HttpServletRequest request) {
        logActivity(userId, roleId, "CREATE", "Created " + entity + ": " + details, request);
    }
    
    /**
     * Ghi log cập nhật
     */
    public static void logUpdate(Integer userId, Integer roleId, String entity, String details, HttpServletRequest request) {
        logActivity(userId, roleId, "UPDATE", "Updated " + entity + ": " + details, request);
    }
    
    /**
     * Ghi log xóa
     */
    public static void logDelete(Integer userId, Integer roleId, String entity, String details, HttpServletRequest request) {
        logActivity(userId, roleId, "DELETE", "Deleted " + entity + ": " + details, request);
    }
    
    /**
     * Ghi log xem
     */
    public static void logView(Integer userId, Integer roleId, String entity, String details, HttpServletRequest request) {
        logActivity(userId, roleId, "VIEW", "Viewed " + entity + ": " + details, request);
    }
    
    /**
     * Lấy IP address của client
     */
    private static String getClientIPAddress(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isEmpty() && !"unknown".equalsIgnoreCase(xForwardedFor)) {
            return xForwardedFor.split(",")[0];
        }
        
        String xRealIP = request.getHeader("X-Real-IP");
        if (xRealIP != null && !xRealIP.isEmpty() && !"unknown".equalsIgnoreCase(xRealIP)) {
            return xRealIP;
        }
        
        return request.getRemoteAddr();
    }
    
    /**
     * Lấy User Agent của client
     */
    private static String getUserAgent(HttpServletRequest request) {
        String userAgent = request.getHeader("User-Agent");
        if (userAgent != null && userAgent.length() > 500) {
            return userAgent.substring(0, 500) + "...";
        }
        return userAgent;
    }
}
