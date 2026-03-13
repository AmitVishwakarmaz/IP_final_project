package servlet;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.UserDAO;
import model.User;

@SuppressWarnings("serial")
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private UserDAO dao = new UserDAO();

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        // Basic null + trim safety
        if (username == null || password == null ||
            username.trim().isEmpty() || password.trim().isEmpty()) {

            req.setAttribute("error", "Username and Password required");
            RequestDispatcher rd = req.getRequestDispatcher("login.jsp");
            rd.forward(req, res);
            return;
        }

        username = username.trim();
        password = password.trim();

        User user = dao.validateUser(username, password);

        if (user != null) {

            HttpSession oldSession = req.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }

            HttpSession session = req.getSession(true);
            session.setAttribute("username", user.getUsername());
            session.setAttribute("role", user.getRole());

            // Optional: set session timeout (30 minutes)
            session.setMaxInactiveInterval(30 * 60);

            // Role-based redirect
            if ("admin".equals(user.getRole())) {
                res.sendRedirect("dashboard.jsp");
            } else {
                res.sendRedirect("dashboard.jsp");
            }
//            res.sendRedirect("dashboard.jsp");


        } else {
            req.setAttribute("error", "Invalid username or password");
            RequestDispatcher rd = req.getRequestDispatcher("login.jsp");
            rd.forward(req, res);
        }
    }
}
