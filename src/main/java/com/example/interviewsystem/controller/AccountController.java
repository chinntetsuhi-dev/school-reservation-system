package com.example.interviewsystem.controller;

import com.example.interviewsystem.dao.UserDao;
import com.example.interviewsystem.model.ChildInfo;
import com.example.interviewsystem.model.User;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
public class AccountController {

    private final UserDao userDao = new UserDao();

    @GetMapping("/account")
    public String account(HttpSession session, Model model) {

        Long loginUserId = (Long) session.getAttribute("loginUserId");
        String role = (String) session.getAttribute("loginRole");

        if (loginUserId == null || role == null) {
            return "redirect:/login";
        }

        User user = userDao.findById(loginUserId);
        model.addAttribute("user", user);

        if ("PARENT".equals(role)) {
            List<ChildInfo> children = userDao.findChildrenByParentId(loginUserId);
            model.addAttribute("children", children);
        }

        if ("STUDENT".equals(role)) {
            User parent = userDao.findParentByChildId(loginUserId);
            model.addAttribute("parent", parent);
        }

        return "account";
    }
}