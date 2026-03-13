package dao;

import java.sql.*;
import java.util.*;
import model.Complaint;
import util.DBConnection;

public class ComplaintDAO {

    // ─────────────────────────────────────────────────────────────
    //  SAVE (INSERT)
    // ─────────────────────────────────────────────────────────────
    public void saveComplaint(Complaint c) {
        String sql = "INSERT INTO complaint "
                   + "(name, email, subject, description, category, priority, status, username) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, c.getName());
            ps.setString(2, c.getEmail());
            ps.setString(3, c.getSubject());
            ps.setString(4, c.getDescription());
            ps.setString(5, c.getCategory() != null ? c.getCategory() : "Other");
            ps.setString(6, c.getPriority() != null ? c.getPriority() : "Medium");
            ps.setString(7, c.getStatus());
            ps.setString(8, c.getUsername());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ─────────────────────────────────────────────────────────────
    //  GET ALL (admin)
    // ─────────────────────────────────────────────────────────────
    public List<Complaint> getAllComplaints() {
        List<Complaint> list = new ArrayList<>();
        String sql = "SELECT * FROM complaint ORDER BY created_at DESC";

        try (Connection con = DBConnection.getConnection();
             Statement st  = con.createStatement();
             ResultSet rs  = st.executeQuery(sql)) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ─────────────────────────────────────────────────────────────
    //  GET BY USERNAME (user's own complaints)
    // ─────────────────────────────────────────────────────────────
    public List<Complaint> getComplaintsByUsername(String username) {
        List<Complaint> list = new ArrayList<>();
        String sql = "SELECT * FROM complaint WHERE username=? ORDER BY created_at DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ─────────────────────────────────────────────────────────────
    //  FILTERED LIST (for user-side or admin filter bar)
    // ─────────────────────────────────────────────────────────────
    public List<Complaint> getComplaintsByFilter(String username, String category,
                                                  String status, String priority) {
        List<Complaint> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("SELECT * FROM complaint WHERE 1=1");
        if (username != null && !username.isEmpty()) sql.append(" AND username=?");
        if (category != null && !category.isEmpty())  sql.append(" AND category=?");
        if (status   != null && !status.isEmpty())    sql.append(" AND status=?");
        if (priority != null && !priority.isEmpty())  sql.append(" AND priority=?");
        sql.append(" ORDER BY created_at DESC");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int idx = 1;
            if (username != null && !username.isEmpty()) ps.setString(idx++, username);
            if (category != null && !category.isEmpty())  ps.setString(idx++, category);
            if (status   != null && !status.isEmpty())    ps.setString(idx++, status);
            if (priority != null && !priority.isEmpty())  ps.setString(idx++, priority);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ─────────────────────────────────────────────────────────────
    //  GET BY ID
    // ─────────────────────────────────────────────────────────────
    public Complaint getComplaintById(int id) {
        Complaint c = null;
        String sql = "SELECT * FROM complaint WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                c = mapRow(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return c;
    }

    // ─────────────────────────────────────────────────────────────
    //  UPDATE
    // ─────────────────────────────────────────────────────────────
    public void updateComplaint(Complaint c) {
        String sql = "UPDATE complaint "
                   + "SET name=?, email=?, subject=?, description=?, "
                   + "category=?, priority=?, status=? WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, c.getName());
            ps.setString(2, c.getEmail());
            ps.setString(3, c.getSubject());
            ps.setString(4, c.getDescription());
            ps.setString(5, c.getCategory() != null ? c.getCategory() : "Other");
            ps.setString(6, c.getPriority() != null ? c.getPriority() : "Medium");
            ps.setString(7, c.getStatus());
            ps.setInt   (8, c.getId());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ─────────────────────────────────────────────────────────────
    //  DELETE
    // ─────────────────────────────────────────────────────────────
    public void deleteComplaint(int id) {
        String sql = "DELETE FROM complaint WHERE id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ─────────────────────────────────────────────────────────────
    //  ANALYTICS – count by category
    // ─────────────────────────────────────────────────────────────
    public Map<String, Integer> getCountByCategory() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT category, COUNT(*) AS cnt FROM complaint GROUP BY category ORDER BY category";

        try (Connection con = DBConnection.getConnection();
             Statement st  = con.createStatement();
             ResultSet rs  = st.executeQuery(sql)) {

            while (rs.next()) {
                map.put(rs.getString("category"), rs.getInt("cnt"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    // ─────────────────────────────────────────────────────────────
    //  ANALYTICS – count by status
    // ─────────────────────────────────────────────────────────────
    public Map<String, Integer> getCountByStatus() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT status, COUNT(*) AS cnt FROM complaint GROUP BY status";

        try (Connection con = DBConnection.getConnection();
             Statement st  = con.createStatement();
             ResultSet rs  = st.executeQuery(sql)) {

            while (rs.next()) {
                map.put(rs.getString("status"), rs.getInt("cnt"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    // ─────────────────────────────────────────────────────────────
    //  ANALYTICS – count by priority
    // ─────────────────────────────────────────────────────────────
    public Map<String, Integer> getCountByPriority() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT priority, COUNT(*) AS cnt FROM complaint GROUP BY priority ORDER BY FIELD(priority,'High','Medium','Low')";

        try (Connection con = DBConnection.getConnection();
             Statement st  = con.createStatement();
             ResultSet rs  = st.executeQuery(sql)) {

            while (rs.next()) {
                map.put(rs.getString("priority"), rs.getInt("cnt"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    // ─────────────────────────────────────────────────────────────
    //  ANALYTICS – monthly trend (last 6 months)
    // ─────────────────────────────────────────────────────────────
    public Map<String, Integer> getMonthlyTrend() {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT DATE_FORMAT(created_at, '%b %Y') AS mon, COUNT(*) AS cnt "
                   + "FROM complaint "
                   + "WHERE created_at >= DATE_SUB(NOW(), INTERVAL 6 MONTH) "
                   + "GROUP BY DATE_FORMAT(created_at, '%Y-%m') "
                   + "ORDER BY DATE_FORMAT(created_at, '%Y-%m') ASC";

        try (Connection con = DBConnection.getConnection();
             Statement st  = con.createStatement();
             ResultSet rs  = st.executeQuery(sql)) {

            while (rs.next()) {
                map.put(rs.getString("mon"), rs.getInt("cnt"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    // ─────────────────────────────────────────────────────────────
    //  ANALYTICS – total count
    // ─────────────────────────────────────────────────────────────
    public int getTotalCount() {
        int total = 0;
        String sql = "SELECT COUNT(*) FROM complaint";
        try (Connection con = DBConnection.getConnection();
             Statement st  = con.createStatement();
             ResultSet rs  = st.executeQuery(sql)) {
            if (rs.next()) total = rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }

    // ─────────────────────────────────────────────────────────────
    //  HELPER – map ResultSet row → Complaint
    // ─────────────────────────────────────────────────────────────
    private Complaint mapRow(ResultSet rs) throws SQLException {
        Complaint c = new Complaint();
        c.setId         (rs.getInt   ("id"));
        c.setName       (rs.getString("name"));
        c.setEmail      (rs.getString("email"));
        c.setSubject    (rs.getString("subject"));
        c.setDescription(rs.getString("description"));
        c.setCategory   (rs.getString("category"));
        c.setPriority   (rs.getString("priority"));
        c.setStatus     (rs.getString("status"));
        c.setUsername   (rs.getString("username"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) {
            c.setCreatedAt(new java.text.SimpleDateFormat("dd MMM yyyy, HH:mm").format(ts));
        }
        return c;
    }
}
