/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

import java.sql.Timestamp;

/**
 *
 * @author Heizxje
 */
public class HistoryLog {
    private int logID;
    private Integer userId;
    private Integer roleId;
    private String action;
    private String description;
    private Timestamp timestamp;
    private String ipAddress;
    private String userAgent;
    private String targetId; // for backward compatibility
    
    // Thông tin bổ sung từ User
    private String fullName;
    private String email;
    private String roleName;
    
    public HistoryLog() {
    }

    public HistoryLog(int logID, Integer userId, Integer roleId, String action, String description, Timestamp timestamp) {
        this.logID = logID;
        this.userId = userId;
        this.roleId = roleId;
        this.action = action;
        this.description = description;
        this.timestamp = timestamp;
    }

    public HistoryLog(Integer userId, Integer roleId, String action, String description, String ipAddress, String userAgent) {
        this.userId = userId;
        this.roleId = roleId;
        this.action = action;
        this.description = description;
        this.ipAddress = ipAddress;
        this.userAgent = userAgent;
    }

    // Getters and Setters
    public int getLogID() {
        return logID;
    }

    public void setLogID(int logID) {
        this.logID = logID;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getRoleId() {
        return roleId;
    }

    public void setRoleId(Integer roleId) {
        this.roleId = roleId;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Timestamp timestamp) {
        this.timestamp = timestamp;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public String getUserAgent() {
        return userAgent;
    }

    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    // Backward-compatible getters for existing JSPs
    // Map old API names to new fields to avoid breaking views
    public String getActionType() {
        return getAction();
    }

    public String getDetails() {
        return getDescription();
    }

    public java.util.Date getLogDate() {
        return getTimestamp();
    }

    // Backward-compatible setters/getters used by older DAO code
    public void setLogId(int logId) {
        this.logID = logId;
    }

    public int getLogId() {
        return this.logID;
    }

    public void setActionType(String actionType) {
        this.action = actionType;
    }

    public void setDetails(String details) {
        this.description = details;
    }

    public void setLogDate(Timestamp ts) {
        this.timestamp = ts;
    }

    public String getTargetId() {
        return targetId;
    }

    public void setTargetId(String targetId) {
        this.targetId = targetId;
    }
}
