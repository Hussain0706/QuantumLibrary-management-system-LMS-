# 📚 QuantumLibrary — BACKEND IMPORTANT POINTS
> **Full-Stack Java Spring Boot Backend** | Presentation Guide

---

## 🔷 1. WHAT IS THE BACKEND?

The backend is a **Java Spring Boot REST API** that powers the entire QuantumLibrary system.
It runs on `http://localhost:8080` and handles all data, logic, security, and emails.

| Property       | Value                            |
|----------------|----------------------------------|
| Language       | Java 17                          |
| Framework      | Spring Boot 3.2.0                |
| Database       | H2 In-Memory (auto-creates)      |
| Port           | 8080                             |
| Build Tool     | Maven                            |
| Auth Type      | JWT (JSON Web Token)             |

---

## 🔷 2. TECHNOLOGY STACK (Dependencies — pom.xml)

| Dependency                     | Purpose                                  |
|--------------------------------|------------------------------------------|
| `spring-boot-starter-web`      | REST API / HTTP endpoints                |
| `spring-boot-starter-data-jpa` | Database ORM (auto SQL queries)          |
| `spring-boot-starter-security` | Authentication & Authorization           |
| `spring-boot-starter-mail`     | Email notifications via Gmail SMTP       |
| `spring-boot-starter-validation`| Input validation (@Valid, @NotBlank)    |
| `mysql-connector-j`            | MySQL DB driver (runtime)                |
| `jjwt-api / jjwt-impl`         | JWT token creation & verification        |
| `lombok`                       | Reduces boilerplate (@Getter, @Builder)  |
| `spring-boot-starter-test`     | Unit & Integration Testing               |

---

## 🔷 3. MAIN APPLICATION CLASS

**File:** `QuantumLibraryApplication.java`

```java
@SpringBootApplication
@EnableScheduling   // Enables daily scheduled jobs (reminders, overdue alerts)
@EnableAsync        // Enables async email sending (non-blocking)
public class QuantumLibraryApplication {
    public static void main(String[] args) {
        SpringApplication.run(QuantumLibraryApplication.class, args);
    }
}
```

