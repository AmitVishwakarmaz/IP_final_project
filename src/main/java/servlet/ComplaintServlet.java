package servlet;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.ComplaintDAO;
import model.Complaint;

@SuppressWarnings("serial")
@WebServlet("/ComplaintServlet")
public class ComplaintServlet extends HttpServlet {

    private ComplaintDAO dao = new ComplaintDAO();

    // ── GET: delete action ──────────────────────────────────────
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        String role   = (String) session.getAttribute("role");
        String action = req.getParameter("action");

        if ("delete".equals(action) && "admin".equals(role)) {
            int id = Integer.parseInt(req.getParameter("id"));
            dao.deleteComplaint(id);
        }

        res.sendRedirect("viewComplaint.jsp");
    }

    // ── POST: save or update ────────────────────────────────────
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        String role   = (String) session.getAttribute("role");
        String action = req.getParameter("action");

        if ("update".equals(action)) {

            int id = Integer.parseInt(req.getParameter("id"));

            Complaint c = new Complaint();
            c.setId         (id);
            c.setName       (req.getParameter("name"));
            c.setEmail      (req.getParameter("email"));
            c.setSubject    (req.getParameter("subject"));
            c.setDescription(req.getParameter("description"));
            c.setCategory   (req.getParameter("category"));
            c.setPriority   (req.getParameter("priority"));

            if ("admin".equals(role)) {
                c.setStatus(req.getParameter("status"));
            } else {
                Complaint old = dao.getComplaintById(id);
                c.setStatus(old != null ? old.getStatus() : "Pending");
            }

            dao.updateComplaint(c);

        } else {
            // NEW complaint
            String username = (String) session.getAttribute("username");

            Complaint c = new Complaint(
                req.getParameter("name"),
                req.getParameter("email"),
                req.getParameter("subject"),
                req.getParameter("description"),
                req.getParameter("category"),
                req.getParameter("priority"),
                username
            );

            dao.saveComplaint(c);
        }

        res.sendRedirect("viewComplaint.jsp");
    }
}
