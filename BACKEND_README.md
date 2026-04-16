# 📚 QuantumLibrary — Backend README

## What is this Backend?

This is a **Java Spring Boot REST API** backend for the QuantumLibrary Management System.
It connects to a **MySQL database** and powers the entire library system — login, books, borrowing, emails, and fines.

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Language | Java 17 |
| Framework | Spring Boot 3.2.0 |
| Database | MySQL (database: `quantumlibrary`) |
| Security | Spring Security + JWT (JSON Web Tokens) |
| Email | Gmail SMTP (JavaMail) |
| Build Tool | Maven 3.9.6 |
| ORM | Hibernate / Spring Data JPA |

---

## 📁 Project Structure

```
backend/
├── src/main/java/com/quantumlibrary/
│   ├── config/
│   │   ├── DataLoader.java         ← Seeds users & books into DB on startup
│   │   ├── SecurityConfig.java     ← JWT filter, CORS, route permissions
│   │   └── JwtService.java         ← Generates & validates JWT tokens
│   ├── controller/
│   │   ├── AuthController.java     ← POST /api/auth/login, /register
│   │   ├── BookController.java     ← GET/POST/PUT/DELETE /api/books
│   │   ├── BorrowController.java   ← POST /api/borrow, /borrow/return
│   │   └── AdminController.java    ← GET /api/admin/stats, /members
│   ├── service/
│   │   ├── BorrowService.java      ← Borrow/return logic + email trigger
│   │   ├── EmailService.java       ← All email templates (SMTP)
│   │   ├── FineService.java        ← Fine calculation (₹5/day overdue)
│   │   └── BookService.java        ← Book CRUD + stock management
│   ├── model/
│   │   ├── User.java               ← Member/Admin entity
│   │   ├── Book.java               ← Book entity
│   │   ├── BorrowRecord.java       ← Borrow record entity
│   │   └── Fine.java               ← Fine entity
│   └── repository/                 ← Spring Data JPA repositories (DB queries)
└── src/main/resources/
    └── application.properties      ← DB, SMTP, JWT config
```

---

## 🔐 How Authentication Works

1. Member/Admin opens `login.html`
2. Frontend calls `POST /api/auth/login` with email + password
3. Backend checks credentials against MySQL
4. If correct → generates a **JWT Token** (valid 24 hours)
5. Token is saved in `sessionStorage` on the browser
6. Every API request sends `Authorization: Bearer <token>`
7. Backend validates token on every request automatically

```
Login → JWT Token → All API Calls Protected
```

---

## 📧 Email System — What Emails Are Sent?

| Trigger | Email Sent To | Content |
|---|---|---|
| Book Borrowed | Member's Gmail | Book name, due date, fine warning |
| Book Returned | Member's Gmail | Return confirmed, fine amount (if any) |
| Book Overdue | Member's Gmail | Days overdue, fine accumulated |
| Fine Paid | Member's Gmail | Receipt with amount paid |
| New Book Added | All Members | New arrival notification |

### SMTP Configuration (application.properties)
```properties
spring.mail.host=smtp.gmail.com
spring.mail.port=587
spring.mail.username=hussain0706w@gmail.com
spring.mail.password=dpfesyknppziwlqt   ← Gmail App Password
spring.mail.properties.mail.smtp.starttls.enable=true
```

---

## 🗄️ Database Schema

### users table
| Column | Type | Description |
|---|---|---|
| id | BIGINT | Auto-generated |
| name | VARCHAR | Full name |
| email | VARCHAR | Unique login email |
| password | VARCHAR | BCrypt hashed password |
| role | ENUM | ROLE_ADMIN or ROLE_MEMBER |
| active | BOOLEAN | Account enabled |

### books table
| Column | Type | Description |
|---|---|---|
| id | BIGINT | Auto-generated |
| title | VARCHAR | Book title |
| author | VARCHAR | Author name |
| genre | VARCHAR | Fiction, Science, etc. |
| stock | INT | Available copies |
| isbn | VARCHAR | ISBN number |
| cover_url | TEXT | Book cover image URL |

