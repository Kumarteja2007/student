from flask import Flask, render_template, request, redirect, url_for, flash
import sqlite3
import hashlib

app = Flask(__name__)
app.secret_key = "secret123"

def get_db_connection():
    conn = sqlite3.connect("students.db")
    conn.row_factory = sqlite3.Row
    return conn

conn = get_db_connection()
conn.execute("""
CREATE TABLE IF NOT EXISTS students (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL
)
""")
conn.commit()
conn.close()

def hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/register", methods=["POST"])
def register():
    username = request.form["username"]
    password = request.form["password"]
    confirm = request.form["confirm"]

    if password != confirm:
        flash("Passwords do not match!")
        return redirect(url_for("index"))

    encrypted = hash_password(password)

    try:
        conn = get_db_connection()
        conn.execute(
            "INSERT INTO students (username, password) VALUES (?, ?)",
            (username, encrypted)
        )
        conn.commit()
        conn.close()
        flash("Registration successful!")
    except sqlite3.IntegrityError:
        flash("Username already exists!")

    return redirect(url_for("index"))

@app.route("/login", methods=["POST"])
def login():
    username = request.form["username"]
    password = request.form["password"]
    encrypted = hash_password(password)

    conn = get_db_connection()
    user = conn.execute(
        "SELECT * FROM students WHERE username=? AND password=?",
        (username, encrypted)
    ).fetchone()
    conn.close()

    if user:
        return redirect(url_for("welcome", username=username))
    else:
        flash("Invalid username or password!")
        return redirect(url_for("index"))
    

@app.route("/welcome/<username>")
def welcome(username):
    return render_template("welcome.html", username=username)


if __name__ == "__main__":
    app.run(debug=True)
