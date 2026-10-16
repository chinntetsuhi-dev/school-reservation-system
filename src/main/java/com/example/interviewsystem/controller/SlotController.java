package com.example.interviewsystem.controller;

import com.example.interviewsystem.model.InterviewSlot;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.List;

@Controller
public class SlotController {

    public static final List<InterviewSlot> slots = new ArrayList<>();
    public static String finalSlot = null;

    @PostMapping("/teacher/add-slot")
    public String addSlot(@RequestParam("date") String date,
                          @RequestParam("time") String time) {

        Long newId = (long) (slots.size() + 1);
        slots.add(new InterviewSlot(newId, date, time, false));

        return "redirect:/teacher/reservations";
    }

    @PostMapping("/teacher/select-final-slot")
    public String selectFinalSlot(@RequestParam("finalSlot") String slot) {
        finalSlot = slot;
        return "redirect:/teacher/reservations";
    }
}