### borrow_records table
| Column | Type | Description |
|---|---|---|
| id | BIGINT | Auto-generated |
| user_id | BIGINT | FK → users.id |
| book_id | BIGINT | FK → books.id |
| borrow_date | DATETIME | When borrowed |
| due_date | DATETIME | Return deadline (14 days) |
| returned | BOOLEAN | Return status |
| return_date | DATETIME | Actual return date |

### fines table
| Column | Type | Description |
|---|---|---|
| id | BIGINT | Auto-generated |
| borrow_record_id | BIGINT | FK → borrow_records.id |
| amount | DECIMAL | Fine amount (₹5/day) |
| paid | BOOLEAN | Payment status |

---

## 🌐 All API Endpoints

### Auth
```
POST /api/auth/login      → Login, returns JWT token
POST /api/auth/register   → Register new member
```

### Books (Public Read / Admin Write)
```
GET    /api/books          → Get all 20 books
GET    /api/books/{id}     → Get single book
POST   /api/books          → Add new book (Admin only)
PUT    /api/books/{id}     → Update book (Admin only)
DELETE /api/books/{id}     → Delete book (Admin only)
```

### Borrow (Member)
```
POST /api/borrow              → Borrow a book (sends email!)
POST /api/borrow/return/{id}  → Return a book (sends email!)
GET  /api/borrow/my           → My active borrows
GET  /api/borrow/all          → All borrows (Admin only)
GET  /api/borrow/overdue      → Overdue records (Admin only)
```

### Admin
```
GET /api/admin/stats     → Dashboard statistics
GET /api/admin/members   → All members list
```

---

## 👥 User Accounts (Pre-loaded in DB)

| Role | Name | Email | Password |
|---|---|---|---|
| Admin | Library Admin | 21x51a3235@srecnandyal.edu.in | hussain |
| Member | Saddam BKR | shaiksaddambkr711@gmail.com | 2003 |
| Member | Asaduddin | dudekulaasaduddin210@gmail.com | 2001 |
| Member | Hussain | hussain0706w@gmail.com | 2004 |
| Member | Rizwan | Shaikmohammedshaikrizwan@gmail.com | 2002 |

> All passwords are stored as **BCrypt hashes** in MySQL (not plain text).

---

## ▶️ How to Run the Backend

### Prerequisites
- Java 17 installed
- Maven 3.x installed
- MySQL running with database `quantumlibrary`

### Start Command
```powershell
cd C:\Users\HUSSAIN\Desktop\33
.\start-backend.bat
```

### Wait for:
```
🚀 QuantumLibrary backend is ready!
Tomcat started on port 8080
```

### If port 8080 is busy:
```powershell
$proc = (netstat -ano | findstr ":8080" | findstr "LISTENING")
$procId = ($proc -split '\s+')[-1]
Stop-Process -Id $procId -Force
```
Then run `.\start-backend.bat` again.

---

## ⚙️ Key Features Implemented

- ✅ **JWT Authentication** — Secure login with 24-hour tokens
- ✅ **Role-based Access** — Admin vs Member permissions on every endpoint
- ✅ **BCrypt Password Hashing** — Passwords never stored in plain text
- ✅ **Auto Email on Borrow** — Gmail SMTP sends confirmation instantly
- ✅ **Auto Email on Return** — Fine calculated + email receipt sent
- ✅ **Fine Calculation** — ₹5 per day after due date (14 days period)
- ✅ **Stock Management** — Stock decrements on borrow, increments on return
- ✅ **Borrow Limit** — Max 3 books per member enforced by backend
- ✅ **Data Seeding** — 20 books + 5 users auto-loaded on first run
- ✅ **Password Sync** — Passwords updated in DB on every restart

---

*QuantumLibrary Backend — Built with Spring Boot 3.2.0*
