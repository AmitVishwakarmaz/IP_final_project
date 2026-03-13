package servlet;

import java.io.IOException;
import java.util.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.ComplaintDAO;

@SuppressWarnings("serial")
@WebServlet("/AnalyticsServlet")
public class AnalyticsServlet extends HttpServlet {

    private ComplaintDAO dao = new ComplaintDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // Admin-only
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            res.sendRedirect("login.jsp");
            return;
        }

        // Fetch analytics data
        Map<String, Integer> byCategory = dao.getCountByCategory();
        Map<String, Integer> byStatus   = dao.getCountByStatus();
        Map<String, Integer> byPriority = dao.getCountByPriority();
        Map<String, Integer> monthly    = dao.getMonthlyTrend();
        int total                       = dao.getTotalCount();

        // Compute stat card values from byStatus
        int pending    = byStatus.getOrDefault("Pending",     0);
        int inProgress = byStatus.getOrDefault("In Progress", 0);
        int resolved   = byStatus.getOrDefault("Resolved",   0);
        int rejected   = byStatus.getOrDefault("Rejected",   0);

        req.setAttribute("byCategory", byCategory);
        req.setAttribute("byStatus",   byStatus);
        req.setAttribute("byPriority", byPriority);
        req.setAttribute("monthly",    monthly);
        req.setAttribute("total",      total);
        req.setAttribute("pending",    pending);
        req.setAttribute("inProgress", inProgress);
        req.setAttribute("resolved",   resolved);
        req.setAttribute("rejected",   rejected);

        req.getRequestDispatcher("analytics.jsp").forward(req, res);
    }
}
