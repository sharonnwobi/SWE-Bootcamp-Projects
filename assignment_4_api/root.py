#from operator import index
#THIS FILE IS FOR HANDLING THE ROOT

from flask import Flask, jsonify, request
from utils import get_all_shows, get_shows_by_date, booking_shows



# GETTING INFORMATION - BOILERPLATE CODE
app = Flask(__name__)

# SETTING MY FIRST END POINT - this allows you to see all show listings using a GET method
@app.route('/shows', methods=['GET'])
def shows():
    data = get_all_shows() #HERE I AM CALLING THE FUNCTION FROM MY UTILS SCRIPT
    return jsonify(data)

# SETTING MY 2ND ENDPOINT - This allows you to search for shows available on a certain date using a GET method

@app.route('/shows/<date>', methods=["GET"])
def shows_by_date(date):
    data = get_shows_by_date(date)  #HERE I AM CALLING THE FUNCTION FROM MY UTILS SCRIPT
    return jsonify(data)

#ALTERING MY 2ND END POINT, POST REQUEST - This allows us to add a show onto the website
@app.route('/shows', methods=['POST'])
def add_show():
    new_show = request.get_json()
    shows.append(new_show)
    return jsonify(new_show)

# MY 3RD ENDPOINT (PUT REQUEST) - This allows you to book a ticket for a show using a PUT method
@app.route('/booking', methods = ['PUT'])
def book_show():
    booking = request.get_json()
    booking_shows(
        show_name = booking['show_name'],
        seating_tickets=booking['seating_tickets'],
        standing_tickets=booking['standing_tickets'],
        full_name = booking['full_name'],
        email_address = booking['email_address'],
        booking_date = booking['booking_date']
    )
    return booking



if __name__ == '__main__':
    app.run(debug=True, port=5000)
