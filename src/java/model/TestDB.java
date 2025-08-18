package model;

public class TestDB {
    public static void main(String[] args) {
        System.out.println("Testing database connection...");
        
        try {
            DBConnect db = new DBConnect();
            System.out.println("DBConnect created successfully");
            
            DAOSubject dao = new DAOSubject();
            System.out.println("DAOSubject created successfully");
            
            // Test connection
            boolean connectionOk = dao.testConnection();
            System.out.println("Connection test: " + connectionOk);
            
            // Test Subject table
            boolean tableOk = dao.checkSubjectTable();
            System.out.println("Subject table test: " + tableOk);
            
            // Test get total subjects
            int total = dao.getTotalSubjects();
            System.out.println("Total subjects: " + total);
            
            // Test get all subjects
            var subjects = dao.getAllSubjects();
            System.out.println("All subjects count: " + (subjects != null ? subjects.size() : "null"));
            
            // Test pagination
            var pageSubjects = dao.getSubjectsByPage(1, 5);
            System.out.println("Page 1 subjects count: " + (pageSubjects != null ? pageSubjects.size() : "null"));
            
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}

