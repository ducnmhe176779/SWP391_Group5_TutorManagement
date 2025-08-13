package entity;

public class Subject {

    private int subjectID;
    private String subjectName;
    private String description;
    
    private int tutorID; // Thêm
    private String userName; // Thêm
    private int bookingCount;
    private String status;

    public Subject() {
    }

    public Subject(int subjectID, String subjectName, String description, int tutorID, String userName, String status) {
        this.subjectID = subjectID;
        this.subjectName = subjectName;
        this.description = description;
        this.tutorID = tutorID;
        this.userName = userName;
        this.status = status;
    }

    // Constructor cho getAllTutorSubjects
    public Subject(int subjectID, String description, int tutorID, String userName) {
        this.subjectID = subjectID;
        this.description = description;
        this.tutorID = tutorID;
        this.userName = userName;
    }

    public Subject(int subjectID, String SubjectName, int tutorID) {
        this.subjectID = subjectID;
        this.subjectName = SubjectName;
        this.tutorID = tutorID;
        // Sửa đổi: Thêm giá trị mặc định cho status
        this.status = "Active";
    }

    public Subject(int subjectID, String subjectName, String description) {
        this.subjectID = subjectID;
        this.subjectName = subjectName;
        this.description = description;
        // Sửa đổi: Thêm giá trị mặc định cho status
        this.status = "Active";
    }

    // Sửa đổi: Thêm constructor mới để hỗ trợ status mà không cần tutorID và userName
    public Subject(int subjectID, String subjectName, String description, String status) {
        this.subjectID = subjectID;
        this.subjectName = subjectName;
        this.description = description;
        this.status = status != null ? status : "Active";
    }

    // Sửa đổi: Thêm constructor mặc định với status
    public Subject(int subjectID, String subjectName, String description, int tutorID, String userName) {
        this.subjectID = subjectID;
        this.subjectName = subjectName;
        this.description = description;
        this.tutorID = tutorID;
        this.userName = userName;
        this.status = "Active";
    }

    public int getSubjectID() {
        return subjectID;
    }

    public void setSubjectID(int subjectID) {
        this.subjectID = subjectID;
    }

    public String getSubjectName() {
        return subjectName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getTutorID() {
        return tutorID;
    }

    public void setTutorID(int tutorID) {
        this.tutorID = tutorID;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    
    public int getBookingCount() {
        return bookingCount;
    }

    public void setBookingCount(int bookingCount) {
        this.bookingCount = bookingCount;
    }
}