package com.example.interviewsystem.controller;

import com.example.interviewsystem.dao.FinalPlanDao;
import com.example.interviewsystem.dao.ParentRequestDao;
import com.example.interviewsystem.dao.ReservationDao;
import com.example.interviewsystem.dao.UserDao;
import com.example.interviewsystem.model.ChildInfo;
import com.example.interviewsystem.model.ReservationOption;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Controller
public class ParentController {

    private final ReservationDao reservationDao =
            new ReservationDao();

    private final ParentRequestDao parentRequestDao =
            new ParentRequestDao();

    private final UserDao userDao =
            new UserDao();

    private final FinalPlanDao finalPlanDao =
            new FinalPlanDao();

    @GetMapping("/parent/reservation")
    public String reservationPage(
            HttpSession session,
            @RequestParam(
                    value = "date",
                    required = false
            ) String date,
            @RequestParam(
                    value = "error",
                    required = false
            ) String error,
            Model model) {

        Long parentUserId =
                (Long) session.getAttribute("loginUserId");

        String role =
                (String) session.getAttribute("loginRole");

        if (parentUserId == null
                || !"PARENT".equals(role)) {

            return "redirect:/login";
        }

        List<ReservationOption> options =
                reservationDao.findAllOptions();

        List<ChildInfo> children =
                userDao.findChildrenByParentId(parentUserId);

        List<com.example.interviewsystem.model.ParentRequest>
                parentRequests =
                parentRequestDao.findByParentUserId(
                        parentUserId
                );

        Set<Long> alreadySubmittedChildIds =
                new HashSet<Long>();

        for (com.example.interviewsystem.model.ParentRequest
                request : parentRequests) {

            if (request.getChildUserId() != null) {
                alreadySubmittedChildIds.add(
                        request.getChildUserId()
                );
            }
        }

        List<ChildInfo> childrenToSubmit =
                new ArrayList<ChildInfo>();

        for (ChildInfo child : children) {
            if (!alreadySubmittedChildIds.contains(
                    child.getChildUserId())) {

                childrenToSubmit.add(child);
            }
        }

        Map<String, ReservationOption> optionMap =
                new HashMap<String, ReservationOption>();

        Set<Long> availableOptionIds =
                new HashSet<Long>();

        for (ReservationOption option : options) {
            optionMap.put(
                    option.getDate()
                            + "_"
                            + option.getTime(),
                    option
            );

            if (option.isAvailable()) {
                availableOptionIds.add(option.getId());
            }
        }

        model.addAttribute("options", options);
        model.addAttribute("children", children);

        model.addAttribute(
                "childrenToSubmit",
                childrenToSubmit
        );

        model.addAttribute(
                "parentRequests",
                parentRequests
        );

        model.addAttribute(
                "dates",
                reservationDao.findFixedDates()
        );

        model.addAttribute(
                "times",
                reservationDao.findFixedTimes()
        );

        model.addAttribute("optionMap", optionMap);

        model.addAttribute(
                "availableOptionIds",
                availableOptionIds
        );

        model.addAttribute(
                "multipleChildren",
                childrenToSubmit.size() > 1
        );

        if ("duplicate".equals(error)) {
            model.addAttribute(
                    "errorMessage",
                    "この児童はすでに希望を提出しています。"
                            + "処理が完了するまで再提出できません。"
            );

        } else if ("invalid".equals(error)) {
            model.addAttribute(
                    "errorMessage",
                    "第1希望から第3希望まで、"
                            + "利用可能な異なる時間を選択してください。"
            );
        }

        return "parent/reservation";
    }

