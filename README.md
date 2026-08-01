# 🎓 College ERP Management System

A complete College ERP Management System developed using **FastAPI**, **MySQL**, **HTML**, **CSS**, and **Jinja2**. The system provides separate portals for Students and Faculty to efficiently manage academic activities.

---

## 🚀 Features

### 👨‍🎓 Student Module
- Student Registration
- Student Login
- Student Dashboard
- View Profile
- Edit Profile
- Change Password
- Forgot Password
- View Attendance
- View Marks
- View Timetable
- Download Course Materials

### 👨‍🏫 Faculty Module
- Faculty Login
- Faculty Dashboard
- View Profile
- Change Password
- View Assigned Classes
- Take Attendance
- Edit Attendance
- Attendance History
- Attendance Summary
- Enter Student Marks
- Edit Marks
- Marks Summary
- Upload Course Materials
- Edit Course Materials
- View Uploaded Materials

---

## 🛠️ Technologies Used

- FastAPI
- Python
- MySQL
- HTML5
- CSS3
- Jinja2 Templates
- JavaScript
- Git
- GitHub

---

## 📂 Project Structure

```
college-erp/
│
├── app.py
├── database.sql
├── requirements.txt
├── README.md
├── .gitignore
│
├── static/
│   └── style.css
│
├── templates/
│   ├── landing.html
│   ├── student_login.html
│   ├── faculty_login.html
│   ├── student_dashboard.html
│   ├── faculty_dashboard.html
│   ├── faculty_profile.html
│   ├── faculty_attendance.html
│   ├── take_attendance.html
│   ├── attendance_summary.html
│   ├── attendance_history.html
│   ├── attendance_exists.html
│   ├── edit_attendance.html
│   ├── faculty_marks.html
│   ├── enter_marks.html
│   ├── edit_marks.html
│   ├── marks_summary.html
│   ├── marks_exists.html
│   ├── upload_material.html
│   ├── edit_material.html
│   ├── faculty_materials.html
│   ├── view_materials.html
│   ├── student_marks.html
│   ├── attendance.html
│   ├── timetable.html
│   └── ...
│
└── uploads/
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

## 🚧 Upcoming Features

- Admin Module
- Email OTP Verification
- Reports & Analytics
- Notifications
- Dashboard Charts
- Responsive UI Improvements