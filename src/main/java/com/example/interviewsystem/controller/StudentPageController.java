package com.example.interviewsystem.controller;

import com.example.interviewsystem.dao.FinalPlanDao;
import com.example.interviewsystem.dao.NoticeDao;
import com.example.interviewsystem.dao.ParentRequestDao;
import com.example.interviewsystem.dao.ReservationDao;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class StudentPageController {

    private final ParentRequestDao parentRequestDao = new ParentRequestDao();
    private final ReservationDao reservationDao = new ReservationDao();
    private final FinalPlanDao finalPlanDao = new FinalPlanDao();
    private final NoticeDao noticeDao = new NoticeDao();

    @GetMapping("/student/home")
    public String studentHome(Model model) {
        model.addAttribute("notices", noticeDao.findActiveForRole("STUDENT"));
        return "student/home";
    }

    @GetMapping("/student/status")
    public String studentStatus(Model model) {
        model.addAttribute("parentRequests", parentRequestDao.findAll());
        model.addAttribute("reservationOptions", reservationDao.findAllOptions());
        model.addAttribute("finalPlans", finalPlanDao.findAll());
        return "student/status";
    }

    @GetMapping("/student/chat")
    public String studentChat() {
        return "redirect:/chat/rooms";
    }
}