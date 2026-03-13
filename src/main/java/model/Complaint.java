package model;

public class Complaint {

    private int    id;
    private String name;
    private String email;
    private String subject;
    private String description;
    private String category;     // NEW
    private String priority;     // NEW
    private String status;
    private String username;
    private String createdAt;    // NEW – read from DB as string

    public Complaint() {}

    // Updated constructor with category and priority
    public Complaint(String name, String email, String subject,
                     String description, String category,
                     String priority, String username) {
        this.name        = name;
        this.email       = email;
        this.subject     = subject;
        this.description = description;
        this.category    = category;
        this.priority    = priority;
        this.status      = "Pending";
        this.username    = username;
    }

    // --- id ---
    public int getId()          { return id; }
    public void setId(int id)   { this.id = id; }

    // --- name ---
    public String getName()             { return name; }
    public void   setName(String name)  { this.name = name; }

    // --- email ---
    public String getEmail()              { return email; }
    public void   setEmail(String email)  { this.email = email; }

    // --- subject ---
    public String getSubject()                { return subject; }
    public void   setSubject(String subject)  { this.subject = subject; }

    // --- description ---
    public String getDescription()                    { return description; }
    public void   setDescription(String description)  { this.description = description; }

    // --- category ---
    public String getCategory()                   { return category; }
    public void   setCategory(String category)    { this.category = category; }

    // --- priority ---
    public String getPriority()                   { return priority; }
    public void   setPriority(String priority)    { this.priority = priority; }

    // --- status ---
    public String getStatus()               { return status; }
    public void   setStatus(String status)  { this.status = status; }

    // --- username ---
    public String getUsername()                   { return username; }
    public void   setUsername(String username)    { this.username = username; }

    // --- createdAt ---
    public String getCreatedAt()                  { return createdAt; }
    public void   setCreatedAt(String createdAt)  { this.createdAt = createdAt; }
}
