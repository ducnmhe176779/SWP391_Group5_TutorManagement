/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

/**
 *
 * @author minht
 */
import java.sql.Timestamp;

public class TutorRating {

    private int ratingId;
    private int bookingId;
    private int studentId;
    private int tutorId;
    private int rating;
    private String comment;
    private Timestamp ratingDate;
    private String fullName;

    public TutorRating() {
    }

    public TutorRating(int ratingId, int bookingId, int studentId, int tutorId, int rating, String comment, Timestamp ratingDate, String username) {
        this.ratingId = ratingId;
        this.bookingId = bookingId;
        this.studentId = studentId;
        this.tutorId = tutorId;
        this.rating = rating;
        this.comment = comment;
        this.ratingDate = ratingDate;
        this.fullName = fullName;
    }

    public TutorRating(int ratingId, int bookingId, int studentId, int tutorId, int rating, String comment, Timestamp ratingDate) {
        this.ratingId = ratingId;
        this.bookingId = bookingId;
        this.studentId = studentId;
        this.tutorId = tutorId;
        this.rating = rating;
        this.comment = comment;
        this.ratingDate = ratingDate;
    }
    

    public TutorRating(int ratingId, int bookingId, String fullName, int tutorId, int rating, String comment, Timestamp ratingDate) {
        this.ratingId = ratingId;
        this.bookingId = bookingId;
        this.fullName = fullName;
        this.tutorId = tutorId;
        this.rating = rating;
        this.comment = comment;
        this.ratingDate = ratingDate;
    }

    // Getters và Setters
    public int getRatingId() {
        return ratingId;
    }

    public void setRatingId(int ratingId) {
        this.ratingId = ratingId;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public int getStudentId() {
        return studentId;
    }

    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }

    public String getUsername() {
        return fullName;
    }

    public void setUsername(String fullName) {
        this.fullName = fullName;
    }

    public int getTutorId() {
        return tutorId;
    }

    public void setTutorId(int tutorId) {
        this.tutorId = tutorId;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Timestamp getRatingDate() {
        return ratingDate;
    }

    public void setRatingDate(Timestamp ratingDate) {
        this.ratingDate = ratingDate;
    }

}
