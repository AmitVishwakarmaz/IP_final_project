package servlet;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.UserDAO;
import model.User;

@SuppressWarnings("serial")
@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {

    private UserDAO dao = new UserDAO();

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if(username == null || password == null ||
           username.trim().isEmpty() || password.trim().isEmpty()){

            req.setAttribute("error", "All fields are required");
            RequestDispatcher rd = req.getRequestDispatcher("signup.jsp");
            rd.forward(req, res);
            return;
        }

        username = username.trim();
        password = password.trim();

        if(dao.isUsernameExists(username)){

            req.setAttribute("error", "Username already exists!");
            RequestDispatcher rd = req.getRequestDispatcher("signup.jsp");
            rd.forward(req, res);
            return;
        }

        User u = new User(username, password, "user");
        dao.saveUser(u);

        res.sendRedirect("login.jsp");
    }

}
