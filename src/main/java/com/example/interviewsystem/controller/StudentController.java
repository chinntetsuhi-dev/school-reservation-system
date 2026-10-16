package com.example.interviewsystem.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class StudentController {

    @GetMapping("/student-home")
    public String showStudentHome(Model model) {
        model.addAttribute("finalSlot", SlotController.finalSlot);
        return "student-home";
    }
}