package com.example.interviewsystem.dao;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

public class JpaUtil {

    private static final EntityManagerFactory emf =
            Persistence.createEntityManagerFactory("interviewPU");

    public static EntityManager createEntityManager() {
        return emf.createEntityManager();
    }
}