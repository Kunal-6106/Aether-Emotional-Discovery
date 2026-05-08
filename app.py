from flask import Flask, render_template, request, redirect, session, url_for, flash
import mysql.connector
from werkzeug.security import generate_password_hash, check_password_hash
from config import Config

app = Flask(__name__)
app.config.from_object(Config)


# ---------------- DB CONNECTION ----------------
def get_db_connection():
    return mysql.connector.connect(
        host=app.config['MYSQL_HOST'],
        user=app.config['MYSQL_USER'],
        password=app.config['MYSQL_PASSWORD'],
        database=app.config['MYSQL_DATABASE']
    )


# ---------------- LANDING ----------------
@app.route('/')
def landing():
    return render_template('index.html')


# ---------------- LOGIN ----------------
@app.route('/login', methods=['GET', 'POST'])
def login():
    if 'user_id' in session:
        return redirect(url_for('home'))

    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']

        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        
        try:
            cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
            user = cursor.fetchone()

            if user and check_password_hash(user['password'], password):
                session['user_id'] = user['id']
                session['user_name'] = user['full_name']
                flash("Login successful!", "success")
                return redirect(url_for('home'))
            else:
                flash("Invalid email or password.", "danger")
        except mysql.connector.Error as err:
            flash("Database connection error.", "danger")
            print(f"Error: {err}")
        finally:
            cursor.close()
            conn.close()

    return render_template('login.html')


# ---------------- REGISTER ----------------
@app.route('/register', methods=['GET', 'POST'])
def register():
    if 'user_id' in session:
        return redirect(url_for('home'))

    if request.method == 'POST':
        full_name = request.form['full_name']
        email = request.form['email']
        password = request.form['password']

        hashed_password = generate_password_hash(password)

        conn = get_db_connection()
        cursor = conn.cursor()

        try:
            cursor.execute("""
                INSERT INTO users (full_name, email, password)
                VALUES (%s, %s, %s)
            """, (full_name, email, hashed_password))
            conn.commit()
            flash("Account created! Please login.", "success")
            return redirect(url_for('login'))

        except mysql.connector.IntegrityError:
            flash("Email already exists.", "danger")
        finally:
            cursor.close()
            conn.close()

    return render_template('register.html')


# ---------------- LOGOUT ----------------
@app.route('/logout')
def logout():
    session.clear()
    flash("Logged out successfully.", "success")
    return redirect(url_for('landing'))


# ---------------- HOME / DISCOVER ----------------
@app.route('/home')
def home():
    if 'user_id' not in session:
        return redirect(url_for('login'))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    try:
        search_query = request.args.get('search', '').strip()
        selected_genre = request.args.get('genre', '').strip()

        query = "SELECT * FROM content WHERE 1=1"
        params = []

        if search_query:
            query += " AND (title LIKE %s OR description LIKE %s)"
            params.extend([f"%{search_query}%", f"%{search_query}%"])

        if selected_genre:
            query += " AND genre = %s"
            params.append(selected_genre)

        query += " ORDER BY is_featured DESC, rating DESC, id DESC"

        cursor.execute(query, tuple(params))
        movies = cursor.fetchall()

        cursor.execute("SELECT * FROM content WHERE is_featured = TRUE ORDER BY RAND() LIMIT 1")
        featured_movie = cursor.fetchone()

        cursor.execute("SELECT DISTINCT genre FROM content WHERE genre IS NOT NULL ORDER BY genre")
        genres = [row['genre'] for row in cursor.fetchall()]

        # Curated Row Data
        cursor.execute("SELECT * FROM content WHERE genre='Sci-Fi' ORDER BY rating DESC LIMIT 10")
        sci_fi = cursor.fetchall()

        cursor.execute("SELECT * FROM content WHERE genre='Thriller' ORDER BY rating DESC LIMIT 10")
        thrillers = cursor.fetchall()

        cursor.execute("SELECT * FROM content WHERE genre='Drama' ORDER BY rating DESC LIMIT 10")
        dramas = cursor.fetchall()

        # Recommendation Logic
        cursor.execute("""
            SELECT rating_label, COUNT(*) AS total FROM ratings
            WHERE user_id = %s GROUP BY rating_label ORDER BY total DESC LIMIT 1
        """, (session['user_id'],))
        emotion_result = cursor.fetchone()
        top_emotion = emotion_result['rating_label'] if emotion_result else None

        recommended_movies = []
        if top_emotion:
            cursor.execute("""
                SELECT DISTINCT c.* FROM content c
                JOIN ratings r ON c.id = r.content_id
                WHERE r.rating_label = %s AND c.id NOT IN (
                    SELECT content_id FROM watch_history WHERE user_id = %s
                )
                ORDER BY c.rating DESC, RAND() LIMIT 12
            """, (top_emotion, session['user_id']))
            recommended_movies = cursor.fetchall()

    finally:
        cursor.close()
        conn.close()

    return render_template(
        'home.html',
        movies=movies,
        featured_movie=featured_movie,
        genres=genres,
        search_query=search_query,
        selected_genre=selected_genre,
        sci_fi=sci_fi,
        thrillers=thrillers,
        dramas=dramas,
        top_emotion=top_emotion,
        recommended_movies=recommended_movies
    )


