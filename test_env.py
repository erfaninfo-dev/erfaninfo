import os
from dotenv import load_dotenv

load_dotenv()  # Load variables from .env file

print("DB_TYPE:", os.getenv("DB_TYPE"))
print("DATABASE_URL:", os.getenv("DATABASE_URL")) 