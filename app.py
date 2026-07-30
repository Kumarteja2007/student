from fastapi import FastAPI, Request, Form
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles
import mysql.connector
import hashlib
import os
from dotenv import load_dotenv
load_dotenv()

app = FastAPI()

app.mount("/static", StaticFiles(directory="static"), name="static")
templates = Jinja2Templates(directory="templates")


# ---------------- DATABASE CONNECTION ----------------

def get_db():
    return mysql.connector.connect(
        host=os.getenv("DB_HOST"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        database=os.getenv("DB_NAME")
    )

# ---------------- PASSWORD HASHING ----------------

def hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()


# ---------------- HOME PAGE ----------------

@app.get("/", response_class=HTMLResponse)
def landing(request: Request):

    return templates.TemplateResponse(
        "landing.html",
        {
            "request": request
        }
    )
    
#--------------Student Login Page-----------------
@app.get("/student-login", response_class=HTMLResponse)
def student_login(request: Request):

    message = request.query_params.get("message", "")

    return templates.TemplateResponse(
        "student_login.html",
        {
            "request": request,
            "message": message
        }
    )


#------------------Dashboard Page-------------------
@app.get("/student-dashboard/{username}", response_class=HTMLResponse)
def student_dashboard(request: Request, username: str):
    return templates.TemplateResponse(
        "student_dashboard.html",
        {
            "request": request,
            "username": username
        }
    )

# ---------------- PROFILE PAGE ----------------

@app.get("/profile/{username}", response_class=HTMLResponse)
def profile(request: Request, username: str):

    message = request.query_params.get("message", "")
    db = get_db()
    cursor = db.cursor(dictionary=True)

    cursor.execute(
        """
        SELECT * FROM students
        WHERE username=%s
        """,
        (username,)
    )

    student = cursor.fetchone()

    cursor.close()
    db.close()

    return templates.TemplateResponse(
    "profile.html",
    {
        "request": request,
        "student": student,
        "username": username,
        "message": message
    }
)
# ---------------- CHANGE PASSWORD PAGE ----------------

@app.get("/change-password/{username}", response_class=HTMLResponse)
def change_password_page(
    request: Request,
    username: str
):

    message = request.query_params.get("message", "")

    return templates.TemplateResponse(
        "change_password.html",
        {
            "request": request,
            "username": username,
            "message": message
        }
    )
# ---------------- UPDATE PROFILE ----------------

@app.post("/update-profile")
def update_profile(

    username: str = Form(...),
    full_name: str = Form(""),
    mobile: str = Form(""),
    degree: str = Form(""),
    degree_period: str = Form(""),
    department: str = Form(""),
    section: str = Form(""),
    semester: str = Form(""),
    father_name: str = Form(""),
    father_mobile: str = Form(""),
    mother_name: str = Form(""),
    mother_mobile: str = Form(""),
    parent_email: str = Form("")

):

    if not all([
        full_name,
        mobile,
        degree,
        degree_period,
        department,
        section,
        semester,
        father_name,
        father_mobile,
        mother_name,
        mother_mobile,
        parent_email
    ]):
        return RedirectResponse(
            url=f"/profile/{username}?message=Please fill in all required fields.",
            status_code=303
        )

    db = get_db()
    cursor = db.cursor()


    cursor.execute(
        """
        UPDATE students
        SET
            full_name=%s,
            mobile=%s,
            degree=%s,
            degree_period=%s,
            department=%s,
            section=%s,
            semester=%s,
            father_name=%s,
            father_mobile=%s,
            mother_name=%s,
            mother_mobile=%s,
            parent_email=%s
        WHERE username=%s
        """,
        (
            full_name,
            mobile,
            degree,
            degree_period,
            department,
            section,
            semester,
            father_name,
            father_mobile,
            mother_name,
            mother_mobile,
            parent_email,
            username
        )
    )
    db.commit()
    cursor.close()
    db.close()
    return RedirectResponse(
    url=f"/profile/{username}?message=Profile updated successfully.",
    status_code=303
)


@app.get("/register", response_class=HTMLResponse)
def register_page(request: Request):

    message = request.query_params.get("message", "")

    return templates.TemplateResponse(
        "student_register.html",
        {
            "request": request,
            "message": message
        }
    )
    # ---------------- ATTENDANCE PAGE ----------------

@app.get("/attendance/{username}", response_class=HTMLResponse)
def attendance(request: Request, username: str):

    db = get_db()
    cursor = db.cursor(dictionary=True)

    cursor.execute(
        """
        SELECT student_id
        FROM students
        WHERE username=%s
        """,
        (username,)
    )

    student = cursor.fetchone()

    cursor.execute(
        """
        SELECT *
        FROM attendance
        WHERE student_id=%s
        """,
        (student["student_id"],)
    )
    records = cursor.fetchall()
    for record in records:
        if record["total_classes"] == 0:
            record["percentage"] = 0
        else:
            record["percentage"] = round(
                (record["classes_present"] / record["total_classes"]) * 100,
                2
            )
    cursor.close()
    db.close()
    return templates.TemplateResponse(
        "attendance.html",
        {
            "request": request,
            "username": username,
            "records": records
        }
    )
    
    # ---------------- MARKS PAGE ----------------

@app.get("/marks/{username}", response_class=HTMLResponse)
def marks(request: Request, username: str):

    db = get_db()
    cursor = db.cursor(dictionary=True)

    cursor.execute(
        """
        SELECT student_id
        FROM students
        WHERE username=%s
        """,
        (username,)
    )

    student = cursor.fetchone()

    cursor.execute(
        """
        SELECT *
        FROM marks
        WHERE student_id=%s
        """,
        (student["student_id"],)
    )
    records = cursor.fetchall()
    for row in records:
        row["total"] = (
            row["mid1"] +
            row["mid2"] +
            row["internal_marks"] +
            row["final_exam"]
        )
        percentage = row["total"] / 2
        row["percentage"] = round(percentage, 2)
        if percentage >= 90:
            row["grade"] = "A+"
        elif percentage >= 80:
            row["grade"] = "A"
        elif percentage >= 70:
            row["grade"] = "B"
        elif percentage >= 60:
            row["grade"] = "C"
        elif percentage >= 50:
            row["grade"] = "D"
        else:
            row["grade"] = "F"
    cursor.close()
    db.close()
    return templates.TemplateResponse(
        "marks.html",
        {
            "request": request,
            "username": username,
            "records": records
        }
    )
    
    # ---------------- TIMETABLE PAGE ----------------

@app.get("/timetable/{username}", response_class=HTMLResponse)
def timetable(request: Request, username: str):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute(
        """
        SELECT *
        FROM timetable
        ORDER BY id
        """
    )
    timetable_data = cursor.fetchall()
    cursor.close()
    db.close()
    return templates.TemplateResponse(
        "timetable.html",
        {
            "request": request,
            "username": username,
            "timetable": timetable_data
        }
    )
    
    # ---------------- COURSE MATERIALS ----------------

from fastapi.responses import FileResponse
import os


@app.get("/course-materials/{username}", response_class=HTMLResponse)
def course_materials(request: Request, username: str):

    db = get_db()
    cursor = db.cursor(dictionary=True)

    cursor.execute("""
        SELECT *
        FROM course_materials
        ORDER BY uploaded_on DESC
    """)
    materials = cursor.fetchall()
    cursor.close()
    db.close()
    return templates.TemplateResponse(
        "course_materials.html",
        {
            "request": request,
            "username": username,
            "materials": materials
        }
    )
@app.get("/download/{material_id}")
def download_material(material_id: int):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute(
        """
        SELECT *
        FROM course_materials
        WHERE id=%s
        """,
        (material_id,)
    )
    material = cursor.fetchone()
    cursor.close()
    db.close()
    return FileResponse(
        material["file_path"],
        filename=material["file_name"]
    )
    
    # ---------------- NOTIFICATIONS ----------------

@app.get("/notifications/{username}", response_class=HTMLResponse)
def notifications(request: Request, username: str):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute("""
        SELECT *
        FROM notifications
        ORDER BY posted_on DESC
    """)
    notifications = cursor.fetchall()
    cursor.close()
    db.close()
    return templates.TemplateResponse(
        "notifications.html",
        {
            "request": request,
            "username": username,
            "notifications": notifications
        }
    )
    
    
# ---------------- REGISTER ----------------

@app.post("/register")
def register(
    student_id: str = Form(...),
    username: str = Form(...),
    email: str = Form(...),
    password: str = Form(...),
    confirm_password: str = Form(...)
):

    if password != confirm_password:
        return RedirectResponse(
            url="/register?message=Passwords do not match",
            status_code=303
        )

    encrypted = hash_password(password)
    db = get_db()
    cursor = db.cursor()
    cursor.execute(
        """
        SELECT * FROM students
        WHERE student_id=%s OR username=%s OR email_id=%s
        """,
        (
            student_id,
            username,
            email
        )
    )
    existing = cursor.fetchone()
    if existing:
        cursor.close()
        db.close()
        return RedirectResponse(
            url="/register?message=Student ID, Username or Email already exists",
            status_code=303
        )
    try:
        cursor.execute(
            """
            INSERT INTO students(
                student_id,
                username,
                email_id,
                password
            )
            VALUES(%s,%s,%s,%s)
            """,
            (
                student_id,
                username,
                email,
                encrypted
            )
        )
        db.commit()
    except mysql.connector.Error as err:
        cursor.close()
        db.close()
        return RedirectResponse(
            url=f"/register?message={err}",
            status_code=303
        )
    cursor.close()
    db.close()

    return RedirectResponse(
        url="/student-login?message=Registration Successful. Please login.",
        status_code=303
    )
    
# ---------------- CHANGE PASSWORD ----------------

@app.post("/change-password")
def change_password(

    username: str = Form(...),
    current_password: str = Form(...),
    new_password: str = Form(...),
    confirm_password: str = Form(...)

):

    if new_password != confirm_password:

        return RedirectResponse(

            url=f"/change-password/{username}?message=Passwords do not match",

            status_code=303

        )

    db = get_db()

    cursor = db.cursor()

    current_password = hash_password(current_password)

    cursor.execute(

        """
        SELECT *
        FROM students
        WHERE username=%s
        AND password=%s
        """,

        (username, current_password)

    )

    user = cursor.fetchone()

    if not user:

        cursor.close()

        db.close()

        return RedirectResponse(

            url=f"/change-password/{username}?message=Current Password is incorrect",

            status_code=303

        )

    new_password = hash_password(new_password)

    cursor.execute(

        """
        UPDATE students
        SET password=%s
        WHERE username=%s
        """,

        (new_password, username)

    )

    db.commit()

    cursor.close()

    db.close()

    return RedirectResponse(

        url=f"/student-dashboard/{username}",

        status_code=303

    )
# ---------------- LOGIN ----------------

@app.post("/login")
def login(
    username: str = Form(...),
    password: str = Form(...)
):

    encrypted = hash_password(password)

    db = get_db()
    cursor = db.cursor()

    cursor.execute(
        """
        SELECT * FROM students
        WHERE username=%s AND password=%s
        """,
        (username, encrypted)
    )

    user = cursor.fetchone()

    cursor.close()
    db.close()

    if user:
        return RedirectResponse(
            url=f"/student-dashboard/{username}",
            status_code=303
        )

    return RedirectResponse(
        url="/student-login?message=Invalid Username or Password",
        status_code=303
    )


# ---------------- FORGOT PASSWORD PAGE ----------------

@app.get("/forgot-password", response_class=HTMLResponse)
def forgot_password(request: Request):

    message = request.query_params.get("message", "")

    return templates.TemplateResponse(
        "forgot_password.html",
        {
            "request": request,
            "message": message
        }
    )


# ---------------- VERIFY USER ----------------

@app.post("/forgot-password")
def verify_user(
    request: Request,
    username: str = Form(...),
    email: str = Form(...)
):

    db = get_db()
    cursor = db.cursor()

    cursor.execute(
        """
        SELECT * FROM students
        WHERE username=%s AND email_id=%s
        """,
        (username, email)
    )

    user = cursor.fetchone()

    cursor.close()
    db.close()

    if user:

        return templates.TemplateResponse(
            "reset_password.html",
            {
                "request": request,
                "username": username,
                "email": email
            }
        )

    return RedirectResponse(
        url="/forgot-password?message=Invalid Username or Email",
        status_code=303
    )


# ---------------- RESET PASSWORD ----------------

@app.post("/reset-password")
def reset_password(
    username: str = Form(...),
    email: str = Form(...),
    new_password: str = Form(...),
    confirm_password: str = Form(...)
):

    if new_password != confirm_password: 
        return RedirectResponse(
            url="/forgot-password?message=Passwords do not match",
            status_code=303
        )

    encrypted = hash_password(new_password)

    db = get_db()
    cursor = db.cursor()

    cursor.execute(
        """
        UPDATE students SET password=%s WHERE username=%s AND email_id=%s
        """,
        (
            encrypted,
            username,
            email
        )
    )

    db.commit()

    cursor.close()
    db.close()

    return RedirectResponse(
        url="/student-login?message=Password Reset Successful",
        status_code=303
    )


# ---------------- LOGOUT ----------------

@app.get("/logout")
def logout():

    return RedirectResponse(
        url="/",
        status_code=303
    )