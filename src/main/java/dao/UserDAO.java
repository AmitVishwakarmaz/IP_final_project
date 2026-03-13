package dao;

import java.sql.*;
import model.User;
import util.DBConnection;

public class UserDAO {

    public void saveUser(User u) {

        String sql = "INSERT INTO users(username, password, role) VALUES(?,?,?)";

        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)){

            ps.setString(1, u.getUsername());
            ps.setString(2, u.getPassword());
            ps.setString(3, u.getRole());

            ps.executeUpdate();

        }catch(Exception e){
            e.printStackTrace();
        }
    }

    public User validateUser(String username, String password){

        User u = null;
        String sql = "SELECT * FROM users WHERE username=? AND password=?";

        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)){

            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setRole(rs.getString("role"));
            }

        }catch(Exception e){
            e.printStackTrace();
        }

        return u;
    }
    
    public boolean isUsernameExists(String username) {

        boolean exists = false;
        String sql = "SELECT id FROM users WHERE username=?";

        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)){

            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                exists = true;
            }

        }catch(Exception e){
            e.printStackTrace();
        }

        return exists;
    }

}
