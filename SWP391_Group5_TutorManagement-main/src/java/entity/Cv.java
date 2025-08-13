//Hungnv
package entity;

public class Cv {
    private int cvId;
    private int userId;
    private String education;
    private String experience;
    private String certificates;
    private String status;
    private int subjectId;
    private String description;
    private String skill;
    private float price;

    private User user;
    private Subject subject;

    public Cv() {}

    public Cv(int cvId, int userId, String education, String experience, 
            String certificates, String status, int subjectId, String description) {
        this.cvId = cvId;
        this.userId = userId;
        this.education = education;
        this.experience = experience;
        this.certificates = certificates;
        this.status = status;
        this.subjectId = subjectId;
        this.description = description;
    }

    public Cv(int cvId, int userId, String education, String experience, String certificates, String status, int subjectId, String description, String skill, float price) {
        this.cvId = cvId;
        this.userId = userId;
        this.education = education;
        this.experience = experience;
        this.certificates = certificates;
        this.status = status;
        this.subjectId = subjectId;
        this.description = description;
        this.skill = skill;
        this.price = price;
        this.user = user;
        this.subject = subject;
    }
    

    public int getCvId() {
        return cvId;
    }

    public void setCvId(int cvId) {
        this.cvId = cvId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getEducation() {
        return education;
    }

    public void setEducation(String education) {
        this.education = education;
    }

    public String getExperience() {
        return experience;
    }

    public void setExperience(String experience) {
        this.experience = experience;
    }

    public String getCertificates() {
        return certificates;
    }

    public void setCertificates(String certificates) {
        this.certificates = certificates;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getSubjectId() {
        return subjectId;
    }

    public void setSubjectId(int subjectId) {
        this.subjectId = subjectId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Subject getSubject() {
        return subject;
    }

    public void setSubject(Subject subject) {
        this.subject = subject;
    }

    public String getSkill() {
        return skill;
    }

    public void setSkill(String skill) {
        this.skill = skill;
    }

    public float getPrice() {
        return price;
    }

    public void setPrice(float price) {
        this.price = price;
    }
    
    
}
