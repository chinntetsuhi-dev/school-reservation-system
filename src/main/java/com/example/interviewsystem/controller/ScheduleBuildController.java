package com.example.interviewsystem.controller;

import com.example.interviewsystem.dao.ScheduleBuildDao;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ScheduleBuildController {

    private final ScheduleBuildDao scheduleBuildDao =
            new ScheduleBuildDao();

    @GetMapping("/teacher/schedule-build")
    public String scheduleBuild(
            @RequestParam(
                    value = "message",
                    required = false
            )
            String message,
            Model model) {

        model.addAttribute(
                "summary",
                scheduleBuildDao.getSummary()
        );

        model.addAttribute(
                "manualCount",
                scheduleBuildDao.countManualRequired()
        );

        model.addAttribute(
                "submissionRows",
                scheduleBuildDao.findSubmissionRows()
        );

        if ("published".equals(message)) {
            model.addAttribute(
                    "successMessage",
                    "日程を公開しました。"
            );
        }

        if ("manualRemaining".equals(message)) {
            model.addAttribute(
                    "errorMessage",
                    "手動確認が必要な候補があります。"
                            + "すべて処理してから公開してください。"
            );
        }

        return "teacher/schedule-build";
    }

    @PostMapping("/teacher/schedule-build/auto")
    public String executeAutoAssign() {

        scheduleBuildDao.executeAutoAssign();

        return "redirect:/teacher/schedule-change";
    }

    @PostMapping("/teacher/schedule-build/publish")
    public String publishSchedule() {

        boolean success =
                scheduleBuildDao.publishSchedule();

        if (success) {
            return "redirect:/teacher/schedule";
        }

        return "redirect:/teacher/schedule-change"
                + "?message=manualRemaining";
    }
}