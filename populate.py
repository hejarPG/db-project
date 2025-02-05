import psycopg2
import random
import faker
from datetime import datetime, timedelta
db_config = {
 "dbname": "online-service-market",
 "user": "postgres",
 "password": "1598796@Amir",
 "host": "localhost",
 "port": "5432"
}

fake = faker.Faker()
available_place_enum = ['customer', 'specialist', 'both']
sex_enum = ['male', 'female']
question_type_enum = ['descriptive', 'numeric', 'multiple choice']
status_enum = ['finding specialist', 'in progress', 'finished', 'canceled']

def random_date(start_date, end_date):
    delta = end_date - start_date
    random_days = random.randint(0, delta.days)  # Random number of days
    return start_date + timedelta(days=random_days)

def province(conn, num):
    conn.autocommit = False 
    cursor = conn.cursor()
    for _ in range(num):
        province_name = fake.unique.state()
        province_location = f'({random.uniform(-180, 180)}, {random.uniform(-90, 90)})'
        city_name = fake.unique.city()
        city_location = f'({random.uniform(-180, 180)}, {random.uniform(-90, 90)})'
        cursor.execute("INSERT INTO province (name, capital_id, location) VALUES (%s, 0, %s) RETURNING id", (province_name, province_location))
        province_id = cursor.fetchone()[0]
        cursor.execute("INSERT INTO city (name, province_id, location) VALUES (%s, %s, %s) RETURNING id", (city_name, province_id, city_location))
        city_id = cursor.fetchone()[0]
        cursor.execute("UPDATE province SET capital_id=%s WHERE id=%s", (city_id, province_id))
    conn.commit()
    cursor.close()

def city(conn, num):
    cursor = conn.cursor()
    cursor.execute("SELECT id FROM province")
    provinces = cursor.fetchall()
    for _ in range(num):
        city_name = fake.unique.city()
        city_location = f'({random.uniform(-180, 180)}, {random.uniform(-90, 90)})'
        province_id = random.choice(provinces)
        cursor.execute("INSERT INTO city (name, province_id, location) VALUES (%s, %s, %s)", (city_name, province_id, city_location))
    conn.commit()
    cursor.close()

def category(conn, num):
    cursor = conn.cursor()
    for i in range(num):
        name = f'Category #{i}'
        image_uri = fake.image_url()
        max_price = random.uniform(0, 10000)
        min_price = random.uniform(0, max_price)
        cursor.execute("INSERT INTO category (name, image_uri, max_price, min_price) VALUES (%s, %s, %s, %s)", (name, image_uri, max_price, min_price))
    conn.commit()
    cursor.close()

def subcategory(conn, num):
    cursor = conn.cursor()
    cursor.execute("SELECT id FROM category")
    categories = cursor.fetchall()

    for i in range(num):
        category_id = random.choice(categories)
        name = f'Subcategory #{i}'
        image_uri = fake.image_url()
        cursor.execute("INSERT INTO subcategory (name, category_id, image_uri) VALUES (%s, %s, %s)", (name, category_id, image_uri))

    conn.commit()
    cursor.close()

def service(conn, num):
    cursor = conn.cursor()
    cursor.execute("SELECT category_id, name FROM subcategory")
    subcategories = cursor.fetchall()

    for _ in range(num):
        name = fake.unique.job()
        description = fake.paragraph()
        available_at = random.choice(available_place_enum)
        image_uri = fake.image_url()
        category_id, subcategory_name = random.choice(subcategories)
        cursor.execute("INSERT INTO service (category_id, subcategory_name, name, description, available_at, image_uri) VALUES (%s, %s, %s, %s, %s, %s)", (category_id, subcategory_name, name, description, available_at, image_uri))
    conn.commit()
    cursor.close()

def specialist(conn, num):
    cursor = conn.cursor()
    cursor.execute("SELECT id FROM city")
    cities = cursor.fetchall()
    cursor.execute("SELECT id FROM category")
    categories = cursor.fetchall()
    for _ in range(num):
        first_name = ""
        sex = random.choice(sex_enum)
        if sex == 'male':
            first_name = fake.first_name_male()
        else:
            first_name = fake.first_name_female()

        last_name = fake.last_name()
        phone_number = fake.unique.phone_number()
        image_uri = fake.image_url()
        city_id = random.choice(cities)
        location =  f'({random.uniform(-180, 180)}, {random.uniform(-90, 90)})'
        address = fake.address()
        operating_radius = random.randint(1, 50)
        category_id = random.choice(categories)

        cursor.execute("INSERT INTO specialist (first_name, last_name, phone_number, sex, image_uri, city_id, location, address, operating_radius, service_category_id) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", (first_name, last_name, phone_number, sex, image_uri, city_id, location, address, operating_radius, category_id))
    
    conn.commit()
    cursor.close()
        
