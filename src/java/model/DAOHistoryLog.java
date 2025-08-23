/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import entity.HistoryLog;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Heizxje
 */
public class DAOHistoryLog extends DBConnect {
    private DBConnect dbConnect;
    public DAOHistoryLog() {
        super();
    }

    // Backward-compatible API used by LogoutServlet
    public void logLogout(int userId) throws SQLException {
        HistoryLog log = new HistoryLog();
        log.setUserId(userId);
        log.setAction("LOGOUT");
        log.setDescription("User logged out");
        log.setIpAddress(null);
        log.setUserAgent(null);
        // Use existing insert method
        boolean ok = addLog(log);
        if (!ok) {
            throw new SQLException("Failed to write logout history log");
        }
    }

    // Backward-compatible API for login log
    public void logLogin(int userId) throws SQLException {
        HistoryLog log = new HistoryLog();
        log.setUserId(userId);
        log.setAction("LOGIN");
        log.setDescription("User logged in successfully");
        log.setIpAddress(null);
        log.setUserAgent(null);
        boolean ok = addLog(log);
        if (!ok) {
            throw new SQLException("Failed to write login history log");
        }
    }

    /**
     * Thêm log mới vào database. Hỗ trợ cả schema cũ (ActionType, Details, LogDate)
     * và schema mới (Action, Description, Timestamp).
     */
    public boolean addLog(HistoryLog log) {
        // Ưu tiên schema cũ để tương thích với DB hiện tại
        String sqlLegacy = "INSERT INTO HistoryLog (UserID, ActionType, Details, LogDate) VALUES (?, ?, ?, GETDATE())";
        try (PreparedStatement stmt = conn.prepareStatement(sqlLegacy)) {
            if (log.getUserId() != null) {
                stmt.setInt(1, log.getUserId());
            } else {
                stmt.setNull(1, java.sql.Types.INTEGER);
            }
            stmt.setString(2, log.getAction());
            stmt.setString(3, log.getDescription());
            int result = stmt.executeUpdate();
            return result > 0;
        } catch (SQLException legacyEx) {
            // Thử schema mới nếu schema cũ không tồn tại
            String sqlNew = "INSERT INTO HistoryLog (UserID, RoleID, Action, Description, Timestamp, IPAddress, UserAgent) VALUES (?, ?, ?, ?, GETDATE(), ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sqlNew)) {
                if (log.getUserId() != null) {
                    stmt.setInt(1, log.getUserId());
                } else {
                    stmt.setNull(1, java.sql.Types.INTEGER);
                }
                if (log.getRoleId() != null) {
                    stmt.setInt(2, log.getRoleId());
                } else {
                    stmt.setNull(2, java.sql.Types.INTEGER);
                }
                stmt.setString(3, log.getAction());
                stmt.setString(4, log.getDescription());
                stmt.setString(5, log.getIpAddress());
                stmt.setString(6, log.getUserAgent());
                int result = stmt.executeUpdate();
                return result > 0;
            } catch (SQLException e) {
                Logger.getLogger(DAOHistoryLog.class.getName()).log(Level.SEVERE, "Error adding log (both legacy and new schemas failed)", e);
                return false;
            }
        }
    }

    /**
     * Lấy tất cả logs với thông tin user
     */
    public List<HistoryLog> getAllLogs() throws SQLException {
        List<HistoryLog> logs = new ArrayList<>();

        // Legacy schema first (no hl.RoleID column)
        String sqlLegacy = "SELECT hl.LogID, hl.UserID, hl.ActionType, hl.Details, hl.LogDate, u.FullName, u.Email, u.RoleID " +
                           "FROM HistoryLog hl LEFT JOIN Users u ON hl.UserID = u.UserID ORDER BY hl.LogDate DESC";
        try (PreparedStatement stmt = conn.prepareStatement(sqlLegacy);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                HistoryLog log = new HistoryLog();
                log.setLogID(rs.getInt("LogID"));
                log.setUserId(rs.getInt("UserID"));
                log.setActionType(rs.getString("ActionType"));
                log.setDetails(rs.getString("Details"));
                log.setLogDate(rs.getTimestamp("LogDate"));
                log.setFullName(rs.getString("FullName"));
                log.setEmail(rs.getString("Email"));
                log.setRoleId(rs.getInt("RoleID"));
                logs.add(log);
            }
            return logs;
        } catch (SQLException ignore) {
            // Fallback to new schema
        }

        String sqlNew = "SELECT hl.LogID, hl.UserID, hl.RoleID, hl.Action, hl.Description, hl.Timestamp, u.FullName, u.Email " +
                        "FROM HistoryLog hl LEFT JOIN Users u ON hl.UserID = u.UserID ORDER BY hl.Timestamp DESC";
        try (PreparedStatement stmt = conn.prepareStatement(sqlNew);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                HistoryLog log = new HistoryLog();
                log.setLogID(rs.getInt("LogID"));
                log.setUserId(rs.getInt("UserID"));
                log.setRoleId(rs.getInt("RoleID"));
                log.setAction(rs.getString("Action"));
                log.setDescription(rs.getString("Description"));
                log.setTimestamp(rs.getTimestamp("Timestamp"));
                log.setFullName(rs.getString("FullName"));
                log.setEmail(rs.getString("Email"));
                logs.add(log);
            }
        }

        return logs;
    }

    /**
     * Lấy một số log gần nhất (mặc định 5) – tương thích với các nơi đang dùng
     */
    public List<HistoryLog> getRecentLogs() throws SQLException {
        List<HistoryLog> logs = new ArrayList<>();

        // Try legacy schema first (ActionType/Details/LogDate)
        String sqlLegacy = "SELECT TOP 5 hl.LogID, hl.UserID, hl.ActionType, hl.Details, hl.LogDate, u.FullName, u.Email, u.RoleID " +
                           "FROM HistoryLog hl LEFT JOIN Users u ON hl.UserID = u.UserID ORDER BY hl.LogDate DESC";
        try (PreparedStatement stmt = conn.prepareStatement(sqlLegacy);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                HistoryLog log = new HistoryLog();
                log.setLogID(rs.getInt("LogID"));
                log.setUserId(rs.getInt("UserID"));
                log.setActionType(rs.getString("ActionType"));
                log.setDetails(rs.getString("Details"));
                log.setLogDate(rs.getTimestamp("LogDate"));
                log.setFullName(rs.getString("FullName"));
                log.setEmail(rs.getString("Email"));
                log.setRoleId(rs.getInt("RoleID"));
                logs.add(log);
            }
            return logs;
        } catch (SQLException ignore) {
            // Fallback to new schema (Action/Description/Timestamp)
        }

        String sqlNew = "SELECT TOP 5 hl.LogID, hl.UserID, hl.RoleID, hl.Action, hl.Description, hl.Timestamp, u.FullName, u.Email " +
                        "FROM HistoryLog hl LEFT JOIN Users u ON hl.UserID = u.UserID ORDER BY hl.Timestamp DESC";
        try (PreparedStatement stmt = conn.prepareStatement(sqlNew);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                HistoryLog log = new HistoryLog();
                log.setLogID(rs.getInt("LogID"));
                log.setUserId(rs.getInt("UserID"));
                log.setRoleId(rs.getInt("RoleID"));
                log.setAction(rs.getString("Action"));
                log.setDescription(rs.getString("Description"));
                log.setTimestamp(rs.getTimestamp("Timestamp"));
                log.setFullName(rs.getString("FullName"));
                log.setEmail(rs.getString("Email"));
                logs.add(log);
            }
        }

        return logs;
    }

    /**
     * Lấy logs theo user ID
     */
    public List<HistoryLog> getLogsByUserId(int userId) throws SQLException {
        List<HistoryLog> logs = new ArrayList<>();
        String sql = "SELECT " +
                     "hl.LogID, hl.UserID, hl.RoleID, " +
                     "hl.ActionType AS Action, hl.Details AS Description, hl.LogDate AS Timestamp, " +
                     "u.FullName, u.Email, u.RoleID as UserRoleID " +
                     "FROM HistoryLog hl " +
                     "LEFT JOIN Users u ON hl.UserID = u.UserID " +
                     "WHERE hl.UserID = ? " +
                     "ORDER BY hl.LogDate DESC";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    HistoryLog log = new HistoryLog();
                    log.setLogID(rs.getInt("LogID"));
                    log.setUserId(rs.getInt("UserID"));
                    log.setRoleId(rs.getInt("RoleID"));
                    log.setAction(rs.getString("Action"));
                    log.setDescription(rs.getString("Description"));
                    log.setTimestamp(rs.getTimestamp("Timestamp"));
                    log.setFullName(rs.getString("FullName"));
                    log.setEmail(rs.getString("Email"));
                    
                    int userRoleId = rs.getInt("UserRoleID");
                    if (userRoleId > 0) {
                        log.setRoleId(userRoleId);
                    }
                    
                    logs.add(log);
                }
            }
        }
        
        return logs;
    }

    /**
     * Lấy logs theo action
     */
    public List<HistoryLog> getLogsByAction(String action) throws SQLException {
        List<HistoryLog> logs = new ArrayList<>();
        String sql = "SELECT " +
                     "hl.LogID, hl.UserID, hl.RoleID, " +
                     "hl.ActionType AS Action, hl.Details AS Description, hl.LogDate AS Timestamp, " +
                     "u.FullName, u.Email, u.RoleID as UserRoleID " +
                     "FROM HistoryLog hl " +
                     "LEFT JOIN Users u ON hl.UserID = u.UserID " +
                     "WHERE hl.ActionType = ? " +
                     "ORDER BY hl.LogDate DESC";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, action);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    HistoryLog log = new HistoryLog();
                    log.setLogID(rs.getInt("LogID"));
                    log.setUserId(rs.getInt("UserID"));
                    log.setRoleId(rs.getInt("RoleID"));
                    log.setAction(rs.getString("Action"));
                    log.setDescription(rs.getString("Description"));
                    log.setTimestamp(rs.getTimestamp("Timestamp"));
                    log.setFullName(rs.getString("FullName"));
                    log.setEmail(rs.getString("Email"));
                    
                    int userRoleId = rs.getInt("UserRoleID");
                    if (userRoleId > 0) {
                        log.setRoleId(userRoleId);
                    }
                    
                    logs.add(log);
                }
            }
        }
        
        return logs;
    }

    /**
     * Lấy logs trong khoảng thời gian
     */
    public List<HistoryLog> getLogsByDateRange(Timestamp startDate, Timestamp endDate) throws SQLException {
        List<HistoryLog> logs = new ArrayList<>();
        String sql = "SELECT " +
                     "hl.LogID, hl.UserID, hl.RoleID, " +
                     "hl.ActionType AS Action, hl.Details AS Description, hl.LogDate AS Timestamp, " +
                     "u.FullName, u.Email, u.RoleID as UserRoleID " +
                     "FROM HistoryLog hl " +
                     "LEFT JOIN Users u ON hl.UserID = u.UserID " +
                     "WHERE hl.LogDate BETWEEN ? AND ? " +
                     "ORDER BY hl.LogDate DESC";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setTimestamp(1, startDate);
            stmt.setTimestamp(2, endDate);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    HistoryLog log = new HistoryLog();
                    log.setLogID(rs.getInt("LogID"));
                    log.setUserId(rs.getInt("UserID"));
                    log.setRoleId(rs.getInt("RoleID"));
                    log.setAction(rs.getString("Action"));
                    log.setDescription(rs.getString("Description"));
                    log.setTimestamp(rs.getTimestamp("Timestamp"));
                    log.setFullName(rs.getString("FullName"));
                    log.setEmail(rs.getString("Email"));
                    
                    int userRoleId = rs.getInt("UserRoleID");
                    if (userRoleId > 0) {
                        log.setRoleId(userRoleId);
                    }
                    
                    logs.add(log);
                }
            }
        }
        
        return logs;
    }

        public List<HistoryLog> getUserAndTutorLogs() throws SQLException {
        List<HistoryLog> logs = new ArrayList<>();
        String sql = "SELECT TOP 1000 hl.*, u.FullName, u.Email, u.RoleID "
                + "FROM HistoryLog hl "
                + "LEFT JOIN Users u ON hl.UserID = u.UserID "
                + "WHERE u.RoleID IN (2, 3) "
                + "ORDER BY hl.LogDate DESC";
        try (Connection conn = dbConnect.getConnection();
             ResultSet rs = conn.createStatement().executeQuery(sql)) {
            while (rs.next()) {
                HistoryLog log = new HistoryLog();
                log.setLogId(rs.getInt("LogID"));
                log.setUserId(rs.getInt("UserID"));
                log.setActionType(rs.getString("ActionType"));
                log.setTargetId(rs.getObject("TargetID") != null ? rs.getString("TargetID") : null);
                log.setDetails(rs.getString("Details"));
                log.setLogDate(rs.getTimestamp("LogDate"));
                log.setFullName(rs.getString("FullName"));
                log.setEmail(rs.getString("Email"));
                log.setRoleId(rs.getInt("RoleID"));
                logs.add(log);
            }
        }
        return logs;
    }
    /**
     * Xóa log cũ (older than specified days)
     */
    public boolean deleteOldLogs(int daysOld) {
        String sql = "DELETE FROM HistoryLog WHERE Timestamp < DATEADD(day, -?, GETDATE())";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, daysOld);
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            Logger.getLogger(DAOHistoryLog.class.getName()).log(Level.SEVERE, "Error deleting old logs", e);
            return false;
        }
    }
}