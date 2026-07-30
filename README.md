# 🎓 College ERP System

A modern **College ERP (Enterprise Resource Planning)** web application developed using **FastAPI**, **MySQL**, **HTML**, **CSS**, and **Jinja2 Templates**.

The system provides a secure and centralized platform where students can register, log in, manage their personal information, monitor attendance, view academic performance, access course materials, and receive important notifications through an intuitive dashboard.

---

## ✨ Features

### 👨‍🎓 Student Module

- Student Registration
- Student Login
- Secure Password Hashing
- Forgot Password
- Reset Password
- Change Password
- Student Dashboard
- Profile Management
- Attendance Management
- Marks Management
- Timetable
- Course Materials
- Notifications
- Logout

---

## 🛠️ Technologies Used

| Category | Technology |
|----------|------------|
| Backend | FastAPI |
| Programming Language | Python |
| Frontend | HTML5, CSS3 |
| Template Engine | Jinja2 |
| Database | MySQL |
| ASGI Server | Uvicorn |
| Environment Variables | python-dotenv |

---

## 📂 Project Structure

```text
student/
│
├── app.py
├── database.sql
├── requirements.txt
├── .env
├── .gitignore
│
├── static/
│   └── style.css
│
└── templates/
    ├── landing.html
    ├── student_login.html
    ├── student_register.html
    ├── student_dashboard.html
    ├── profile.html
    ├── attendance.html
    ├── marks.html
    ├── timetable.html
    ├── course_materials.html
    ├── notifications.html
    ├── change_password.html
    └── reset_password.html
```

---

## ▶️ Run the Project

Start the FastAPI development server:

```bash
uvicorn app:app --reload
```

Open your browser and visit:

```text
http://127.0.0.1:8000
```