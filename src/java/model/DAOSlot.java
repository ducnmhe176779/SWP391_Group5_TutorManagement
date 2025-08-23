package model;

import entity.Slot;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DAOSlot extends DBConnect {
    
    /**
     * Thêm Slot mới vào database
     */
    public int addSlot(Slot slot) {
        String sql = "INSERT INTO Slot (TutorID, StartTime, EndTime, SubjectID, Status) VALUES (?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, slot.getTutorID());
            ps.setTimestamp(2, slot.getStartTime());
            ps.setTimestamp(3, slot.getEndTime());
            ps.setInt(4, slot.getSubjectID());
            ps.setString(5, slot.getStatus());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1); // Trả về SlotID vừa tạo
                    }
                }
            }
            
            return -1; // Thất bại
            
        } catch (SQLException e) {
            System.out.println("Lỗi khi thêm Slot: " + e.getMessage());
            e.printStackTrace();
            return -1;
        }
    }
    
    /**
     * Lấy Slot theo ID
     */
    public Slot getSlotById(int slotId) {
        String sql = "SELECT * FROM Slot WHERE SlotID = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, slotId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Slot(
                        rs.getInt("SlotID"),
                        rs.getInt("TutorID"),
                        rs.getTimestamp("StartTime"),
                        rs.getTimestamp("EndTime"),
                        rs.getInt("SubjectID"),
                        rs.getString("Status")
                    );
                }
            }
            
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy Slot: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Lấy danh sách Slot theo TutorID
     */
    public List<Slot> getSlotsByTutor(int tutorId) {
        String sql = "SELECT * FROM Slot WHERE TutorID = ? ORDER BY StartTime";
        List<Slot> slots = new ArrayList<>();
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, tutorId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    slots.add(new Slot(
                        rs.getInt("SlotID"),
                        rs.getInt("TutorID"),
                        rs.getTimestamp("StartTime"),
                        rs.getTimestamp("EndTime"),
                        rs.getInt("SubjectID"),
                        rs.getString("Status")
                    ));
                }
            }
            
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy danh sách Slot: " + e.getMessage());
            e.printStackTrace();
        }
        
        return slots;
    }
    
    /**
     * Cập nhật trạng thái Slot
     */
    public boolean updateSlotStatus(int slotId, String status) {
        String sql = "UPDATE Slot SET Status = ? WHERE SlotID = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, slotId);
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.out.println("Lỗi khi cập nhật Slot: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Xóa Slot
     */
    public boolean deleteSlot(int slotId) {
        String sql = "DELETE FROM Slot WHERE SlotID = ?";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, slotId);
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.out.println("Lỗi khi xóa Slot: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
