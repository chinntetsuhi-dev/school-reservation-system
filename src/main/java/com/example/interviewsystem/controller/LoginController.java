package com.example.interviewsystem.controller;

import com.example.interviewsystem.dao.UserDao;
import com.example.interviewsystem.model.User;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;

@Controller
public class LoginController {

    private final UserDao userDao = new UserDao();

    @GetMapping("/")
    public String root() {
        return "redirect:/login";
    }

    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }

    @PostMapping("/login")
    public String login(
            @RequestParam("loginId") String loginId,
            @RequestParam("password") String password,
            HttpSession session,
            Model model) {

        User user = userDao.findByLoginIdAndPassword(loginId, password);

        if (user == null) {
            model.addAttribute("error", "ユーザーIDまたはパスワードが違います。");
            return "login";
        }

        session.setAttribute("loginUserId", user.getId());
        session.setAttribute("loginUsername", user.getLoginId());
        session.setAttribute("loginRole", user.getRole());
        session.setAttribute("loginDisplayName", user.getDisplayName());
        session.setMaxInactiveInterval(60 * 60 * 2);

        if ("TEACHER".equals(user.getRole())) {
            return "redirect:/teacher/home";
        }

        if ("PARENT".equals(user.getRole())) {
            return "redirect:/parent/home";
        }

        if ("STUDENT".equals(user.getRole())) {
            return "redirect:/student/home";
        }

        model.addAttribute("error", "権限情報が正しくありません。");
        return "login";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}