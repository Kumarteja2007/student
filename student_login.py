import sqlite3
import hashlib
import getpass


conn = sqlite3.connect("students.db")
cursor = conn.cursor()

cursor.execute("""
CREATE TABLE IF NOT EXISTS students (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL
)
""")
conn.commit()

def hash_password(password):
    return hashlib.sha256(password.encode('utf-8')).hexdigest()

def register():
    print("\n--- Student Registration ---")
    username = input("Enter username: ").strip()
    password = getpass.getpass("Enter password: ")
    confirm_password = getpass.getpass("Confirm password: ")

    if not username or not password:
        print("Username and password cannot be empty!")
        return

    if password != confirm_password:
        print("Passwords do not match!")
        return

    encrypted_password = hash_password(password)

    try:
        cursor.execute(
            "INSERT INTO students (username, password) VALUES (?, ?)",
            (username, encrypted_password)
        )
        conn.commit()
        print("Registration successful!")
    except sqlite3.IntegrityError:
        print("Username already exists!")

def login():
    print("\n--- Student Login ---")
    username = input("Enter username: ").strip()
    password = getpass.getpass("Enter password: ")

    encrypted_password = hash_password(password)

    cursor.execute(
        "SELECT * FROM students WHERE username=? AND password=?",
        (username, encrypted_password)
    )

    if cursor.fetchone():
        print(f"Login successful! Welcome, {username}")
    else:
        print("Invalid username or password!")

def main_menu():
    while True:
        print("\n===== Student Login System =====")
        print("1. Register")
        print("2. Login")
        print("3. Exit")

        choice = input("Enter your choice: ")

        if choice == "1":
            register()
        elif choice == "2":
            login()
        elif choice == "3":
            print("Thank you for using the system!")
            break
        else:
            print("Invalid choice. Please try again.")

main_menu()
conn.close()
