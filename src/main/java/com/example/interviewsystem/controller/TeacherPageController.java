package com.example.interviewsystem.controller;

import com.example.interviewsystem.dao.FinalPlanDao;
import com.example.interviewsystem.dao.NoticeDao;
import com.example.interviewsystem.dao.ParentRequestDao;
import com.example.interviewsystem.dao.ReservationDao;
import com.example.interviewsystem.model.FinalPlan;
import com.example.interviewsystem.model.ParentRequest;
import com.example.interviewsystem.model.ReservationOption;
import com.example.interviewsystem.model.ScheduleStatus;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class TeacherPageController {

    private final ReservationDao reservationDao =
            new ReservationDao();

    private final ParentRequestDao parentRequestDao =
            new ParentRequestDao();

    private final FinalPlanDao finalPlanDao =
            new FinalPlanDao();

    private final NoticeDao noticeDao =
            new NoticeDao();

    @GetMapping("/teacher/home")
    public String teacherHome(Model model) {

        model.addAttribute(
                "notices",
                noticeDao.findAll()
        );

        return "teacher/home";
    }

    @GetMapping("/teacher/notices/form")
    public String noticeForm(
            @RequestParam(
                    value = "id",
                    required = false
            )
            Long id,
            Model model) {

        if (id != null) {
            model.addAttribute(
                    "editingNotice",
                    noticeDao.findById(id)
            );

        } else {
            model.addAttribute(
                    "editingNotice",
                    null
            );
        }

        return "teacher/notice-form";
    }

    @PostMapping("/teacher/notices/create")
    public String createNotice(
            @RequestParam("title")
            String title,
            @RequestParam("content")
            String content,
            @RequestParam("targetRole")
            String targetRole,
            @RequestParam(
                    value = "active",
                    required = false
            )
            String active) {

        noticeDao.insert(
                title,
                content,
                active != null,
                targetRole
        );

        return "redirect:/teacher/home";
    }

    @PostMapping("/teacher/notices/update")
    public String updateNotice(
            @RequestParam("id")
            Long id,
            @RequestParam("title")
            String title,
            @RequestParam("content")
            String content,
            @RequestParam("targetRole")
            String targetRole,
            @RequestParam(
                    value = "active",
                    required = false
            )
            String active) {

        noticeDao.update(
                id,
                title,
                content,
                active != null,
                targetRole
        );

        return "redirect:/teacher/home";
    }

    @PostMapping("/teacher/notices/toggle")
    public String toggleNotice(
            @RequestParam("id")
            Long id) {

        noticeDao.toggle(id);

        return "redirect:/teacher/home";
    }

    @PostMapping("/teacher/notices/delete")
    public String deleteNotice(
            @RequestParam("id")
            Long id) {

        noticeDao.delete(id);

        return "redirect:/teacher/home";
    }

    @GetMapping("/teacher/notices")
    public String noticeManagement() {
        return "redirect:/teacher/home";
    }

    @GetMapping("/teacher/slots")
    public String teacherSlots(
            @RequestParam(
                    value = "saved",
                    required = false
            )
            String saved,
            Model model) {

        List<ReservationOption> options =
                reservationDao.findAllOptions();

        Map<String, ReservationOption> optionMap =
                new HashMap<>();

        for (ReservationOption option : options) {
            optionMap.put(
                    option.getDate()
                            + "_"
                            + option.getTime(),
                    option
            );
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
                "optionMap",
                optionMap
        );

        model.addAttribute(
                "saved",
                "1".equals(saved)
        );

        return "teacher/slots";
    }

    @PostMapping("/teacher/slots/save")
    public String saveTeacherSlots(
            @RequestParam(
                    value = "availableOptionIds",
                    required = false
            )
            List<Long> availableOptionIds) {

        reservationDao.saveAvailableOptions(
                availableOptionIds
        );

        return "redirect:/teacher/slots?saved=1";
    }

    @GetMapping("/teacher/schedule")
    public String teacherSchedule(Model model) {

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

        return "teacher/schedule";
    }

    @GetMapping("/teacher/reservations")
    public String teacherReservations(Model model) {

        model.addAttribute(
                "finalPlans",
                finalPlanDao.findAll()
        );

        model.addAttribute(
                "parentRequests",
                parentRequestDao.findAll()
        );

        model.addAttribute(
                "reservationOptions",
                reservationDao.findAllOptions()
        );

        return "teacher/reservations";
    }

    @GetMapping("/teacher/requests")
    public String teacherRequests(
            @RequestParam(
                    value = "optionId",
                    required = false
            )
            Long optionId,
            @RequestParam(
                    value = "error",
                    required = false
            )
            String error,
            Model model) {

        model.addAttribute(
                "parentRequests",
                parentRequestDao
                        .findUnfinishedForTeacher(
                                optionId
                        )
        );

        model.addAttribute(
                "reservationOptions",
                reservationDao.findAllOptions()
        );

        model.addAttribute(
                "finalPlans",
                finalPlanDao.findAll()
        );

        model.addAttribute(
                "selectedOptionId",
                optionId
        );

        if ("unavailable".equals(error)) {
            model.addAttribute(
                    "errorMessage",
                    "選択した時間はすでに使用されています。"
                            + "別の希望時間を選択してください。"
            );
        }

        return "teacher/requests";
    }

    @PostMapping("/teacher/confirm-request")
    public String confirmRequest(
            @RequestParam("requestId")
            Long requestId,
            @RequestParam("selectedOptionId")
            Long selectedOptionId,
            @RequestParam(
                    value = "teacherComment",
                    required = false
            )
            String teacherComment) {

        ParentRequest targetRequest =
                parentRequestDao.findById(requestId);

        if (targetRequest == null) {
            return "redirect:/teacher/requests";
        }

        if ("CONFIRMED".equals(
                targetRequest.getRequestStatus())) {

            return "redirect:/teacher/requests";
        }

        FinalPlan existingPlan =
                finalPlanDao.findByRequestId(requestId);

        if (existingPlan != null) {
            reservationDao.updateAvailable(
                    existingPlan.getSelectedOptionId(),
                    true
            );
        }

        ReservationOption selectedOption =
                reservationDao.findOptionById(
                        selectedOptionId
                );

        if (selectedOption == null
                || !selectedOption.isAvailable()) {

            String suffix =
                    targetRequest.getFirstOption() == null
                            ? ""
                            : "?optionId="
                            + targetRequest
                            .getFirstOption()
                            .getId()
                            + "&error=unavailable";

            return "redirect:/teacher/requests"
                    + suffix;
        }

        String nextStatus = "WAITING_PARENT";

        if (targetRequest.getFirstOption() != null
                && targetRequest
                .getFirstOption()
                .getId()
                .equals(selectedOptionId)) {

            nextStatus = "CONFIRMED";
        }

        finalPlanDao.saveOrUpdate(
                requestId,
                selectedOptionId,
                teacherComment
        );

        finalPlanDao
                .updateResponseStatusByRequestId(
                        requestId,
                        nextStatus
                );

        parentRequestDao.updateStatus(
                requestId,
                nextStatus
        );

        reservationDao.updateAvailable(
                selectedOptionId,
                false
        );

        return "redirect:/teacher/schedule-build";
    }

    @PostMapping("/teacher/cancel-reservation")
    public String cancelReservation(
            @RequestParam("requestId")
            Long requestId) {

        FinalPlan targetPlan =
                finalPlanDao.findByRequestId(requestId);

        if (targetPlan != null) {
            reservationDao.updateAvailable(
                    targetPlan.getSelectedOptionId(),
                    true
            );

            finalPlanDao.deleteByRequestId(
                    requestId
            );
        }

        parentRequestDao.updateStatus(
                requestId,
                "SUBMITTED"
        );

        return "redirect:/teacher/reservations";
    }

    @GetMapping("/teacher/chatrooms")
    public String teacherChatrooms() {
        return "redirect:/chat/rooms";
    }
}