def question(conn, max_num):
    cursor = conn.cursor()
    cursor.execute("SELECT id FROM service")
    services = cursor.fetchall()

    for service_id in services:
        num = random.randint(1, max_num)
        for i in range(num):
            text = fake.sentence(15)
            question_type = random.choice(question_type_enum)
            is_multiple_answer_allowed = None,
            if question_type == 'multiple choice':
                is_multiple_answer_allowed = random.choice([True, False])
            cursor.execute("INSERT INTO question (service_id, text, ordering, type, is_multiple_answer_allowed) VALUES (%s, %s, %s, %s, %s)", (service_id, text, i, question_type, is_multiple_answer_allowed))
    
    conn.commit()
    cursor.close()

def choice(conn, max_num):
    cursor = conn.cursor()
    cursor.execute("SELECT id FROM question WHERE type='multiple choice'")
    mpc = cursor.fetchall()

    for question_id in mpc:
        n = random.randint(2, max_num)
        for _ in range(n):
            text = fake.sentence(5)
            cursor.execute("INSERT INTO choice (question_id, text) VALUES (%s, %s)", (question_id, text))
    
    conn.commit()
    cursor.close()

def certificate(conn, num):
    cursor = conn.cursor()
    for i in range(num):
        title = f'Certificate #{i + 1}'
        description = fake.paragraph()
        issued_by = fake.company()
        validity_period_in_year = random.randint(3, 6)
        background_uri = fake.image_url()
        cursor.execute("INSERT INTO certificate (title, description, issued_by, validity_period_in_year, background_uri) VALUES (%s, %s, %s, %s, %s)", (title, description, issued_by, validity_period_in_year, background_uri))
    conn.commit()
    cursor.close()

def service_certificate(conn, max_num):
    cursor = conn.cursor()
    cursor.execute("SELECT id FROM service")
    services = cursor.fetchall()
    cursor.execute("SELECT id FROM certificate")
    certificates = cursor.fetchall()

    for service_id in services:
        chosen_certificates = random.sample(certificates, random.randint(0, max_num))
        for certificate_id in chosen_certificates:
            is_required = random.choice([True, False])
            value = random.randint(1, 5)
            cursor.execute("INSERT INTO service_certificate (service_id, certificate_id, is_required, value) VALUES (%s, %s, %s, %s)", (service_id, certificate_id, is_required, value))
        
    conn.commit()
    cursor.close()

def specialist_service(conn, max_num):
    cursor = conn.cursor()
    cursor.execute("SELECT id, service_category_id FROM specialist")
    specialists = cursor.fetchall()
    
    for specialist_id, category_id in specialists:
        cursor.execute("SELECT id, available_at FROM service WHERE category_id=%s", (category_id,))
        services = cursor.fetchall()
        cursor.execute("SELECT max_price, min_price FROM category WHERE id=%s", (category_id,))
        max_price, min_price = cursor.fetchone()
        chosen = random.sample(services, max_num)
        for service_id, available_at in chosen:
            offered_price = random.uniform(float(min_price), float(max_price))
            availablity = ''
            if available_at == 'both':
                availablity = random.choice(available_place_enum)
            else:
                availablity = available_at

            cursor.execute("INSERT INTO specialist_service (service_id, specialist_id, available_at, offered_price) VALUES (%s, %s, %s, %s)", (service_id, specialist_id, availablity, offered_price))

    conn.commit()
    cursor.close()

def specialist_service_certificate(conn, max_num):
    cursor = conn.cursor()
    cursor.execute("SELECT specialist_id, service_id FROM specialist_service")
    specialist_services = cursor.fetchall()
    cursor.execute("SELECT id FROM certificate")
    certificates = cursor.fetchall()

    for specialist_id, service_id in specialist_services:
        chosen = random.sample(certificates, random.randint(0, max_num))
        for certificate_id in chosen:
            is_certified = random.choice([True, False])
            expires_in = random_date(datetime.now(), datetime.now() + timedelta(days=5 * 365))
            cursor.execute("INSERT INTO specialist_service_certificate (service_id, specialist_id, certificate_id, is_certified, expires_in) VALUES (%s, %s, %s, %s, %s)", (service_id, specialist_id, certificate_id, is_certified, expires_in))

    conn.commit()
    cursor.close()

def customer(conn, num):
    cursor = conn.cursor()
    cursor.execute("SELECT id FROM city")
    cities = cursor.fetchall()
    for _ in range(num):
        sex = random.choice(sex_enum)
        first_name = fake.first_name_male()
        if sex == 'female':
            first_name = fake.first_name_female()

        last_name = fake.last_name()
        phone_number = fake.phone_number()
        password = fake.password()
        city_id = random.choice(cities)
        location = f'({random.uniform(-180, 180)}, {random.uniform(-90, 90)})'
        address = fake.address()
        birthdate = fake.date_this_century()
        image_uri = fake.image_url()
        is_active = random.choices([True, False], weights=[0.95, 0.05], k=1)[0]

        cursor.execute("INSERT INTO customer (first_name, last_name, phone_number, password, city_id, location, address, sex, birthdate, image_uri, is_active) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", (first_name, last_name, phone_number, password, city_id, location, address, sex, birthdate, image_uri, is_active))
    conn.commit()
    cursor.close()

