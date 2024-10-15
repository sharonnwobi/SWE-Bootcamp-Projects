## THIS IS WHERE I WILL WRITE ALL FUNCTIONS TO FETCH DATA FROM MY SQL
## THIS FILE WILL LINK PYTHON TO A DB IN SQL

# Importing specific functions from specific files
import mysql.connector
from config1 import USER, PASSWORD, HOST
from prettytable import PrettyTable



# HELPER FUNCTION?
def _connect_to_db(db_name):   #the underscore is a key that says this is a private function, i.e. it is only for use in theis script only
    cnx = mysql.connector.connect(
        host=HOST,
        user = USER,
        password = PASSWORD,
        auth_plugin = 'mysql_native_password',
        database = db_name
    )
    return cnx

# 1ST FUNCTION
def get_all_shows():
    try:
        db_name = 'theatre'
        db_connection = _connect_to_db(db_name)
        cur = db_connection.cursor()
        print(f'Connected to {db_name}')
    #QUERYING THE DATABASE TO SEE ALL SHOWS BEING ADVERTISED
        query = """SELECT * FROM plays"""
        cur.execute(query)
        result = cur.fetchall()
        return result

        cur.close()
    except Exception:
        raise ConnectionError('Failed to read from the database')
    finally:
        if db_connection:
            db_connection.close()
            print('Database connection closed')


#2ND FUNCTION

def get_shows_by_date(date):
    try:
        db_name = 'theatre'
        db_connection = _connect_to_db(db_name)
        cur = db_connection.cursor()
        print(f"Connected to DB: {db_name}")
        #date = input('Enter a date (YYYY-MM-DD):').strip()  # Here i have used the strip() function to remove any spaces in the input
        query = f""" SELECT * FROM plays WHERE show_date = '{date}'"""
        cur.execute(query)
        result = cur.fetchall()
        return result

        cur.close()
    except Exception:
        raise ConnectionError("Failed to read data from DB")
    finally:
        if db_connection:
            db_connection.close()
            print("DB connection is closed")


#3RD FUNCTION: THIS IS FOR ADDING A SHOW TO THE WEBSITE - DATA GOES INTO THE PLAYS TABLE ON MYSQL DATABASE

def add_a_show(show_name, genre, show_date, standing_tickets, standing_price, seating_tickets, seating_price, audio_description):
    try:
        db_name = 'theatre'
        db_connection = _connect_to_db(db_name)
        cur = db_connection.cursor()
        print(f"Connected to DB: {db_name}")

        query = (f"""CALL plays_sproc('{show_name}', '{genre}', {show_date}, {standing_tickets}, {standing_price}, {seating_tickets}, {seating_price}, {audio_description})""")
        cur.execute(query)
        db_connection.commit()
        cur.close()
    except Exception:
        raise ConnectionError("Failed to read data from DB")
    finally:
        if db_connection:
            db_connection.close()
            print("DB connection is closed")

#4TH FUNCTION - THIS IS FOR ADDING A BOOKING ORDER - THE DATA GOES INTO THE BOOKINGS TABLE ON SQL DATABASE

def booking_shows(show_name, standing_tickets, seating_tickets, full_name, email_address, booking_date):
    try:
        db_name = 'theatre'
        db_connection = _connect_to_db(db_name)
        cur = db_connection.cursor()
        print(f"Connected to DB: {db_name}")
        query = (f"""CALL bookings_sproc ('{show_name}', {seating_tickets}, {standing_tickets}, '{full_name}', '{email_address}', '{booking_date}') """)
        cur.execute(query)
        db_connection.commit()
        cur.close()

    except Exception:
        raise ConnectionError("Failed to read data from DB")
    finally:
        if db_connection:
            db_connection.close()
        print("DB connection is closed")

