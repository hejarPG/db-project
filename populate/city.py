import psycopg2
from faker import Faker
import random

# Database connection details
DB_NAME = "online-service-market"
DB_USER = "postgres"
DB_PASSWORD = "1598796@Amir"
DB_HOST = "localhost"
DB_PORT = "5432"

# Initialize Faker
fake = Faker()

# Connect to the PostgreSQL database
conn = psycopg2.connect(
    dbname=DB_NAME,
    user=DB_USER,
    password=DB_PASSWORD,
    host=DB_HOST,
    port=DB_PORT
)
cursor = conn.cursor()

try:
    # Start transaction
    conn.autocommit = False
    
    # Insert 30 provinces with a placeholder capital_id
    province_ids = []
    for _ in range(30):
        name = fake.unique.city()
        location = f'({random.uniform(-180, 180)}, {random.uniform(-90, 90)})'
        cursor.execute("INSERT INTO province (name, capital_id, location) VALUES (%s, %s, %s) RETURNING id", (name, 0, location))
        province_id = cursor.fetchone()[0]
        province_ids.append(province_id)
    
    # Assign random capital cities to provinces and update capital_id
    for province_id in province_ids:
        cursor.execute("INSERT INTO city (name, province_id, location) VALUES (%s, %s, %s) RETURNING id", 
                       (fake.city(), province_id, f'({random.uniform(-180, 180)}, {random.uniform(-90, 90)})'))
        capital_id = cursor.fetchone()[0]
        cursor.execute("UPDATE province SET capital_id = %s WHERE id = %s", (capital_id, province_id))
    
    # Insert 270 more cities (since 30 capitals are already inserted)
    for _ in range(270):
        name = fake.city()
        province_id = random.choice(province_ids)
        location = f'({random.uniform(-180, 180)}, {random.uniform(-90, 90)})'
        cursor.execute("INSERT INTO city (name, province_id, location) VALUES (%s, %s, %s)", (name, province_id, location))
    
    # Commit transaction
    conn.commit()
    print("Database successfully populated!")
except Exception as e:
    conn.rollback()
    print(f"Error occurred: {e}")
finally:
    cursor.close()
    conn.close()
