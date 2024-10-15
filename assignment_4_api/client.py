#THIS SCRIPT IS THE CLIENT/MAIN SIDE.
import json
import requests


def get_all_shows_client():
    result = requests.get('http://127.0.0.1:5000/shows', headers={'content-type':'application/json'})
    return result.json()

def get_shows_by_date_client(date):
    result = requests.get(f'http://127.0.0.1:5000/shows/{date}', headers={'content-type': 'application/json'})
    return result.json()


###
def book_show(show_name, standing_tickets, seating_tickets, full_name, email_address, booking_date):
    booking = {'show_name': show_name,
               'standing_tickets': standing_tickets,
               'seating_tickets': seating_tickets,
               'full_name': full_name,
               'email_address': email_address,
               'booking_date': booking_date
               }
    result = requests.put('http://127.0.0.1:5000/booking', headers={'Content-Type': 'application/json'},
                          data=json.dumps(booking))
    return result.json

def run():
    print('Hello, Welcome to Theatre Royal! We specialise in Shakespeare')
    user_input = input('Would you like to see all available shows? Yes or No').strip()
    if user_input.lower() == 'yes':
        listings = get_all_shows_client()
        print(listings)
    else:
        user_input = input('Would you like to listings by date? Yes or No').strip()
        if user_input.lower() == 'yes':
            requested_date = input('Please confirm your date (YYYY-MM-DD): ').strip()
            listings = get_shows_by_date_client(requested_date)
            print(listings)
        elif user_input.lower() == 'no':
            return None
        else:
            print('Sorry, you did not enter a valid date.')

    user_input_ii = input('Would you like to book a show? Yes or No').strip()
    book = user_input_ii.lower() == 'yes'
    if book:

        # GETTING DETAILS FOR THE BOOKING
        show = input("What show would you like to book?: ").upper()
        name = input("Please type full name?: ").lower()
        email = input("Please type your email address?: ").lower()
        try:
            no_of_standing_tickets = int(input("How many seating tickets do you want? if none enter 0: "))
            no_of_seating_tickets = int(input("How many standing tickets do you want? if none enter 0: "))
            assert no_of_standing_tickets >= 0 and no_of_seating_tickets >= 0

# ROUGH WORK: IN THIS AREA I WAS TRYING TO ADD A CHECK TO ENSURE THERE WERE ENOUGH TICKETS AVAILABLE TO BOOK:
# DIDNT QUITE SUCCEED, BUT I WOULD LOVE SOME FEED BACK IF POSSIBLE PLEASE.
            #listings = get_all_shows()
            #for row in listings:
                #if row['show_name'] == show and row['standing_tickets'] < no_of_standing_tickets:
                   #print(f"sorry there are {no_of_standing_tickets} standing tickets left")
                #else:
                    #continue
                #if row['show_name'] ==show and row['standing_tickets'] < no_of_seating_tickets:
                    #print(f"there are {no_of_seating_tickets} seating tickets left")
                #else:
                    #continue


        except AssertionError:
            print('Sorry, you did not enter a number.')
        else:
            date = input("Please confirm your booking date (YYYY-MM-DD): ").strip()
            book_show(show_name=show,
                      standing_tickets= no_of_standing_tickets,
                      seating_tickets = no_of_seating_tickets,
                      full_name=name,
                      email_address = email,
                      booking_date=date)
            print('Your booking has been successful. See you soon!')
        finally:
            print()


if __name__ == '__main__':
    run()