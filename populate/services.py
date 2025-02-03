import psycopg2
from faker import Faker
import random

# Set up Faker instance to generate fake data
fake = Faker()

# Connect to PostgreSQL database
conn = psycopg2.connect(
    dbname="online-service-market",  # Replace with your database name
    user="postgres",  # Replace with your username
    password="1598796@Amir",  # Replace with your password
    host="localhost",  # Replace with your host if different
    port="5432"  # Default PostgreSQL port
)

# Create a cursor object to interact with the database
cursor = conn.cursor()

# Function to insert categories
def insert_categories(num_records):
    categories = []
    for _ in range(num_records):
        name = fake.word().capitalize()
        image_uri = fake.image_url()
        max_price = round(random.uniform(100, 1000), 2)
        min_price = round(random.uniform(10, max_price), 2)
        
        categories.append((name, image_uri, max_price, min_price))

    # Insert categories into the category table
    cursor.executemany("""
        INSERT INTO category (name, image_uri, max_price, min_price)
        VALUES (%s, %s, %s, %s)
    """, categories)
    conn.commit()

# Function to insert subcategories (Ensuring unique category_id and name combination)
def insert_subcategories(num_records):
    subcategories = []
    
    cursor.execute("SELECT id FROM category")
    category_ids = [row[0] for row in cursor.fetchall()]
    
    for _ in range(num_records):
        category_id = random.choice(category_ids)
        name = fake.word().capitalize()
        image_uri = fake.image_url()

        # Add subcategory to list (no need for unique check now, as we handle it with ON CONFLICT)
        subcategories.append((category_id, name, image_uri))

    # Insert subcategories into the subcategory table, using ON CONFLICT to avoid duplicates
    cursor.executemany("""
        INSERT INTO subcategory (category_id, name, image_uri)
        VALUES (%s, %s, %s)
        ON CONFLICT (category_id, name) DO NOTHING
    """, subcategories)
    conn.commit()


# Function to insert services
def insert_services(num_records):
    services = []
    
    cursor.execute("SELECT category_id, name FROM subcategory")
    subcategories = cursor.fetchall()
    
    for _ in range(num_records):
        category_id, subcategory_name = random.choice(subcategories)
        name = fake.company()
        description = fake.text(max_nb_chars=200)
        image_uri = fake.image_url()
        
        services.append((category_id, subcategory_name, name, description, image_uri))

    # Insert services into the service table
    cursor.executemany("""
        INSERT INTO service (category_id, subcategory_name, name, description, image_uri)
        VALUES (%s, %s, %s, %s, %s)
    """, services)
    conn.commit()

# Number of records to insert
insert_categories(10)      # Insert 10 categories
insert_subcategories(50)   # Insert 20 subcategories (with unique category_id and name combination)
insert_services(200)        # Insert 50 services

# Close cursor and connection
cursor.close()
conn.close()

print("Dummy data inserted successfully!")
