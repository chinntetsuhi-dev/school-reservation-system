package com.example.interviewsystem.controller;

import com.example.interviewsystem.model.AvailableOption;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.ArrayList;
import java.util.List;

@Controller
public class FacilityController {

    private final List<AvailableOption> options =
            new ArrayList<>();

    public FacilityController() {
        options.add(
                new AvailableOption(
                        1L,
                        "面談枠",
                        "2026-07-06",
                        "12:20"
                )
        );

        options.add(
                new AvailableOption(
                        2L,
                        "面談枠",
                        "2026-07-06",
                        "13:00"
                )
        );

        options.add(
                new AvailableOption(
                        3L,
                        "面談枠",
                        "2026-07-06",
                        "14:20"
                )
        );
    }

    @GetMapping("/facility-search")
    public String showFacilityPage(Model model) {

        model.addAttribute("options", options);

        return "facility-search";
    }
}