def order(conn):
    cursor = conn.cursor()
    cursor.execute("SELECT id FROM customer LIMIT 250000")
    customers = cursor.fetchall()
    cursor.execute("SELECT id FROM service")
    services = cursor.fetchall()
    for customer_id in customers:
        chosen = random.choices(services, k=random.randint(1, 3))
        for service_id in chosen:
            status = random.choice(status_enum)
            cursor.execute("""INSERT INTO "order" (customer_id, service_id, status) VALUES (%s, %s, %s)""", (customer_id, service_id, status))

    conn.commit()
    cursor.close()

def descriptive_answer(conn):
    cursor = conn.cursor()
    cursor.execute("""SELECT id, service_id FROM "order" """)
    orders = cursor.fetchall()

    for order_id, service_id in orders:
        cursor.execute("SELECT id FROM question WHERE service_id=%s AND type='descriptive'", (service_id,))
        questions = cursor.fetchall()
        for question_id in questions:
            answer = fake.sentence()
            cursor.execute("INSERT INTO descriptive_answer (order_id, question_id, answer) VALUES (%s, %s, %s)", (order_id, question_id, answer))
    
    conn.commit()
    cursor.close()

def numeric_answer(conn):
    cursor = conn.cursor()
    cursor.execute("""SELECT id, service_id FROM "order" """)
    orders = cursor.fetchall()

    for order_id, service_id in orders:
        cursor.execute("SELECT id FROM question WHERE service_id=%s AND type='numeric'", (service_id,))
        questions = cursor.fetchall()
        for question_id in questions:
            answer = random.randint(0, 12)
            cursor.execute("INSERT INTO numeric_answer (order_id, question_id, answer) VALUES (%s, %s, %s)", (order_id, question_id, answer))
    
    conn.commit()
    cursor.close()

def multiple_choice_answer(conn):
    cursor = conn.cursor()
    cursor.execute("""SELECT id, service_id FROM "order" """)
    orders = cursor.fetchall()

    for order_id, service_id in orders:
        cursor.execute("SELECT id FROM question WHERE service_id=%s AND type='multiple choice'", (service_id,))
        questions = cursor.fetchall()
        for question_id in questions:
            cursor.execute("SELECT id FROM choice WHERE question_id=%s", (question_id,))
            choices = cursor.fetchall()
            answer = random.choice(choices)
            cursor.execute("INSERT INTO multiple_choice_answer (order_id, question_id, choice_id) VALUES (%s, %s, %s)", (order_id, question_id, answer))

def offer(conn):
    cursor = conn.cursor()
    cursor.execute("""SELECT "order".id, service_id, city_id FROM "order" JOIN customer ON "order".customer_id=customer.id""")
    orders = cursor.fetchall()
    for order_id, service_id, city_id in orders:
        cursor.execute("SELECT specialist_id, offered_price FROM specialist_service JOIN specialist ON specialist_service.specialist_id=specialist.id WHERE city_id=%s AND service_id=%s", (city_id, service_id))
        specialists = cursor.fetchall()
        chosen = random.sample(specialists, random.randint(0, len(specialists)))
        for specialist_id, offered_price in chosen:
            cursor.execute("INSERT INTO offer (order_id, specialist_id, price, is_accepted_by_specialst) VALUES (%s, %s, %s, TRUE)", (order_id, specialist_id, offered_price))
    
    conn.commit()
    cursor.close()
        
def accept(conn):
    cursor = conn.cursor()
    cursor.execute("""SELECT id FROM "order" WHERE status='in progress' OR status='finished'""")
    orders = cursor.fetchall()
    for order_id in orders:
        cursor.execute('SELECT specialist_id FROM offer WHERE order_id=%s', (order_id,))
        specialists = cursor.fetchall()
        if len(specialists) == 0:
            cursor.execute("""UPDATE "order" SET status='finding specialist' WHERE id=%s""", (order_id,))
        else:
            chosen = random.choice(specialists)
            cursor.execute("""UPDATE "order" SET specialist_id=%s WHERE id=%s""", (chosen, order_id))
    conn.commit()

def rating(conn):
    cursor = conn.cursor()
    cursor.execute("""SELECT id, specialist_id FROM "order" WHERE status='finished'""")
    orders = cursor.fetchall()
    for order_id, specialist_id in orders:
        rating = random.randint(1,5)
        comment = fake.paragraph()
        cursor.execute("INSERT INTO rating(order_id, specialist_id, rating, comment) VALUES (%s, %s, %s, %s)", (order_id, specialist_id, rating, comment))

    conn.commit()
    cursor.close()


def main():
    conn = psycopg2.connect(**db_config)
    # province(conn, 30)
    # city(conn, 250)
    # category(conn, 10)
    # subcategory(conn, 100)
    # service(conn, 500)
    # specialist(conn, 30000)
    # question(conn, 7)
    # choice(conn, 5)
    # certificate(conn, 80)
    # specialist_service(conn, 4)
    # specialist_service_certificate(conn, 3)
    # customer(conn, 500000)
    # order(conn)
    # descriptive_answer(conn)
    # numeric_answer(conn)
    # multiple_choice_answer(conn)
    # offer(conn)
    # accept(conn)
    rating(conn)


if __name__ == "__main__":
    main()