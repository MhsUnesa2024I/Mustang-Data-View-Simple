from asyncio import open_connection
from flask import Flask, redirect, render_template, request
import mysql.connector

app = Flask(__name__)

def get_conn():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="db_ford-mustang"
    )

@app.route("/")
def index():
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM mustang_basic_view ORDER BY id ASC")
    mustangs = cursor.fetchall()
    cursor.close()
    conn.close()

    return render_template("index.html", mustangs=mustangs)

@app.route("/details/<int:id>")
def details(id):
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT 
            *,
            mustang_age(release_year) AS age
        FROM mustangs
        WHERE id = %s
    """, (id,))

    mustang = cursor.fetchone()

    cursor.close()
    conn.close()

    return render_template("details.html", m=mustang)


@app.route("/create", methods=["GET", "POST"])
def create():
    if request.method == "POST":
        name = request.form.get("name")
        release_year = request.form.get("release_year")
        generation = request.form.get("generation")

        conn = get_conn()
        cursor = conn.cursor()

        cursor.execute("CALL add_mustang_simple(%s, %s, %s)", 
                       (name, release_year, generation))

        conn.commit()
        cursor.close()
        conn.close()

        return redirect("/")

    return render_template("create.html")


@app.route("/create_advanced", methods=["GET", "POST"])
def create_advanced():
    if request.method == "POST":
        fields = (
            request.form.get("name"),
            request.form.get("release_year"),
            request.form.get("generation"),
            request.form.get("body_type"),
            request.form.get("transmission"),
            request.form.get("drivetrain"),
            request.form.get("car_engine"),
            request.form.get("horse_power"),
            request.form.get("torque"),
            request.form.get("top_speed"),
            request.form.get("zero_to_sixty"),
            request.form.get("price"),
            request.form.get("description")
        )

        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO mustangs(
                name, release_year, generation,
                body_type, transmission, drivetrain, car_engine,
                horse_power, torque, top_speed, zero_to_sixty,
                price, description
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, fields)

        conn.commit()
        cursor.close()
        conn.close()

        return redirect("/")

    return render_template("create_advanced.html")


@app.route("/edit/<int:id>", methods=["GET", "POST"])
def edit(id):
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    if request.method == "GET":
        cursor.execute("SELECT * FROM mustangs WHERE id = %s", (id,))
        mustang = cursor.fetchone()
        cursor.close()
        conn.close()
        return render_template("edit.html", m=mustang)

    if request.method == "POST":
        name = request.form.get("name")
        release_year = request.form.get("release_year")
        generation = request.form.get("generation")

        conn = get_conn()
        cursor = conn.cursor()

        cursor.execute("CALL update_mustang_simple(%s, %s, %s, %s)", 
                       (id, name, release_year, generation))

        conn.commit()
        cursor.close()
        conn.close()

        return redirect("/")

    
@app.route("/edit_advanced/<int:id>", methods=["GET", "POST"])
def edit_advanced(id):
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    if request.method == "GET":
        cursor.execute("SELECT * FROM mustangs WHERE id = %s", (id,))
        mustang = cursor.fetchone()
        cursor.close()
        conn.close()
        return render_template("edit_advanced.html", m=mustang)

    if request.method == "POST":
        fields = (
            request.form.get("name"),
            request.form.get("release_year"),
            request.form.get("generation"),
            request.form.get("body_type"),
            request.form.get("transmission"),
            request.form.get("drivetrain"),
            request.form.get("car_engine"),
            request.form.get("horse_power"),
            request.form.get("torque"),
            request.form.get("top_speed"),
            request.form.get("zero_to_sixty"),
            request.form.get("price"),
            request.form.get("description"),
            id
        )

        cursor.execute("""
            UPDATE mustangs SET
                name=%s,
                release_year=%s,
                generation=%s,
                body_type=%s,
                transmission=%s,
                drivetrain=%s,
                car_engine=%s,
                horse_power=%s,
                torque=%s,
                top_speed=%s,
                zero_to_sixty=%s,
                price=%s,
                description=%s
            WHERE id=%s
        """, fields)

        conn.commit()
        cursor.close()
        conn.close()

        return redirect("/")

    
@app.route("/delete/<int:id>")
def delete(id):
    conn = get_conn()
    cursor = conn.cursor()

    cursor.execute("DELETE FROM mustangs WHERE id=%s", (id,))
    conn.commit()

    cursor.close()
    conn.close()

    return redirect("/")


@app.route("/history")
def history():
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM mustang_delete_history ORDER BY deleted_at DESC")
    rows = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template("history.html", rows=rows)




if __name__ == "__main__":
    app.run(debug=True)
