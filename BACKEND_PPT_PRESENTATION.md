# 🎓 QuantumLibrary — Backend PPT Presentation
## (Copy these slides into PowerPoint / Google Slides)

---

# ═══════════════════════════════════════
# SLIDE 1 — TITLE SLIDE
# ═══════════════════════════════════════

## 📚 QuantumLibrary Management System
### Backend Architecture & Implementation

**Project:** Library Management System
**Technology:** Java Spring Boot + MySQL
**Team/Developer:** [Your Name]
**Date:** April 2026

---

# ═══════════════════════════════════════
# SLIDE 2 — PROJECT OVERVIEW
# ═══════════════════════════════════════

## What We Built

> A **full-stack Library Management System** with a real Java backend
> that handles authentication, books, borrowing, and automated emails.

### System Type:
- 🌐 **Frontend** → HTML, CSS, JavaScript (runs in browser)
- ⚙️ **Backend** → Java Spring Boot REST API (runs on server)
- 🗄️ **Database** → MySQL (stores all data permanently)
- 📧 **Email** → Gmail SMTP (sends real emails automatically)

---

# ═══════════════════════════════════════
# SLIDE 3 — TECHNOLOGY STACK
# ═══════════════════════════════════════

## Tech Stack Used

| Component | Technology | Version |
|-----------|-----------|---------|
| 🧠 **Backend Language** | Java | 17 |
| 🚀 **Framework** | Spring Boot | 3.2.0 |
| 🗄️ **Database** | MySQL | 8.x |
| 🔐 **Security** | JWT + Spring Security | Latest |
| 📧 **Email** | Gmail SMTP (JavaMail) | — |
| 🔨 **Build Tool** | Apache Maven | 3.9.6 |
| 🔒 **Password** | BCrypt Hashing | — |
| 🌐 **Frontend** | HTML + CSS + JavaScript | — |

---

# ═══════════════════════════════════════
# SLIDE 4 — SYSTEM ARCHITECTURE
# ═══════════════════════════════════════

## How the System Works

```
 BROWSER (Student/Admin)
        │
        │  HTTP Request (with JWT Token)
        ▼
 SPRING BOOT SERVER (Port 8080)
        │
        ├──► SecurityFilter → Validates JWT Token
        │
        ├──► Controller → Routes the request
        │
        ├──► Service → Business Logic
        │         │
        │         ├──► MySQL Database (save/read data)
        │         └──► Gmail SMTP (send email)
        │
        └──► JSON Response → Back to Browser
```

**Key Point:** Every request is checked for a valid JWT token before any data is accessed.

---

# ═══════════════════════════════════════
# SLIDE 5 — JWT AUTHENTICATION
# ═══════════════════════════════════════

## 🔐 How Login & Security Works

### Step-by-Step JWT Flow:

**1️⃣ Student opens login page**
**2️⃣ Enters email + password → clicks Login**
**3️⃣ Backend verifies against MySQL database**
**4️⃣ Backend generates JWT Token (valid 24 hours)**
**5️⃣ Token saved in browser sessionStorage**
**6️⃣ Every API call sends: `Authorization: Bearer <token>`**
**7️⃣ Backend validates token → processes request**

### Key Security Features:
- ✅ Passwords stored as **BCrypt hashes** (never plain text)
- ✅ JWT token expires in **24 hours**
- ✅ Admin routes blocked for members
- ✅ Member routes blocked for non-logged-in users

---

# ═══════════════════════════════════════
# SLIDE 6 — DATABASE DESIGN
# ═══════════════════════════════════════

## 🗄️ MySQL Database Schema

### 4 Tables:

**users** → Stores all accounts
```
id | name | email | password (BCrypt) | role | active
```

**books** → Stores all 20 books
```
id | title | author | genre | stock | isbn | cover_url
```

**borrow_records** → Every borrow/return action
```
id | user_id | book_id | borrow_date | due_date | returned
```

**fines** → Overdue fine records
```
id | borrow_record_id | amount (₹5/day) | paid
```

### Relationships:
- One **User** → Many **BorrowRecords**
- One **Book** → Many **BorrowRecords**
- One **BorrowRecord** → One **Fine**

---

# ═══════════════════════════════════════
# SLIDE 7 — REST API ENDPOINTS
# ═══════════════════════════════════════

## 🌐 API Endpoints (What Frontend Calls)

| Endpoint | Method | Who | What it Does |
|----------|--------|-----|-------------|
| `/api/auth/login` | POST | All | Login → get JWT |
| `/api/books` | GET | All | Get all books |
| `/api/books` | POST | Admin | Add new book |
| `/api/books/{id}` | PUT | Admin | Update book |
| `/api/books/{id}` | DELETE | Admin | Delete book |
| `/api/borrow` | POST | Member | Borrow a book |
| `/api/borrow/return/{id}` | POST | Member | Return a book |
| `/api/borrow/all` | GET | Admin | See all borrows |
| `/api/admin/stats` | GET | Admin | Dashboard numbers |

**Total: 9 REST API endpoints built**

---

# ═══════════════════════════════════════
# SLIDE 8 — EMAIL AUTOMATION
# ═══════════════════════════════════════

## 📧 Automated Email System

### Emails Sent Automatically:

| When? | Email To | Content |
|-------|----------|---------|
| 📖 Book Borrowed | Member Gmail | Book name, due date, fine warning |
| 📥 Book Returned | Member Gmail | Return confirmed + fine charged |
| ⚠️ Book Overdue | Member Gmail | Days late, amount owed |
| 💰 Fine Paid | Member Gmail | Payment receipt |
| 📚 New Book Added | All Members | New arrival notification |

### How it Works:
```java
// After saving borrow record:
emailService.sendBorrowConfirmation(user, saved);
// ↑ This line triggers the Gmail email automatically!
```

