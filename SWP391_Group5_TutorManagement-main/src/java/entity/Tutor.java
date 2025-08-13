/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

/**
 *
 * @author Heizxje
 */
public class Tutor {
    private int tutorID;
    private int CVID;
    private float rating;
    private float price;
    
    private Cv cv; // hungnv don't delete
    
    public Tutor() {
    }

    public Tutor(int tutorID, int CVID, float rating) {
        this.tutorID = tutorID;
        this.CVID = CVID;
        this.rating = rating;
    }

    public Tutor(int tutorID, int CVID, float rating, float price) {
        this.tutorID = tutorID;
        this.CVID = CVID;
        this.rating = rating;
        this.price = price;
    }

    public float getPrice() {
        return price;
    }

    public void setPrice(float price) {
        this.price = price;
    }
    public int getTutorID() {
        return tutorID;
    }

    public void setTutorID(int tutorID) {
        this.tutorID = tutorID;
    }

    public int getCVID() {
        return CVID;
    }

    public void setCVID(int CVID) {
        this.CVID = CVID;
    }

    public float getRating() {
        return rating;
    }

    public void setRating(float rating) {
        this.rating = rating;
    }

    public Cv getCv() {
        return cv;
    }

    public void setCv(Cv cv) {
        this.cv = cv;
    }
}
