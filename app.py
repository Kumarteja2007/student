from fastapi import FastAPI,Request,Form,UploadFile,File
from fastapi.responses import HTMLResponse,RedirectResponse,FileResponse
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles
import mysql.connector
import hashlib
import shutil
import os
from dotenv import load_dotenv
load_dotenv()
app=FastAPI()
app.mount("/static", StaticFiles(directory="static"), name="static")
app.mount("/uploads", StaticFiles(directory="uploads"), name="uploads")
templates = Jinja2Templates(directory="templates")


# ---------------- DATABASE CONNECTION ----------------

def get_db():
    return mysql.connector.connect(
        host=os.getenv("DB_HOST"),
        port=int(os.getenv("DB_PORT")),
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
        request,
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
        request,
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
        request,
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
        request,
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
        request,
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
        request,
        "student_register.html",
        {
            "request": request,
            "message": message
        }
    )
    # ---------------- ATTENDANCE PAGE ----------------

@app.get("/attendance/{username}",response_class=HTMLResponse)
def attendance(request:Request,username:str):

    db=get_db()
    cursor=db.cursor(dictionary=True)

    cursor.execute("""
    SELECT student_id
    FROM students
    WHERE username=%s
    """,(username,))

    student=cursor.fetchone()

    cursor.execute("""
    SELECT
        s.subject,
        s.attendance_date,
        s.slot,
        d.attendance_status
    FROM attendance_details d
    JOIN attendance_session s
    ON d.session_id=s.session_id
    WHERE d.student_id=%s
    ORDER BY s.attendance_date DESC
    """,(student["student_id"],))

    records=cursor.fetchall()

    cursor.close()
    db.close()

    return templates.TemplateResponse(
        request,
        "attendance.html",
        {
            "request":request,
            "username":username,
            "records":records
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
        request,
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

    # Get logged-in student details
    cursor.execute(
        """
        SELECT *
        FROM students
        WHERE username=%s
        """,
        (username,)
    )
    student = cursor.fetchone()

    # Get timetable only for that student's semester and section
    cursor.execute(
        """
        SELECT *
        FROM timetable
        WHERE semester=%s
        AND section=%s
        ORDER BY FIELD(
            day_name,
            'Monday',
            'Tuesday',
            'Wednesday',
            'Thursday',
            'Friday',
            'Saturday'
        )
        """,
        (
            student["semester"],
            student["section"]
        )
    )

    timetable_data = cursor.fetchall()

    cursor.close()
    db.close()

    return templates.TemplateResponse(
        request,
        "timetable.html",
        {
            "request": request,
            "username": username,
            "student": student,
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
        request,
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
    
    
#-----------Student Marks Page-----------------
@app.get("/student-marks/{username}", response_class=HTMLResponse)
def student_marks(request: Request, username: str):
    db = get_db()
    cursor = db.cursor(dictionary=True)

    cursor.execute(
        """
        SELECT *
        FROM students
        WHERE username=%s
        """,
        (username,)
    )
    student = cursor.fetchone()

    cursor.execute(
        """
        SELECT
            ms.subject,
            ms.assessment_type,
            md.marks,
            am.max_marks
        FROM marks_details md
        JOIN marks_session ms
            ON md.session_id=ms.session_id
        JOIN assessment_master am
            ON ms.assessment_type=am.assessment_name
        WHERE md.student_id=%s
        ORDER BY
            ms.subject,
            ms.session_id
        """,
        (student["student_id"],)
    )
    marks = cursor.fetchall()
    cursor.close()
    db.close()
    return templates.TemplateResponse(
        request,
        "student_marks.html",
        {
            "request": request,
            "username": username,
            "student": student,
            "marks": marks
        }
    )
#------------Faculty Login Page-----------------
@app.get("/faculty-login", response_class=HTMLResponse)
def faculty_login_page(request: Request):

    message = request.query_params.get("message", "")

    return templates.TemplateResponse(
        request,
        "faculty_login.html",
        {
            "request": request,
            "message": message
        }
    )
#---------------- Faculty Dashboard ----------------
@app.get("/faculty-dashboard/{username}", response_class=HTMLResponse)
def faculty_dashboard(

    request: Request,
    username: str

):

    db = get_db()

    cursor = db.cursor(dictionary=True)

    cursor.execute(
        """
        SELECT *
        FROM faculty
        WHERE username=%s
        """,
        (username,)
    )

    faculty = cursor.fetchone()

    cursor.close()
    db.close()

    return templates.TemplateResponse(
        request,
        "faculty_dashboard.html",
        {
            "request": request,
            "faculty": faculty,
            "username": username
        }
    )
    
#----------------------Faculty Assignments Page----------------------
@app.get("/faculty-assignments/{username}", response_class=HTMLResponse)
def faculty_assignments(
    request: Request,
    username: str
):

    db = get_db()
    cursor = db.cursor(dictionary=True)

    # Get Faculty Details
    cursor.execute(
        """
        SELECT *
        FROM faculty
        WHERE username=%s
        """,
        (username,)
    )

    faculty = cursor.fetchone()

    # Get Assigned Classes
    cursor.execute(
        """
        SELECT *
        FROM faculty_assignments
        WHERE faculty_id=%s
        ORDER BY semester, section
        """,
        (faculty["faculty_id"],)
    )

    assignments = cursor.fetchall()

    cursor.close()
    db.close()

    return templates.TemplateResponse(
        request,
        "faculty_assignments.html",
        {
            "request": request,
            "faculty": faculty,
            "username": username,
            "assignments": assignments
        }
    )
    
#----------------------Faculty Profile Page----------------------
@app.get("/faculty-profile/{username}", response_class=HTMLResponse)
def faculty_profile(
    request: Request,
    username: str
):

    db = get_db()
    cursor = db.cursor(dictionary=True)

    cursor.execute(
        """
        SELECT *
        FROM faculty
        WHERE username=%s
        """,
        (username,)
    )

    faculty = cursor.fetchone()

    cursor.close()
    db.close()

    return templates.TemplateResponse(
        request,
        "faculty_profile.html",
        {
            "request": request,
            "faculty": faculty,
            "username": username
        }
    )
    
#-----------------Faculty Attendance-------------------
@app.get("/faculty-attendance/{username}", response_class=HTMLResponse)
def faculty_attendance(request: Request, username: str):

    db = get_db()
    cursor = db.cursor(dictionary=True)

    # Get faculty details
    cursor.execute(
        """
        SELECT *
        FROM faculty
        WHERE username=%s
        """,
        (username,)
    )

    faculty = cursor.fetchone()

    # Get all classes assigned to this faculty
    cursor.execute(
        """
        SELECT *
        FROM faculty_assignments
        WHERE faculty_id=%s
        ORDER BY semester, section
        """,
        (faculty["faculty_id"],)
    )
    assignments = cursor.fetchall()
    cursor.close()
    db.close()
    return templates.TemplateResponse(
        request,
        "faculty_attendance.html",
        {
            "request": request,
            "username": username,
            "faculty": faculty,
            "assignments": assignments
        }
    )
#---------------Open Attendance Page---------------
@app.get("/take-attendance/{assignment_id}/{username}", response_class=HTMLResponse)
def take_attendance(
    request: Request,
    assignment_id: int,
    username: str
):

    db = get_db()
    cursor = db.cursor(dictionary=True)

    # Get assignment details
    cursor.execute(
        """
        SELECT *
        FROM faculty_assignments
        WHERE id=%s
        """,
        (assignment_id,)
    )

    assignment = cursor.fetchone()

    # Get students of that class
    cursor.execute(
        """
        SELECT
            student_id,
            full_name
        FROM students
        WHERE
            department=%s
            AND semester=%s
            AND section=%s
        ORDER BY student_id
        """,
        (
            assignment["department"],
            assignment["semester"],
            assignment["section"]
        )
    )

    students = cursor.fetchall()

    cursor.close()
    db.close()

    return templates.TemplateResponse(
        request,
        "take_attendance.html",
        {
            "request": request,
            "username": username,
            "assignment": assignment,
            "students": students
        }
    )
    
#--------------Attendance Summary--------------------
@app.get("/attendance-summary/{session_id}/{username}", response_class=HTMLResponse)
def attendance_summary(
    request: Request,
    session_id: int,
    username: str
):

    db = get_db()
    cursor = db.cursor(dictionary=True)

    cursor.execute(
        """
        SELECT *
        FROM attendance_session
        WHERE session_id=%s
        """,
        (session_id,)
    )

    session = cursor.fetchone()

    cursor.close()
    db.close()

    return templates.TemplateResponse(
        request,
        "attendance_summary.html",
        {
            "request": request,
            "session": session,
            "username": username
        }
    )
#--------------Attendance Exists--------------------
@app.get("/attendance-exists/{session_id}/{username}", response_class=HTMLResponse)
def attendance_exists(
    request: Request,
    session_id: int,
    username: str
):

    db = get_db()
    cursor = db.cursor(dictionary=True)

    cursor.execute(
        """
        SELECT *
        FROM attendance_session
        WHERE session_id=%s
        """,
        (session_id,)
    )

    session = cursor.fetchone()

    cursor.close()
    db.close()

    return templates.TemplateResponse(
        request,
        "attendance_exists.html",
        {
            "request": request,
            "session": session,
            "username": username
        }
    )
#------------Attendance History-------
@app.get("/attendance-history/{assignment_id}/{username}", response_class=HTMLResponse)
def attendance_history(
    request: Request,
    assignment_id: int,
    username: str
):

    db = get_db()
    cursor = db.cursor(dictionary=True)

    # Assignment Details
    cursor.execute(
        """
        SELECT *
        FROM faculty_assignments
        WHERE id=%s
        """,
        (assignment_id,)
    )

    assignment = cursor.fetchone()

    # Attendance Sessions
    cursor.execute(
        """
        SELECT *
        FROM attendance_session
        WHERE
            subject=%s
            AND semester=%s
            AND section=%s
            AND slot=%s
        ORDER BY attendance_date DESC
        """,
        (
            assignment["subject"],
            assignment["semester"],
            assignment["section"],
            assignment["slot"]
        )
    )

    sessions = cursor.fetchall()

    cursor.close()
    db.close()

    return templates.TemplateResponse(
        request,
        "attendance_history.html",
        {
            "request": request,
            "username": username,
            "assignment": assignment,
            "sessions": sessions
        }
    )

#--------------View Attendance------------
@app.get("/view-attendance/{session_id}/{username}", response_class=HTMLResponse)
def view_attendance(
    request: Request,
    session_id: int,
    username: str
):

    db = get_db()
    cursor = db.cursor(dictionary=True)

    # Attendance Session
    cursor.execute(
        """
        SELECT *
        FROM attendance_session
        WHERE session_id=%s
        """,
        (session_id,)
    )

    session = cursor.fetchone()

    # Student Attendance
    cursor.execute(
        """
        SELECT *
        FROM attendance_details
        WHERE session_id=%s
        ORDER BY student_id
        """,
        (session_id,)
    )

    students = cursor.fetchall()

    cursor.close()
    db.close()

    return templates.TemplateResponse(
        request,
        "view_attendance.html",
        {
            "request": request,
            "session": session,
            "students": students,
            "username": username
        }
    )
#---------Edit Attendance----------
@app.get("/edit-attendance/{session_id}/{username}", response_class=HTMLResponse)
def edit_attendance(
    request: Request,
    session_id: int,
    username: str
):

    db = get_db()
    cursor = db.cursor(dictionary=True)

    cursor.execute(
        """
        SELECT *
        FROM attendance_session
        WHERE session_id=%s
        """,
        (session_id,)
    )

    session = cursor.fetchone()

    cursor.execute(
        """
        SELECT *
        FROM attendance_details
        WHERE session_id=%s
        ORDER BY student_id
        """,
        (session_id,)
    )

    students = cursor.fetchall()

    cursor.close()
    db.close()

    return templates.TemplateResponse(
        request,
        "edit_attendance.html",
        {
            "request": request,
            "session": session,
            "students": students,
            "username": username
        }
    )
    
#--------------Marks---------------
@app.get("/faculty-marks/{username}", response_class=HTMLResponse)
def faculty_marks(
    request: Request,
    username: str
):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute(
        """
        SELECT *
        FROM faculty
        WHERE username=%s
        """,
        (username,)
    )
    faculty = cursor.fetchone()
    cursor.execute(
        """
        SELECT *
        FROM faculty_assignments
        WHERE faculty_id=%s
        ORDER BY semester, section
        """,
        (faculty["faculty_id"],)
    )
    assignments = cursor.fetchall()
    cursor.close()
    db.close()
    return templates.TemplateResponse(
        request,
        "faculty_marks.html",
        {
            "request": request,
            "username": username,
            "faculty": faculty,
            "assignments": assignments
        }
    )
#------------Select Assignment for Marks-----------------
@app.get("/select-assessment/{assignment_id}/{username}", response_class=HTMLResponse)
def select_assessment(request: Request, assignment_id: int, username: str):
    db=get_db()
    cursor=db.cursor(dictionary=True)
    cursor.execute(
        """
        SELECT *
        FROM faculty_assignments
        WHERE id=%s
        """,
        (assignment_id,)
    )
    assignment=cursor.fetchone()
    cursor.execute(
        """
        SELECT *
        FROM assessment_master
        ORDER BY assessment_id
        """
    )
    assessments=cursor.fetchall()
    cursor.close()
    db.close()
    return templates.TemplateResponse(
        request,
        "select_assessment.html",
        {
            "request":request,
            "username":username,
            "assignment":assignment,
            "assessments":assessments
        }
    )
#-----------------Marks Entry Page-----------------
@app.get("/enter-marks/{assignment_id}/{username}", response_class=HTMLResponse)
def enter_marks(
    request: Request,
    assignment_id: int,
    username: str,
    assessment_type: str
):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute(
        """
        SELECT *
        FROM faculty_assignments
        WHERE id=%s
        """,
        (assignment_id,)
    )
    assignment = cursor.fetchone()
    cursor.execute(
        """
        SELECT max_marks
        FROM assessment_master
        WHERE assessment_name=%s
        """,
        (assessment_type,)
    )
    assessment = cursor.fetchone()
    cursor.execute(
        """
        SELECT
            student_id,
            full_name
        FROM students
        WHERE
            department=%s
            AND semester=%s
            AND section=%s
        ORDER BY student_id
        """,
        (
            assignment["department"],
            assignment["semester"],
            assignment["section"]
        )
    )
    students = cursor.fetchall()
    cursor.close()
    db.close()
    return templates.TemplateResponse(
        request,
        "enter_marks.html",
        {
            "request": request,
            "username": username,
            "assignment": assignment,
            "students": students,
            "assessment_type": assessment_type,
            "max_marks": assessment["max_marks"]
        }
    )
#----------------Marks Summary-----------------
@app.get("/marks-summary/{session_id}/{username}", response_class=HTMLResponse)
def marks_summary(request: Request, session_id: int, username: str):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute(
        """
        SELECT *
        FROM marks_session
        WHERE session_id=%s
        """,
        (session_id,)
    )
    session = cursor.fetchone()
    cursor.close()
    db.close()
    return templates.TemplateResponse(
        request,
        "marks_summary.html",
        {
            "request": request,
            "session": session,
            "username": username
        }
    )
#----------------View Marks-----------------
@app.get("/view-marks/{session_id}/{username}", response_class=HTMLResponse)
def view_marks(request: Request, session_id: int, username: str):
    db = get_db()
    cursor = db.cursor(dictionary=True)

    cursor.execute(
        """
        SELECT *
        FROM marks_session
        WHERE session_id=%s
        """,
        (session_id,)
    )
    session = cursor.fetchone()

    cursor.execute(
        """
        SELECT *
        FROM marks_details
        WHERE session_id=%s
        ORDER BY student_id
        """,
        (session_id,)
    )
    students = cursor.fetchall()
    cursor.close()
    db.close()
    return templates.TemplateResponse(
        request,
        "view_marks.html",
        {
            "request": request,
            "session": session,
            "students": students,
            "username": username
        }
    )
#-----------Edit Marks-----------------
@app.get("/edit-marks/{session_id}/{username}", response_class=HTMLResponse)
def edit_marks(request: Request, session_id: int, username: str):
    db = get_db()
    cursor = db.cursor(dictionary=True)

    cursor.execute(
        """
        SELECT *
        FROM marks_session
        WHERE session_id=%s
        """,
        (session_id,)
    )
    session = cursor.fetchone()

    cursor.execute(
        """
        SELECT *
        FROM marks_details
        WHERE session_id=%s
        ORDER BY student_id
        """,
        (session_id,)
    )
    students = cursor.fetchall()

    cursor.execute(
        """
        SELECT max_marks
        FROM assessment_master
        WHERE assessment_name=%s
        """,
        (session["assessment_type"],)
    )
    assessment = cursor.fetchone()

    cursor.close()
    db.close()
    return templates.TemplateResponse(
        request,
        "edit_marks.html",
        {
            "request": request,
            "session": session,
            "students": students,
            "username": username,
            "max_marks": assessment["max_marks"]
        }
    )
    
 #------------Upload Materials Page-----------------
@app.get("/upload-material/{username}",response_class=HTMLResponse)
def upload_material(request:Request,username:str):
    message=request.query_params.get("message","")
    db=get_db()
    cursor=db.cursor(dictionary=True)
    cursor.execute("""
    SELECT subject
    FROM faculty_assignments
    WHERE faculty_id=(
        SELECT faculty_id
        FROM faculty
        WHERE username=%s
    )
    """,(username,))
    subjects=cursor.fetchall()
    cursor.close()
    db.close()
    return templates.TemplateResponse(
        request,
        "upload_material.html",
        {
            "request":request,
            "username":username,
            "subjects":subjects,
            "message":message
        }
    )

#----------------Faculty Materials-----------------
@app.get("/faculty-materials/{username}",response_class=HTMLResponse)
def faculty_materials(request:Request,username:str):
    message=request.query_params.get("message","")
    db=get_db()
    cursor=db.cursor(dictionary=True)

    cursor.execute("""
    SELECT faculty_id
    FROM faculty
    WHERE username=%s
    """,(username,))
    faculty=cursor.fetchone()

    cursor.execute("""
    SELECT *
    FROM course_materials
    WHERE faculty_id=%s
    ORDER BY uploaded_on DESC
    """,(faculty["faculty_id"],))

    materials=cursor.fetchall()

    cursor.close()
    db.close()

    return templates.TemplateResponse(
        request,
        "faculty_materials.html",
        {
            "request":request,
            "username":username,
            "materials":materials,
            "message":message
        }
    )

#---------Delete Materials-----------------
@app.get("/delete-material/{id}/{username}")
def delete_material(id:int,username:str):
    db=get_db()
    cursor=db.cursor(dictionary=True)
    cursor.execute("SELECT file_path FROM course_materials WHERE id=%s",(id,))
    material=cursor.fetchone()
    if material and os.path.exists(material["file_path"]):
        os.remove(material["file_path"])
    cursor.execute("DELETE FROM course_materials WHERE id=%s",(id,))
    db.commit()
    cursor.close()
    db.close()
    return RedirectResponse(url=f"/faculty-materials/{username}?message=Course Material Deleted Successfully", status_code=303)
#--------Edit Materials-----------------
@app.get("/edit-material/{id}/{username}",response_class=HTMLResponse)
def edit_material(request:Request,id:int,username:str):
    db=get_db()
    cursor=db.cursor(dictionary=True)
    cursor.execute("SELECT * FROM course_materials WHERE id=%s",(id,))
    material=cursor.fetchone()
    cursor.close()
    db.close()
    return templates.TemplateResponse(
        request,
        "edit_material.html",{"request":request,"username":username,"material":material})


#------------------Download Materials-----------------
@app.get("/download/{id}")
def download_material(id:int):
    db=get_db()
    cursor=db.cursor(dictionary=True)
    cursor.execute("""
    SELECT file_name,file_path
    FROM course_materials
    WHERE id=%s
    """,(id,))
    material=cursor.fetchone()
    cursor.close()
    db.close()
    return FileResponse(path=material["file_path"],filename=material["file_name"],media_type="application/octet-stream")

#------------Faculty Change Password Page-----------------
@app.get("/faculty-change-password/{username}",response_class=HTMLResponse)
def faculty_change_password(request:Request,username:str):
    message=request.query_params.get("message","")
    return templates.TemplateResponse(
        request,
        "faculty_change_password.html",
        {
            "request":request,
            "username":username,
            "message":message
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
        request,
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
        request,
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

#----------Faculty Login Verification-----------------
@app.post("/faculty-login")
def faculty_login(

    username: str = Form(...),
    password: str = Form(...)

):

    encrypted = hash_password(password)

    db = get_db()

    cursor = db.cursor(dictionary=True)

    cursor.execute(
        """
        SELECT * FROM faculty
        WHERE username=%s
        AND password=%s
        """,
        (
            username,
            encrypted
        )
    )
    faculty = cursor.fetchone()
    cursor.close()
    db.close()
    if faculty:
        return RedirectResponse(
            url=f"/faculty-dashboard/{username}",
            status_code=303
        )
    return RedirectResponse(
        url="/faculty-login?message=Invalid Username or Password",
        status_code=303
    )
#----------Faculty Profile Update-----------------
@app.post("/update-faculty-profile")
def update_faculty_profile(

    username: str = Form(...),
    email: str = Form(...),
    full_name: str = Form(...),
    mobile: str = Form(...)

):

    db = get_db()
    cursor = db.cursor()

    cursor.execute(
        """
        UPDATE faculty

        SET

        email=%s,

        full_name=%s,

        mobile=%s

        WHERE username=%s
        """,
        (
            email,
            full_name,
            mobile,
            username
        )
    )
    db.commit()
    cursor.close()
    db.close()
    return RedirectResponse(
        url=f"/faculty-profile/{username}",
        status_code=303
    )
    
from datetime import date

@app.post("/save-attendance")
def save_attendance(

    assignment_id: int = Form(...),
    username: str = Form(...),
    attendance_date: str = Form(...),
    present_students: list[str] = Form([])

):

    db = get_db()
    cursor = db.cursor(dictionary=True)

    # -----------------------------
    # Get Faculty Details
    # -----------------------------

    cursor.execute(
        """
        SELECT *
        FROM faculty
        WHERE username=%s
        """,
        (username,)
    )

    faculty = cursor.fetchone()

    # -----------------------------
    # Get Assignment Details
    # -----------------------------

    cursor.execute(
        """
        SELECT *
        FROM faculty_assignments
        WHERE id=%s
        """,
        (assignment_id,)
    )

    assignment = cursor.fetchone()

    # -----------------------------
    # Get Students
    # -----------------------------

    cursor.execute(
        """
        SELECT
            student_id,
            full_name
        FROM students
        WHERE
            department=%s
            AND semester=%s
            AND section=%s
        ORDER BY student_id
        """,
        (
            assignment["department"],
            assignment["semester"],
            assignment["section"]
        )
    )

    students = cursor.fetchall()

    total_students = len(students)
    present_count = len(present_students)
    absent_count = total_students - present_count
    
    # -----------------------------
    # Check Existing Attendance
    # -----------------------------

    cursor.execute(
        """
        SELECT session_id
        FROM attendance_session
        WHERE
            subject=%s
            AND semester=%s
            AND section=%s
            AND slot=%s
            AND attendance_date=%s
        """,
        (
            assignment["subject"],
            assignment["semester"],
            assignment["section"],
            assignment["slot"],
            attendance_date
        )
    )

    existing = cursor.fetchone()

    if existing:

        cursor.close()
        db.close()

        return RedirectResponse(
            url=f"/attendance-exists/{existing['session_id']}/{username}",
            status_code=303
        )

    # -----------------------------
    # Create Attendance Session
    # -----------------------------

    cursor.execute(
        """
        INSERT INTO attendance_session(

            faculty_id,
            subject,
            semester,
            section,
            slot,
            attendance_date,
            total_students,
            present_students,
            absent_students

        )

        VALUES(

            %s,%s,%s,%s,%s,%s,%s,%s,%s

        )
        """,
        (
            faculty["faculty_id"],
            assignment["subject"],
            assignment["semester"],
            assignment["section"],
            assignment["slot"],
            attendance_date,
            total_students,
            present_count,
            absent_count
        )
    )

    db.commit()

    session_id = cursor.lastrowid

    # -----------------------------
    # Save Student Attendance
    # -----------------------------

    for student in students:

        if student["student_id"] in present_students:

            status = "Present"

        else:

            status = "Absent"

        cursor.execute(
            """
            INSERT INTO attendance_details(

                session_id,
                student_id,
                student_name,
                attendance_status

            )

            VALUES(

                %s,%s,%s,%s

            )
            """,
            (
                session_id,
                student["student_id"],
                student["full_name"],
                status
            )
        )

    db.commit()

    cursor.close()
    db.close()

    return RedirectResponse(

        url=f"/attendance-summary/{session_id}/{username}",

        status_code=303

    )

    
from fastapi import Form
from fastapi.responses import RedirectResponse

@app.post("/update-attendance")
def update_attendance(
    session_id: int = Form(...),
    username: str = Form(...),
    reason: str = Form(...),
    present_students: list[str] = Form([])
):

    db = get_db()
    cursor = db.cursor(dictionary=True)

    # -----------------------------
    # Get existing attendance
    # -----------------------------
    cursor.execute(
        """
        SELECT *
        FROM attendance_details
        WHERE session_id=%s
        """,
        (session_id,)
    )

    students = cursor.fetchall()

    present = 0
    absent = 0

    # -----------------------------
    # Update each student
    # -----------------------------
    for student in students:

        old_status = student["attendance_status"]

        if student["student_id"] in present_students:
            new_status = "Present"
            present += 1
        else:
            new_status = "Absent"
            absent += 1

        # Update attendance
        cursor.execute(
            """
            UPDATE attendance_details
            SET attendance_status=%s
            WHERE id=%s
            """,
            (
                new_status,
                student["id"]
            )
        )

        # Save edit log only if changed
        if old_status != new_status:

            cursor.execute(
                """
                INSERT INTO attendance_edit_log(

                    session_id,
                    student_id,
                    old_status,
                    new_status,
                    edited_by,
                    reason

                )

                VALUES(%s,%s,%s,%s,%s,%s)
                """,
                (
                    session_id,
                    student["student_id"],
                    old_status,
                    new_status,
                    username,
                    reason
                )
            )

    # -----------------------------
    # Update session summary
    # -----------------------------
    cursor.execute(
        """
        UPDATE attendance_session
        SET
            present_students=%s,
            absent_students=%s
        WHERE session_id=%s
        """,
        (
            present,
            absent,
            session_id
        )
    )

    db.commit()

    cursor.close()
    db.close()

    return RedirectResponse(
        url=f"/attendance-summary/{session_id}/{username}",
        status_code=303
    )
#-------------Save Marks-----------------
@app.post("/save-marks")
def save_marks(
    assignment_id: int = Form(...),
    username: str = Form(...),
    assessment_type: str = Form(...),
    student_ids: list[str] = Form(...),
    student_names: list[str] = Form(...),
    marks: list[float] = Form(...)
):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute(
        """
        SELECT *
        FROM faculty
        WHERE username=%s
        """,
        (username,)
    )
    faculty = cursor.fetchone()
    cursor.execute(
        """
        SELECT *
        FROM faculty_assignments
        WHERE id=%s
        """,
        (assignment_id,)
    )
    assignment = cursor.fetchone()
    cursor.execute(
        """
        SELECT session_id
        FROM marks_session
        WHERE subject=%s
        AND department=%s
        AND semester=%s
        AND section=%s
        AND assessment_type=%s
        """,
        (
            assignment["subject"],
            assignment["department"],
            assignment["semester"],
            assignment["section"],
            assessment_type
        )
    )
    existing = cursor.fetchone()
    if existing:
        cursor.close()
        db.close()
        return RedirectResponse(
            url=f"/marks-exists/{existing['session_id']}/{username}",
            status_code=303
        )
    highest = max(marks)
    lowest = min(marks)
    average = round(sum(marks) / len(marks), 2)
    cursor.execute(
        """
        SELECT max_marks
        FROM assessment_master
        WHERE assessment_name=%s
        """,
        (assessment_type,)
    )
    assessment = cursor.fetchone()
    pass_mark = assessment["max_marks"] * 0.4
    passed = len([m for m in marks if m >= pass_mark])
    pass_percentage = round((passed / len(marks)) * 100, 2)
    cursor.execute(
        """
        INSERT INTO marks_session(
            faculty_id,
            subject,
            department,
            semester,
            section,
            assessment_type,
            total_students,
            highest_marks,
            lowest_marks,
            average_marks,
            pass_percentage
        )
        VALUES(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
        """,
        (
            faculty["faculty_id"],
            assignment["subject"],
            assignment["department"],
            assignment["semester"],
            assignment["section"],
            assessment_type,
            len(student_ids),
            highest,
            lowest,
            average,
            pass_percentage
        )
    )
    db.commit()
    session_id = cursor.lastrowid
    for i in range(len(student_ids)):
        cursor.execute(
            """
            INSERT INTO marks_details(
                session_id,
                student_id,
                student_name,
                marks
            )
            VALUES(%s,%s,%s,%s)
            """,
            (
                session_id,
                student_ids[i],
                student_names[i],
                marks[i]
            )
        )
    db.commit()
    cursor.close()
    db.close()
    return RedirectResponse(
        url=f"/marks-summary/{session_id}/{username}",
        status_code=303
    )
    
#-----------Marks Entry Exists-----------------
@app.get("/marks-exists/{session_id}/{username}", response_class=HTMLResponse)
def marks_exists(
    request: Request,
    session_id: int,
    username: str
):
    db = get_db()
    cursor = db.cursor(dictionary=True)

    cursor.execute("""
        SELECT *
        FROM marks_session
        WHERE session_id=%s
    """, (session_id,))

    session = cursor.fetchone()

    cursor.close()
    db.close()

    return templates.TemplateResponse(
        request,
        "marks_exists.html",
        {
            "request": request,
            "session": session,
            "username": username
        }
    )
#---------Update Marks-----------------
@app.post("/update-marks")
def update_marks(
    session_id: int = Form(...),
    username: str = Form(...),
    student_ids: list[str] = Form(...),
    marks: list[float] = Form(...),
    reason: str = Form(...)
):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute(
        """
        SELECT *
        FROM marks_details
        WHERE session_id=%s
        ORDER BY student_id
        """,
        (session_id,)
    )
    old_marks = cursor.fetchall()
    for i in range(len(old_marks)):
        old = old_marks[i]["marks"]
        new = marks[i]
        cursor.execute(
            """
            UPDATE marks_details
            SET marks=%s
            WHERE id=%s
            """,
            (
                new,
                old_marks[i]["id"]
            )
        )
        if old != new:
            cursor.execute(
                """
                INSERT INTO marks_edit_log(
                    session_id,
                    student_id,
                    old_marks,
                    new_marks,
                    edited_by,
                    reason
                )
                VALUES(%s,%s,%s,%s,%s,%s)
                """,
                (
                    session_id,
                    student_ids[i],
                    old,
                    new,
                    username,
                    reason
                )
            )
    highest = max(marks)
    lowest = min(marks)
    average = round(sum(marks) / len(marks), 2)
    cursor.execute(
        """
        SELECT assessment_type
        FROM marks_session
        WHERE session_id=%s
        """,
        (session_id,)
    )
    session = cursor.fetchone()
    cursor.execute(
        """
        SELECT max_marks
        FROM assessment_master
        WHERE assessment_name=%s
        """,
        (session["assessment_type"],)
    )
    assessment = cursor.fetchone()
    pass_mark = assessment["max_marks"] * 0.4
    passed = len([m for m in marks if m >= pass_mark])
    pass_percentage = round((passed / len(marks)) * 100, 2)
    cursor.execute(
        """
        UPDATE marks_session
        SET
            highest_marks=%s,
            lowest_marks=%s,
            average_marks=%s,
            pass_percentage=%s
        WHERE session_id=%s
        """,
        (
            highest,
            lowest,
            average,
            pass_percentage,
            session_id
        )
    )
    db.commit()
    cursor.close()
    db.close()
    return RedirectResponse(
        url=f"/marks-summary/{session_id}/{username}",
        status_code=303
    )

#--------------Upload Materials Post-----------------
@app.post("/upload-material/{username}")
async def upload_material_post(username:str,subject:str=Form(...),title:str=Form(...),description:str=Form(...),material:UploadFile=File(...)):
    os.makedirs("uploads/materials",exist_ok=True)
    file_path=f"uploads/materials/{material.filename}"
    with open(file_path,"wb") as buffer:
        shutil.copyfileobj(material.file,buffer)
    db=get_db()
    cursor=db.cursor()
    cursor.execute("""
    SELECT faculty_id
    FROM faculty
    WHERE username=%s
    """,(username,))
    faculty=cursor.fetchone()
    faculty_id=faculty[0]
    cursor.execute("""
    INSERT INTO course_materials(faculty_id,subject,title,description,file_name,file_path)
    VALUES(%s,%s,%s,%s,%s,%s)
    """,(faculty_id,subject,title,description,material.filename,file_path))
    db.commit()
    cursor.close()
    db.close()
    return RedirectResponse( url=f"/upload-material/{username}?message=Course Material Uploaded Successfully", status_code=303
)

#----------Edit material post-----------------
@app.post("/edit-material/{id}/{username}")
async def update_material(
    id:int,
    username:str,
    title:str=Form(...),
    description:str=Form(...),
    material:UploadFile=File(None)
):
    db=get_db()
    cursor=db.cursor(dictionary=True)

    cursor.execute(
        "SELECT * FROM course_materials WHERE id=%s",
        (id,)
    )

    old=cursor.fetchone()

    file_name=old["file_name"]
    file_path=old["file_path"]

    if material and material.filename!="":

        if os.path.exists(file_path):
            os.remove(file_path)

        os.makedirs("uploads/materials",exist_ok=True)

        file_path=f"uploads/materials/{material.filename}"

        with open(file_path,"wb") as buffer:
            shutil.copyfileobj(material.file,buffer)

        file_name=material.filename

    cursor.execute("""
    UPDATE course_materials
    SET
        title=%s,
        description=%s,
        file_name=%s,
        file_path=%s
    WHERE id=%s
    """,
    (
        title,
        description,
        file_name,
        file_path,
        id
    ))

    db.commit()

    cursor.close()
    db.close()

    return RedirectResponse(
        url=f"/faculty-materials/{username}?message=Course Material Updated Successfully",
        status_code=303
    )

#--------------------Verify Faculty Password-----------------
@app.post("/faculty-change-password/{username}")
def update_faculty_password(
    username:str,
    current_password:str=Form(...),
    new_password:str=Form(...),
    confirm_password:str=Form(...)
):
    if new_password!=confirm_password:
        return RedirectResponse(
            url=f"/faculty-change-password/{username}?message=New Password and Confirm Password do not match",
            status_code=303
        )

    db=get_db()
    cursor=db.cursor(dictionary=True)

    cursor.execute(
        """
        SELECT *
        FROM faculty
        WHERE username=%s
        """,
        (username,)
    )

    faculty=cursor.fetchone()

    if faculty["password"]!=hash_password(current_password):
        cursor.close()
        db.close()
        return RedirectResponse(
            url=f"/faculty-change-password/{username}?message=Current Password is incorrect",
            status_code=303
        )

    cursor.execute(
        """
        UPDATE faculty
        SET password=%s
        WHERE username=%s
        """,
        (
            hash_password(new_password),
            username
        )
    )

    db.commit()

    cursor.close()
    db.close()

    return RedirectResponse(
        url=f"/faculty-change-password/{username}?message=Password Changed Successfully",
        status_code=303
    )
# ---------------- LOGOUT ----------------

@app.get("/logout")
def logout():

    return RedirectResponse(
        url="/",
        status_code=303
    )
    