### Configuration:
- **Sender:** hussain0706w@gmail.com
- **SMTP:** Gmail App Password (secure)
- **Runs:** In background thread (doesn't slow down the app)

---

# ═══════════════════════════════════════
# SLIDE 9 — KEY FEATURES
# ═══════════════════════════════════════

## ✅ Features Implemented in Backend

| # | Feature | How |
|---|---------|-----|
| 1 | **JWT Login Security** | Spring Security + JwtService |
| 2 | **Role-Based Access** | Admin vs Member permissions |
| 3 | **Password Hashing** | BCrypt (industry standard) |
| 4 | **Book CRUD** | Full add/edit/delete/view |
| 5 | **Borrow & Return** | Stock auto-updated |
| 6 | **3-Book Limit** | Enforced by backend logic |
| 7 | **Fine Calculation** | ₹5/day after 14-day period |
| 8 | **Auto Emails** | 5 types of email notifications |
| 9 | **Admin Dashboard Stats** | Live numbers from DB |
| 10 | **Data Seeding** | 20 books + 5 users auto-loaded |
| 11 | **Per-User Data** | Each member sees own data only |

---

# ═══════════════════════════════════════
# SLIDE 10 — BORROW LOGIC (IMPORTANT)
# ═══════════════════════════════════════

## 📖 How Borrowing Works (Step by Step)

```
Student clicks "Borrow Book"
        │
        ▼
Frontend calls POST /api/borrow { bookId: 5 }
        │
        ▼
Backend checks: Is student logged in? (JWT) ✅
        │
        ▼
Backend checks: Does student have < 3 books? ✅
        │
        ▼
Backend checks: Is book in stock? (stock > 0) ✅
        │
        ▼
MySQL: stock = stock - 1  (deduct copy)
        │
        ▼
MySQL: Save BorrowRecord (borrowDate, dueDate = +14 days)
        │
        ▼
Gmail SMTP: Send confirmation email to student 📧
        │
        ▼
Return BorrowRecord JSON to frontend ✅
```

---

# ═══════════════════════════════════════
# SLIDE 11 — ADMIN PANEL INTEGRATION
# ═══════════════════════════════════════

## 👨‍💼 Admin Panel Powered by Backend

### What Admin Sees (All from MySQL):

- **Total Books** → COUNT from books table
- **Available Copies** → SUM of stock
- **Currently Borrowed** → Active borrow_records count
- **Overdue Books** → Records past due_date
- **Total Fines** → SUM of unpaid fines

### Admin Can:
- ➕ Add new books → saved to MySQL
- ✏️ Edit book details/stock → updated in MySQL
- 🗑️ Delete books → removed from MySQL
- 📥 Force Return any book → updates record, sends email
- 👥 View all members and their borrows

---

# ═══════════════════════════════════════
# SLIDE 12 — MEMBER SYSTEM
# ═══════════════════════════════════════

## 👥 4 Library Members (Pre-registered)

| # | Name | Email | Password |
|---|------|-------|----------|
| 1 | Saddam BKR | shaiksaddambkr711@gmail.com | 2003 |
| 2 | Asaduddin | dudekulaasaduddin210@gmail.com | 2001 |
| 3 | Hussain | hussain0706w@gmail.com | 2004 |
| 4 | Rizwan | Shaikmohammedshaikrizwan@gmail.com | 2002 |

### Data Isolation:
- Each member sees **only their own** borrowed books
- One member's data is **completely separate** from another
- Admin sees **everyone's** data in one panel
- Emails go to **that member's Gmail only**

---

# ═══════════════════════════════════════
# SLIDE 13 — HOW TO RUN
# ═══════════════════════════════════════

## ▶️ Running the System

### Step 1: Start MySQL
> Make sure MySQL is running (XAMPP / MySQL Workbench)

### Step 2: Start Backend
```
Double-click: start-backend.bat
```
**OR in terminal:**
```
cd C:\Users\HUSSAIN\Desktop\33
.\start-backend.bat
```

### Step 3: Open the App
```
Open: index.html in browser
```

### Step 4: Login
```
Admin: 21x51a3235@srecnandyal.edu.in  |  hussain
Member: shaiksaddambkr711@gmail.com  |  2003
```

---

# ═══════════════════════════════════════
# SLIDE 14 — WHAT MAKES IT SPECIAL
# ═══════════════════════════════════════

## 🌟 Why This Project Stands Out

### Traditional Library System:
- ❌ Data stored only in browser (lost on refresh)
- ❌ No real login/security
- ❌ No emails sent
- ❌ Any user can see everyone's data
- ❌ Cannot be deployed online

### Our QuantumLibrary System:
- ✅ **Real database** — data persists forever in MySQL
- ✅ **JWT Security** — industry-standard authentication
- ✅ **Real emails** — Gmail SMTP integration
- ✅ **Data isolation** — each member sees only their data
- ✅ **RESTful API** — can be deployed to any cloud server
- ✅ **BCrypt passwords** — cannot be cracked easily

---

# ═══════════════════════════════════════
# SLIDE 15 — THANK YOU
# ═══════════════════════════════════════

## 📚 QuantumLibrary Management System

### Summary of What Was Built:
- **9 REST API endpoints**
- **4 MySQL tables** with proper relationships
- **5 automated email types** via Gmail SMTP
- **JWT authentication** system
- **Role-based access control** (Admin vs Member)
- **Fine calculation** engine (₹5/day)
- **Real-time admin dashboard** with live stats

---

### Technology Stack:
`Java 17` `Spring Boot 3.2.0` `MySQL` `JWT` `BCrypt` `Gmail SMTP` `HTML/CSS/JS`

---

## 🙏 Thank You!

**Questions?**
