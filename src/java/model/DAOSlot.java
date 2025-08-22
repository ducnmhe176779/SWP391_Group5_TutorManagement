package model;

import entity.Schedule;
import entity.Slot;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DAOSlot extends DBConnect {

    public int addSlot(Slot slot) {
        int result = 0;
        String sql = "INSERT INTO Slot (ScheduleID, Status) VALUES (?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, slot.getScheduleID());
            ps.setString(2, slot.getStatus());
            result = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public int updateSlot(Slot slot) {
        int result = 0;
        String sql = "UPDATE Slot SET ScheduleID = ?, Status = ? WHERE SlotID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, slot.getScheduleID());
            ps.setString(2, slot.getStatus());
            ps.setInt(3, slot.getSlotID());
            result = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public int deleteSlot(int slotID) {
        int result = 0;
        String sql = "DELETE FROM Slot WHERE SlotID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, slotID);
            result = ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public List<Slot> getAllSlots() {
        List<Slot> slots = new ArrayList<>();
        String sql = """
        SELECT s.SlotID, s.ScheduleID, s.Status, 
               sc.TutorID, sc.StartTime, sc.EndTime, sc.IsBooked, sc.SubjectId
        FROM Slot s
        JOIN Schedule sc ON s.ScheduleID = sc.ScheduleID
    """;
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Slot slot = new Slot();
                slot.setSlotID(rs.getInt("SlotID"));
                slot.setScheduleID(rs.getInt("ScheduleID"));
                slot.setStatus(rs.getString("Status"));

                Schedule schedule = new Schedule();
                schedule.setScheduleID(rs.getInt("ScheduleID"));
                schedule.setTutorID(rs.getInt("TutorID"));
                schedule.setStartTime(rs.getTimestamp("StartTime"));
                schedule.setEndTime(rs.getTimestamp("EndTime"));
                schedule.setIsBooked(rs.getBoolean("IsBooked"));
                schedule.setSubjectId(rs.getInt("SubjectId"));

                slot.setSchedule(schedule);
                slots.add(slot);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return slots;
    }

    public Slot getSlotById(int slotID) {
        String sql = "SELECT * FROM Slot WHERE SlotID = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, slotID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Slot(
                        rs.getInt("SlotID"),
                        rs.getInt("ScheduleID"),
                        rs.getString("Status")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