    @PostMapping("/parent/submit-requests")
    public String submitRequests(
            HttpSession session,
            @RequestParam("childUserIds")
            List<Long> childUserIds,
            @RequestParam("firstOptionIds")
            List<Long> firstOptionIds,
            @RequestParam("secondOptionIds")
            List<Long> secondOptionIds,
            @RequestParam("thirdOptionIds")
            List<Long> thirdOptionIds,
            @RequestParam(
                    value = "comments",
                    required = false
            )
            List<String> comments) {

        Long parentUserId =
                (Long) session.getAttribute("loginUserId");

        String role =
                (String) session.getAttribute("loginRole");

        if (parentUserId == null
                || !"PARENT".equals(role)) {

            return "redirect:/login";
        }

        int size = childUserIds.size();

        if (size == 0
                || firstOptionIds.size() != size
                || secondOptionIds.size() != size
                || thirdOptionIds.size() != size) {

            return "redirect:/parent/reservation"
                    + "?error=invalid";
        }

        Map<Long, ChildInfo> ownChildren =
                new HashMap<Long, ChildInfo>();

        for (ChildInfo child :
                userDao.findChildrenByParentId(
                        parentUserId)) {

            ownChildren.put(
                    child.getChildUserId(),
                    child
            );
        }

        for (int i = 0; i < size; i++) {

            Long childUserId =
                    childUserIds.get(i);

            if (!ownChildren.containsKey(childUserId)
                    || parentRequestDao
                    .existsUnfinishedRequestByChildUserId(
                            childUserId)) {

                return "redirect:/parent/reservation"
                        + "?error=duplicate";
            }

            List<Long> selectedIds =
                    new ArrayList<Long>();

            selectedIds.add(firstOptionIds.get(i));
            selectedIds.add(secondOptionIds.get(i));
            selectedIds.add(thirdOptionIds.get(i));

            if (!reservationDao.areAvailableOptions(
                    selectedIds)) {

                return "redirect:/parent/reservation"
                        + "?error=invalid";
            }
        }

        for (int i = 0; i < size; i++) {

            ChildInfo child =
                    ownChildren.get(
                            childUserIds.get(i)
                    );

            String comment =
                    comments != null
                            && comments.size() > i
                            ? comments.get(i)
                            : null;

            parentRequestDao.insert(
                    parentUserId,
                    child.getChildUserId(),
                    child.getChildName(),
                    firstOptionIds.get(i),
                    secondOptionIds.get(i),
                    thirdOptionIds.get(i),
                    comment
            );
        }

        return "redirect:/parent/reservation";
    }

    /*
     * 旧画面から送信された場合にも対応します。
     */
    @PostMapping("/parent/submit-request")
    public String submitRequest(
            HttpSession session,
            @RequestParam("childUserId")
            Long childUserId,
            @RequestParam("firstOptionId")
            Long firstOptionId,
            @RequestParam(
                    value = "secondOptionId",
                    required = false
            )
            Long secondOptionId,
            @RequestParam(
                    value = "thirdOptionId",
                    required = false
            )
            Long thirdOptionId,
            @RequestParam(
                    value = "comment",
                    required = false
            )
            String comment) {

        Long parentUserId =
                (Long) session.getAttribute("loginUserId");

        String role =
                (String) session.getAttribute("loginRole");

        if (parentUserId == null
                || !"PARENT".equals(role)) {

            return "redirect:/login";
        }

        if (parentRequestDao
                .existsUnfinishedRequestByChildUserId(
                        childUserId)) {

            return "redirect:/parent/reservation"
                    + "?error=duplicate";
        }

        List<ChildInfo> children =
                userDao.findChildrenByParentId(
                        parentUserId
                );

        ChildInfo selectedChild = null;

        for (ChildInfo child : children) {
            if (child.getChildUserId()
                    .equals(childUserId)) {

                selectedChild = child;
                break;
            }
        }

        if (selectedChild == null) {
            return "redirect:/parent/reservation";
        }

        List<Long> selectedIds =
                new ArrayList<Long>();

        selectedIds.add(firstOptionId);
        selectedIds.add(secondOptionId);
        selectedIds.add(thirdOptionId);

        if (!reservationDao.areAvailableOptions(
                selectedIds)) {

            return "redirect:/parent/reservation"
                    + "?error=invalid";
        }

        parentRequestDao.insert(
                parentUserId,
                childUserId,
                selectedChild.getChildName(),
                firstOptionId,
                secondOptionId,
                thirdOptionId,
                comment
        );

        return "redirect:/parent/reservation";
    }

    @PostMapping("/parent/confirm-reservation")
    public String confirmReservation(
            HttpSession session,
            @RequestParam("requestId")
            Long requestId) {

        Long parentUserId =
                (Long) session.getAttribute("loginUserId");

        String role =
                (String) session.getAttribute("loginRole");

        if (parentUserId == null
                || !"PARENT".equals(role)) {

            return "redirect:/login";
        }

        parentRequestDao.updateStatus(
                requestId,
                "CONFIRMED"
        );

        finalPlanDao
                .updateResponseStatusByRequestId(
                        requestId,
                        "CONFIRMED"
                );

        return "redirect:/parent/reservation";
    }

    @GetMapping("/parent/reservation-info")
    public String reservationInfo() {
        return "redirect:/parent/reservation";
    }
}