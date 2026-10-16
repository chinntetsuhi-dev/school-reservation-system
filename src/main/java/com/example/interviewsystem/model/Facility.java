package com.example.interviewsystem.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "facilities")
public class Facility {

    @Id
    private Long id;

    @Column(name = "facility_name")
    private String name;

    @Column(name = "description")
    private String description;

    @Column(name = "active_flag")
    private boolean active = true;

    public Facility() {
    }

    public Facility(Long id, String name, String description) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.active = true;
    }

    public Facility(Long id, String name, String description, boolean active) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.active = active;
    }

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getFacilityName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    public boolean isActive() {
        return active;
    }

    public boolean isActiveFlag() {
        return active;
    }

    public String getStatusLabel() {
        return active ? "利用可能" : "利用停止";
    }

    public void setId(Long id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setFacilityName(String facilityName) {
        this.name = facilityName;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public void setActiveFlag(boolean active) {
        this.active = active;
    }
}