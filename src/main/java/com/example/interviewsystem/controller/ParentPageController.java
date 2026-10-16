package com.example.interviewsystem.controller;

import com.example.interviewsystem.dao.FinalPlanDao;
import com.example.interviewsystem.dao.NoticeDao;
import com.example.interviewsystem.dao.ParentRequestDao;
import com.example.interviewsystem.dao.ReservationDao;
import com.example.interviewsystem.dao.UserDao;
import com.example.interviewsystem.model.ChildInfo;
import com.example.interviewsystem.model.FinalPlan;
import com.example.interviewsystem.model.ParentRequest;
import com.example.interviewsystem.model.ReservationOption;
import com.example.interviewsystem.model.ScheduleStatus;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ParentPageController {

    private final NoticeDao noticeDao =
            new NoticeDao();

    private final ReservationDao reservationDao =
            new ReservationDao();

    private final ParentRequestDao parentRequestDao =
            new ParentRequestDao();

    private final FinalPlanDao finalPlanDao =
            new FinalPlanDao();

    private final UserDao userDao =
            new UserDao();

    @GetMapping("/parent/home")
    public String parentHome(Model model) {

        model.addAttribute(
                "notices",
                noticeDao.findActiveForRole("PARENT")
        );

        return "parent/home";
    }

    @GetMapping("/parent/schedule")
    public String parentSchedule(
            HttpSession session,
            Model model) {

        Long parentUserId =
                (Long) session.getAttribute("loginUserId");

        String role =
                (String) session.getAttribute("loginRole");

        if (parentUserId == null
                || !"PARENT".equals(role)) {

            return "redirect:/login";
        }

        List<ScheduleStatus> scheduleList =
                reservationDao.findScheduleStatus(null);

        Map<String, ScheduleStatus> scheduleMap =
                new HashMap<>();

        for (ScheduleStatus status : scheduleList) {
            scheduleMap.put(
                    status.getDate()
                            + "_"
                            + status.getTime(),
                    status
            );
        }

        List<ChildInfo> children =
                userDao.findChildrenByParentId(
                        parentUserId
                );

        Map<Long, ReservationOption>
                confirmedOptionsByChildId =
                new HashMap<>();

        for (ParentRequest request :
                parentRequestDao.findByParentUserId(
                        parentUserId)) {

            FinalPlan plan =
                    finalPlanDao.findByRequestId(
                            request.getId()
                    );

            if (plan != null
                    && "CONFIRMED".equals(
                    plan.getResponseStatus())) {

                confirmedOptionsByChildId.put(
                        request.getChildUserId(),
                        reservationDao.findOptionById(
                                plan.getSelectedOptionId()
                        )
                );
            }
        }

        model.addAttribute(
                "dates",
                reservationDao.findFixedDates()
        );

        model.addAttribute(
                "times",
                reservationDao.findFixedTimes()
        );

        model.addAttribute(
                "scheduleMap",
                scheduleMap
        );

        model.addAttribute("children", children);

        model.addAttribute(
                "confirmedOptionsByChildId",
                confirmedOptionsByChildId
        );

        return "parent/schedule";
    }

    @GetMapping("/parent/chat")
    public String parentChat() {
        return "redirect:/chat/rooms";
    }
}