**Key Annotations:**
- `@SpringBootApplication` — Auto-configures everything
- `@EnableScheduling` — Runs scheduled tasks (daily fine checks, due date reminders)
- `@EnableAsync` — Sends emails in background (doesn't block the API response)

---

## 🔷 4. PROJECT PACKAGE STRUCTURE

```
com.quantumlibrary/
│
├── QuantumLibraryApplication.java   ← Main entry point
│
├── entity/          ← Database tables (JPA Entities)
│   ├── User.java
│   ├── Book.java
│   ├── BorrowRecord.java
│   └── Fine.java
│
├── controller/      ← REST API endpoints
│   ├── AuthController.java
│   ├── BookController.java
│   ├── BorrowController.java
│   ├── FineController.java
│   └── AdminController.java
│
├── service/         ← Business Logic
│   ├── AuthService.java
│   ├── BookService.java
│   ├── BorrowService.java
│   ├── FineService.java
│   └── EmailService.java
│
├── config/          ← Security & JWT Setup
│   ├── SecurityConfig.java
│   ├── JwtUtil.java
│   ├── JwtFilter.java
│   ├── DataLoader.java          ← Seeds demo data on startup
│   └── GlobalExceptionHandler.java
│
├── repository/      ← Database queries (Spring Data JPA)
│   ├── UserRepository.java
│   ├── BookRepository.java
│   ├── BorrowRepository.java
│   └── FineRepository.java
│
├── dto/             ← Data Transfer Objects (request/response shapes)
│   ├── LoginRequest.java
│   ├── LoginResponse.java
│   ├── RegisterRequest.java
│   └── ApiResponse.java
│
└── exception/       ← Custom error handling
    └── BorrowLimitException.java
```

---

## 🔷 5. DATABASE ENTITIES (Tables)

### 📘 User Table (`users`)
```
id | name | email (unique) | password (BCrypt) | role | phone | joinDate | active
```
- **Role:** `ROLE_ADMIN` or `ROLE_MEMBER`
- Password is **never returned in JSON** (`@JsonIgnore`)
- `active` flag allows soft-ban (deactivate without deleting)

---

### 📗 Book Table (`books`)
```
id | title | author | genre | pub_year | isbn (unique) | stock | description | coverUrl | rating
```
- `stock` = number of copies currently available
- Decrements on borrow, increments on return

---

### 📙 BorrowRecord Table (`borrow_records`)
```
id | user_id (FK) | book_id (FK) | borrowDate | dueDate | returnDate | returned
```
- `returned = false` → book still out
- `returned = true` → book returned, `returnDate` is set
- `dueDate = borrowDate + 14 days`

---

### 📕 Fine Table (`fines`)
```
id | borrow_record_id (FK) | user_id (FK) | amount | paid | paidDate
```
- Created automatically when a book is returned late
- Rate: **₹5 per overdue day** (configurable)
- `paid = false` → outstanding, `paid = true` → paid at counter

---

## 🔷 6. REST API ENDPOINTS (Complete List)

### 🔓 AUTH — Public (No JWT Required)
| Method | URL                  | Description                        |
|--------|---------------------|------------------------------------|
| POST   | `/api/auth/login`   | Login → returns JWT token + role   |
| POST   | `/api/auth/register`| Register new member account        |

---

### 📚 BOOKS — Catalog API
| Method | URL                    | Auth         | Description                     |
|--------|------------------------|--------------|---------------------------------|
| GET    | `/api/books`           | Public       | Get all books (search/genre filter) |
| GET    | `/api/books/{id}`      | Public       | Get single book detail          |
| POST   | `/api/books`           | Admin only   | Add new book to catalog         |
| PUT    | `/api/books/{id}`      | Admin only   | Update book details/stock       |
| DELETE | `/api/books/{id}`      | Admin only   | Remove book from catalog        |

**Query Params:** `?search=hobbit` or `?genre=Fiction`

---

### 📖 BORROW — Borrow & Return
| Method | URL                          | Auth       | Description                        |
|--------|------------------------------|------------|------------------------------------|
| POST   | `/api/borrow`                | Member     | Borrow a book (email sent)         |
| POST   | `/api/borrow/return/{id}`    | Member     | Return a book (fine auto-calculated)|
| GET    | `/api/borrow/my`             | Member     | My currently borrowed books        |
| GET    | `/api/borrow/my/history`     | Member     | My full borrow history             |
| GET    | `/api/borrow/all`            | Admin only | All borrow records in system       |
| GET    | `/api/borrow/overdue`        | Admin only | All overdue borrow records         |

---

### 💸 FINES — Fine Management
| Method | URL                   | Auth       | Description                    |
|--------|-----------------------|------------|--------------------------------|
| GET    | `/api/fines/my`       | Member     | My fines (paid + unpaid)       |
| GET    | `/api/fines/all`      | Admin only | All fines in the system        |
| POST   | `/api/fines/pay/{id}` | Admin only | Mark fine as paid (receipt email sent) |

---

### 🛠️ ADMIN — Dashboard & Member Management
| Method | URL                              | Auth       | Description                       |
|--------|----------------------------------|------------|-----------------------------------|
| GET    | `/api/admin/stats`               | Admin only | Dashboard statistics              |
| GET    | `/api/admin/members`             | Admin only | All registered members            |
| GET    | `/api/admin/members/{id}`        | Admin only | Single member profile             |
| DELETE | `/api/admin/members/{id}`        | Admin only | Remove member (cascade-safe)      |
| PUT    | `/api/admin/members/{id}/toggle` | Admin only | Activate / Deactivate member      |

**Stats Response includes:**
```
totalBooks, totalCopies, availableBooks,
totalMembers, activeBorrows, issuedToday,
overdueCount, finesCollected, finesOutstanding
```

---

## 🔷 7. SECURITY — JWT Authentication

### How It Works (Flow):
```
1. User sends POST /api/auth/login with email + password
2. Server verifies password using BCrypt
3. Server generates a JWT token (signed with HMAC-SHA256)
4. JWT token is returned to the client
5. Client sends token in every request: Authorization: Bearer <token>
6. JwtFilter intercepts every request and validates the token
7. If valid → user is authenticated and request proceeds
8. If invalid/missing → 401 Unauthorized returned
```

### JWT Token Contents:
```json
{
  "sub": "user@email.com",
  "role": "ROLE_MEMBER",
  "userId": 5,
  "name": "Hussain",
  "iat": 1713200000,
  "exp": 1713286400
}
```

### Key Security Files:
| File                     | Responsibility                                |
|--------------------------|-----------------------------------------------|
| `JwtUtil.java`           | Generates & validates JWT tokens              |
| `JwtFilter.java`         | Intercepts every HTTP request, checks token   |
| `SecurityConfig.java`    | Defines which endpoints are public/protected  |

### Security Rules:
- `/api/auth/**` → **Public** (no token needed)
- `GET /api/books/**` → **Public** (anyone can browse books)
- `/api/admin/**` → **Admin Only** (`ROLE_ADMIN`)
- Everything else → **Any authenticated user**
- Passwords: **BCrypt encoded** (never stored in plain text)
- Sessions: **Stateless** (no server-side sessions, JWT only)
- CSRF: **Disabled** (not needed for REST APIs)
- CORS: **Enabled** (allows frontend to call backend)

---

## 🔷 8. BUSINESS LOGIC (Service Layer)

### BorrowService — Core Rules:
```
✅ Max 3 books per member at a time (configurable)
✅ Book stock must be > 0 to borrow
✅ Due date = borrowDate + 14 days
✅ On borrow  → stock decremented, email sent
✅ On return  → stock restored, fine calculated, email sent
✅ Ownership check: members can only return their OWN books
✅ Admin can return ANY book (bypass ownership check)
```

### FineService — Fine Rules:
```
✅ Rate: ₹5 per day after the due date
✅ Fine is auto-calculated on return
✅ Nightly scheduler also updates ongoing fines
✅ Fine is idempotent: won't double-create for same borrow
✅ Admin marks fine as PAID → receipt email sent to member
```

### AuthService — Registration & Login:
```
✅ Passwords BCrypt-encoded before saving
✅ Email must be unique (throws error if duplicate)
✅ On register → Welcome email sent
✅ On login   → JWT token returned with role/userId/name
✅ Inactive members CANNOT log in (soft-ban enforced)
```

---

## 🔷 9. EMAIL NOTIFICATIONS (7 Types)

**File:** `EmailService.java` | Sent via **Gmail SMTP** | **Async** (non-blocking)

| #  | Email Type             | Triggered When                          |
|----|------------------------|-----------------------------------------|
| 1  | Welcome Email          | New member registers                    |
| 2  | Borrow Confirmation    | Member borrows a book                   |
| 3  | Return Confirmation    | Member returns a book (no fine)         |
| 4  | Return + Fine Notice   | Member returns a book with a fine       |
| 5  | Due Date Reminder      | 2 days before due date (scheduled)      |
| 6  | Overdue Alert          | Book is overdue (scheduled daily)       |
| 7  | Fine Receipt           | Admin marks fine as paid                |

> **@Async** — Emails are sent in a background thread.  
> The API returns immediately without waiting for the email to send.

---

## 🔷 10. SCHEDULED JOBS (Automated Tasks)

**Enabled by:** `@EnableScheduling` on the main class

| Job                     | Schedule         | What It Does                              |
|-------------------------|------------------|-------------------------------------------|
| Daily Fine Updater      | Every day 12 AM  | Recalculates ongoing fines for overdue books |
| Due Date Reminder       | Every day 8 AM   | Emails members whose book is due in 2 days|
| Overdue Alert           | Every day 9 AM   | Emails members who have overdue books     |

---

## 🔷 11. GLOBAL EXCEPTION HANDLING

**File:** `GlobalExceptionHandler.java`

All errors are caught centrally and returned in a clean JSON format:

```json
{
  "success": false,
  "message": "You have reached the maximum borrow limit (3 books).",
  "data": null
}
```

| Exception                     | HTTP Status | Scenario                              |
|-------------------------------|-------------|---------------------------------------|
| `BorrowLimitException`        | 400         | Member tries to borrow > 3 books      |
| `IllegalStateException`       | 400         | Book out of stock, already returned   |
| `IllegalArgumentException`    | 404         | Book/User/Fine not found by ID        |
| `AccessDeniedException`       | 403         | Wrong role (member accessing admin)   |
| `JwtException`                | 401         | Invalid / expired token               |

---

## 🔷 12. DATA LOADER (Demo Data on Startup)

**File:** `DataLoader.java` (runs automatically when backend starts)

Seeds the database with:
- ✅ **1 Admin account** → `admin@quantumlibrary.com` / `admin123`
- ✅ **1 Member account** → `hussain0706w@gmail.com` / `member123`
- ✅ **32 Books** pre-loaded across multiple genres
- ✅ **Sample borrow records** and fines for demo purposes

---

## 🔷 13. API RESPONSE FORMAT (Consistent JSON)

All API responses follow one standard format:

```json
{
  "success": true,
  "message": "Books fetched: 32",
  "data": [ ... ]
}
```

**File:** `ApiResponse.java` (DTO)
- `success` → `true` or `false`
- `message` → Human-readable description
- `data` → The actual payload (object, list, or null)

---

## 🔷 14. DEMO LOGIN CREDENTIALS

| Role   | Email                        | Password   |
|--------|------------------------------|------------|
| Admin  | `admin@quantumlibrary.com`   | `admin123` |
| Member | `hussain0706w@gmail.com`     | `member123`|

**Backend URL:** `http://localhost:8080`  
**H2 DB Console:** `http://localhost:8080/h2-console`  
**Start Command:** Run `start-backend.bat` or `mvn spring-boot:run`

---

## 🔷 15. SYSTEM OVERVIEW DIAGRAM

```
┌─────────────────────────────────────────────────────────────────┐
│                    QUANTUMLIBRARY BACKEND                       │
│                    Spring Boot 3.2 | Java 17                    │
└─────────────────────────────────────────────────────────────────┘
                              │
              ┌───────────────┼───────────────┐
              │               │               │
    ┌─────────▼──────┐ ┌──────▼──────┐ ┌─────▼──────┐
    │   CONTROLLER   │ │   SERVICE   │ │  SECURITY  │
    │   (REST API)   │ │  (Business  │ │    (JWT)   │
    │                │ │   Logic)    │ │            │
    │  AuthController│ │ AuthService │ │ JwtUtil    │
    │  BookController│ │ BookService │ │ JwtFilter  │
    │  BorrowCtrl    │ │ BorrowSvc   │ │ SecurityCfg│
    │  FineController│ │ FineService │ │            │
    │  AdminController│ │ EmailService│ │            │
    └────────────────┘ └─────────────┘ └────────────┘
              │               │
    ┌─────────▼───────────────▼─────────┐
    │          REPOSITORY LAYER         │
    │      (Spring Data JPA Queries)    │
    │                                   │
    │  UserRepo | BookRepo              │
    │  BorrowRepo | FineRepo            │
    └───────────────────────────────────┘
              │
    ┌─────────▼─────────────────────────┐
    │       H2 IN-MEMORY DATABASE       │
    │                                   │
    │  users | books                    │
    │  borrow_records | fines           │
    └───────────────────────────────────┘
              │
    ┌─────────▼─────────────────────────┐
    │         EMAIL SERVICE             │
    │      Gmail SMTP (@Async)          │
    │  7 Email Types → Members/Admin    │
    └───────────────────────────────────┘
              │
    ┌─────────▼─────────────────────────┐
    │      SCHEDULED JOBS               │
    │  Daily Fine Update | Reminders    │
    │  Overdue Alerts (every 24 hrs)   │
    └───────────────────────────────────┘
```

---

## 🔷 16. SUMMARY — KEY BACKEND FEATURES

| # | Feature                     | Details                                          |
|---|-----------------------------|--------------------------------------------------|
| 1 | JWT Authentication           | Stateless, HMAC-SHA256, 24hr expiry             |
| 2 | Role-Based Access Control    | ROLE_ADMIN / ROLE_MEMBER enforced on every route|
| 3 | Book CRUD API                | Add/Edit/Delete/Search books (Admin only write) |
| 4 | Borrow & Return System       | 14-day period, 3-book limit, stock management   |
| 5 | Automatic Fine Calculation   | ₹5/day after due date, auto on return           |
| 6 | Fine Payment                 | Admin marks paid, receipt email sent            |
| 7 | 7 Email Notifications        | Welcome, Borrow, Return, Fine, Reminder, Overdue|
| 8 | Scheduled Jobs               | Daily fine updates + due date reminders         |
| 9 | Admin Dashboard Stats API    | Real-time stats: books, members, borrows, fines |
|10 | Global Exception Handler     | All errors return clean JSON format             |
|11 | DataLoader (Auto Seed)       | 32 books + admin + member loaded on startup     |
|12 | H2 In-Memory Database        | Zero setup required, auto schema creation       |
|13 | BCrypt Password Encoding     | All passwords securely hashed                   |
|14 | CORS Configured              | Frontend can call backend without errors        |
|15 | Lombok Integration           | Reduces ~60% boilerplate Java code              |
