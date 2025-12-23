# Student Login System (Python + Flask)

## 📌 Project Overview
The Student Login System is a web-based application developed using Python and Flask. It allows students to register, log in securely, and view a personalized welcome page after successful authentication. User credentials are stored securely using encrypted passwords in an SQLite database.

This project demonstrates real-world concepts such as:
- User authentication
- Frontend–backend integration
- Password encryption
- Database management
- Web application development using Flask

---

## 🚀 Features
- Student Registration
- Secure Student Login
- Password Encryption using SHA-256
- Welcome Page after Login
- Logout functionality
- SQLite Database (auto-created)
- Clean UI using HTML & CSS

---

## 🛠 Technologies Used
- Python 3
- Flask (Web Framework)
- SQLite3 (Database)
- HTML5
- CSS3
- hashlib (for password encryption)

---

## 📂 Project Structure

student_login_system/
│
├── app.py
├── students.db (auto-generated)
│
├── templates/
│ ├── index.html (Login & Register Page)
│ └── welcome.html (Welcome Page after Login)
│
└── static/
└── style.css (UI Styling)


---

## ⚙️ How the System Works
1. User registers with a username and password  
2. Password is encrypted using SHA-256 hashing  
3. Encrypted credentials are stored in SQLite database  
4. During login, entered password is hashed and verified  
5. On successful login, user is redirected to a welcome page  
6. Logout redirects the user back to the login page  

---

## ▶️ How to Run the Project

### Step 1: Install Flask
```bash
pip install flask

Step 2: Run the Application
python app.py

Step 3: Open in Browser
http://127.0.0.1:5000

🧪 Sample Flow

Register a new student

Login using registered credentials

View personalized welcome page

Click logout to return to login page