import psycopg2
from faker import Faker
import random

# Initialize Faker
fake = Faker()

# Database connection details
DB_NAME = "online-service-market"
DB_USER = "postgres"
DB_PASSWORD = "1598796@Amir"
DB_HOST = "localhost"
DB_PORT = "5432"

# Connect to the PostgreSQL database
conn = psycopg2.connect(
    dbname=DB_NAME,
    user=DB_USER,
    password=DB_PASSWORD,
    host=DB_HOST,
    port=DB_PORT
)
cursor = conn.cursor()

# Insert fake provinces
num_provinces = 20
province_ids = []
for _ in range(num_provinces):
    name = fake.unique.city()
    location = f'({random.uniform(-180, 180)}, {random.uniform(-90, 90)})'
    cursor.execute(
        """
        INSERT INTO province (name, location, capital_id) 
        VALUES (%s, %s, 0) RETURNING id
        """,
        (name, location)
    )
    province_id = cursor.fetchone()[0]
    province_ids.append(province_id)

# Insert fake cities
num_cities = 100
city_ids = []
for _ in range(num_cities):
    name = fake.unique.city()
    province_id = random.choice(province_ids)
    location = f'({random.uniform(-180, 180)}, {random.uniform(-90, 90)})'
    cursor.execute(
        """
        INSERT INTO city (name, province_id, location) 
        VALUES (%s, %s, %s) RETURNING id
        """,
        (name, province_id, location)
    )
    city_ids.append(cursor.fetchone()[0])

# Update province capital_id with a random city from the same province
for province_id in province_ids:
    cursor.execute("SELECT id FROM city WHERE province_id = %s ORDER BY RANDOM() LIMIT 1", (province_id,))
    city = cursor.fetchone()
    if city:
        cursor.execute("UPDATE province SET capital_id = %s WHERE id = %s", (city[0], province_id))

# Commit changes and close connection
conn.commit()
cursor.close()
conn.close()

print("Database populated successfully!")