# ---------------- CONTENT DETAIL ----------------
@app.route('/content/<int:content_id>')
def content_detail(content_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("SELECT * FROM content WHERE id = %s", (content_id,))
        movie = cursor.fetchone()

        if not movie:
            flash("Content not found.", "danger")
            return redirect(url_for('home'))

        cursor.execute("SELECT rating_label FROM ratings WHERE user_id = %s AND content_id = %s", (session['user_id'], content_id))
        user_rating_row = cursor.fetchone()
        user_rating = user_rating_row['rating_label'] if user_rating_row else None

        cursor.execute("SELECT * FROM content WHERE genre = %s AND id != %s LIMIT 8", (movie['genre'], content_id))
        similar_movies = cursor.fetchall()
        
    finally:
        cursor.close()
        conn.close()

    return render_template('content_detail.html', movie=movie, user_rating=user_rating, similar_movies=similar_movies)


# ---------------- RATE CONTENT ----------------
@app.route('/rate/<int:content_id>', methods=['POST'])
def rate_content(content_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))

    rating_label = request.form.get('rating_label')
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute("SELECT id FROM ratings WHERE user_id = %s AND content_id = %s", (session['user_id'], content_id))
        if cursor.fetchone():
            cursor.execute("UPDATE ratings SET rating_label = %s, rated_at = NOW() WHERE user_id = %s AND content_id = %s", (rating_label, session['user_id'], content_id))
        else:
            cursor.execute("INSERT INTO ratings (user_id, content_id, rating_label) VALUES (%s, %s, %s)", (session['user_id'], content_id, rating_label))
        conn.commit()
        flash("Rating saved.", "success")
    finally:
        cursor.close()
        conn.close()

    return redirect(url_for('content_detail', content_id=content_id))


# ---------------- WATCH HISTORY ----------------
@app.route('/watch/<int:content_id>')
def add_watch(content_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))

    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute("SELECT id FROM watch_history WHERE user_id = %s AND content_id = %s", (session['user_id'], content_id))
        if cursor.fetchone():
            cursor.execute("UPDATE watch_history SET watched_at = NOW() WHERE user_id = %s AND content_id = %s", (session['user_id'], content_id))
        else:
            cursor.execute("INSERT INTO watch_history (user_id, content_id) VALUES (%s, %s)", (session['user_id'], content_id))
        conn.commit()
        flash("Added to history.", "success")
    finally:
        cursor.close()
        conn.close()

    return redirect(url_for('content_detail', content_id=content_id))


@app.route('/history')
def history():
    if 'user_id' not in session:
        return redirect(url_for('login'))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT c.*, w.watched_at FROM watch_history w JOIN content c ON w.content_id = c.id WHERE w.user_id = %s ORDER BY w.watched_at DESC", (session['user_id'],))
    watched = cursor.fetchall()
    cursor.close()
    conn.close()

    return render_template('history.html', watched=watched)


# ---------------- ANALYTICS ----------------
@app.route('/analytics')
def analytics():
    if 'user_id' not in session:
        return redirect(url_for('login'))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    user_id = session['user_id']

    cursor.execute("SELECT COUNT(*) as total FROM watch_history WHERE user_id = %s", (user_id,))
    total_watched = cursor.fetchone()['total']

    cursor.execute("SELECT COUNT(*) as total FROM ratings WHERE user_id = %s", (user_id,))
    total_ratings = cursor.fetchone()['total']

    cursor.execute("SELECT rating_label, COUNT(*) as count FROM ratings WHERE user_id = %s GROUP BY rating_label ORDER BY count DESC", (user_id,))
    emotional_profile = cursor.fetchall()

    cursor.execute("SELECT c.genre, COUNT(*) as count FROM ratings r JOIN content c ON r.content_id = c.id WHERE r.user_id = %s GROUP BY c.genre ORDER BY count DESC LIMIT 1", (user_id,))
    favorite_genre = cursor.fetchone()

    cursor.execute("SELECT c.platform, COUNT(*) as count FROM watch_history w JOIN content c ON w.content_id = c.id WHERE w.user_id = %s GROUP BY c.platform ORDER BY count DESC LIMIT 1", (user_id,))
    favorite_platform = cursor.fetchone()

    cursor.close()
    conn.close()

    return render_template('analytics.html', total_watched=total_watched, total_ratings=total_ratings, emotional_profile=emotional_profile, favorite_genre=favorite_genre, favorite_platform=favorite_platform)


if __name__ == '__main__':
    app.run(debug=True)