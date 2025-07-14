"""
create_tables.py
----------------
This script creates all database tables defined in your SQLAlchemy models (in app.py).

How to use:
1. Make sure your environment variables are set to connect to the correct database (Render PostgreSQL or local MySQL).
2. Run this script:
   python create_tables.py

If you run this on Render (via Shell), it will create the tables in your Render PostgreSQL database.
"""

from app import app, db

def main():
    with app.app_context():
        db.create_all()
        print("All tables created successfully!")

if __name__ == "__main__":
    main() 