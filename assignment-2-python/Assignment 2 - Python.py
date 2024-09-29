# HELLO, WELCOME TO ANIME MASTER.
# THIS IS AN INTERACTIVE GAME, WHERE WE WILL TEST YOUR KNOWLEDGE OF TRENDING ANIME
# THE RULES:
        # THE AIM OF THIS GAME IS TO CORRECTLY GUESS AN ANIME THAT IS IN THE TOP TEN ON
        # YOU WILL HAVE FIVE GUESSES - How merciful of me right?!
        # IF YOU GUESS INCORRECTLY THREE TIMES, YOU WILL BE GIVEN THE OPTION TO GET A HINT ON YOUR 4TH & 5TH GUESSES
        # THE HINTS WILL BE THE SAME, BUT ONLY ONE OPTION IS CORRECT. CHOOSE MINDFULLY.
        # PRESS RUN FILE WHEN YOU ARE RADY TO START :)

# 1ST SECTION: API & JSON DATA, INBUILT FUNCTIONS, ADDITIONAL MODULES, LISTS AND DICTIONARIES.

# IMPORTING MODULES REQUESTS(FOR API GET REQUESTS) AND CSV(FOR WRITING, READING AND APPENDING FILES)
# For this progmam we will use a package called requests. Please type the following "pip install requests" (without the quotation marks)  directly into your terminal to initiate the installation.
from csv import DictWriter
import requests
import csv

#STARTING THE PROGRAM WITH A USER INPUT
user_input_a = input('Guess an Anime that is in the top 10. HINT: You can specify seasons :)')

# SETTING AND MODIFYING THE API KEYS FOR A GET REQUEST
url = 'https://api.jikan.moe/v4/anime?q='
user_input_modification = '&sfw'  #Adding the required url extension that makes the user_input viable
anime = '{}{}{}'.format(url, user_input_a, user_input_modification)
response = requests.get(anime)
data = response.json()

# SETTING VARIABLES TO SPECIFIC DATA IN THE JSON DICTIONARY. I HAVE USED LIST INDEXING FOR THIS
TITLE = data['data'][0]['title_english']
URL = data['data'][0]['url']
RANK = data['data'][0]['rank']
SCORE = data['data'][0]['score']
FAVOURITES = data['data'][0]['favorites']

# I WILL OPEN AND WRITE INTO A NEW CSV FILE.
# THE PURPOSE OF THIS IS TO SAVE DOWN THE RELEVANT DATA FOR ALL ANIME GUESSES THE USER MAKES.

header_list = ['TITLE', 'URL', 'RANK', 'SCORE', 'FAVOURITES'] # WRITING A LIST FOR MY COLUMN NAMES
anime_data_loop = [
    {'TITLE': TITLE, 'URL': URL, 'RANK': RANK, 'SCORE': SCORE, 'FAVOURITES': FAVOURITES},
]  # A DICTIONARY FOR MY CSV ROWS

with open('anime_list_csv', 'w+') as file: # INITIATING A NEW FILE THAT SAVES THE DETAILS OF THE FIRST GUESS
    writer = csv.DictWriter(file, fieldnames=header_list)
    writer.writeheader()
    writer.writerows(anime_data_loop)
msg = f'your anime{user_input_a}, is ranked number {RANK} on https://myanimelist.net/topanime.php. You are one of the {FAVOURITES} people who have this as their favourite  anime!'



# 2ND SECTION: FOR LOOPS, WHILE LOOPS, IF STATEMENTS, FUNCTIONS WITH RETURNS,  & FILE APPENDING

if RANK in range(1,11): # IF THE USER WAS ABLE TO ACCURATELY GUESS (FIRST TIME!), THE  GAME ENDS AND THE FILE WILL ONLY CONTAIN THEIR FIRST GUESS.
    print('Congratulations! Your anime is in the top 10!')
    print(f'You won with 1 guess! You can view more details of {TITLE} in the file anime_list_csv')
else:   # INITIATING ELSE CONDITION IF THEY DIDN'T GUESS CORRECTLY.
    print('Sorry, you have not guessed correctly!')
    guesses = [4,3,2,1]
    for guess in guesses:
        def hint_question():
            answer1 = input('would you like a hint')
            answer = str(answer1.lower())  # MAKING THE INPUT ALL LOWERCASE
            if answer == ' yes' or answer == 'yes':
                print('Cowboy Bebop, Naruto, Mushishi, Vinland Saga, Steins Gate')
                return True
            elif answer == ' no' or answer == 'no':
                print('Okay, you may proceed')
                return False
            else:
                print('Please enter yes or no')  # an answer that wouldn't be yes of no
                hint_question()

        while guess in guesses[2:]:
            print(f'WARNING: You  have {guess} guesses remaining!')
            hint_question()
            break
        user_input_a = input(f'You have {guess} more guesses. Give me a top 10 Anime')
        url = 'https://api.jikan.moe/v4/anime?q='
        user_input_modification = '&sfw'  # Adding the required url extension that makes the user_input viable
        anime = '{}{}{}'.format(url, user_input_a, user_input_modification)
        response = requests.get(anime)
        data = response.json()
        TITLE = data['data'][0]['title_english']  # setting variables to items in my data dictionary which is contained in a list, hence the integer indexing
        URL = data['data'][0]['url']
        RANK = data['data'][0]['rank']
        SCORE = data['data'][0]['score']
        FAVOURITES = data['data'][0]['favorites']

    ##
        header_list = ['TITLE', 'URL', 'RANK', 'SCORE', 'FAVOURITES']
        anime_data_loop = [
            {'TITLE': TITLE, 'URL': URL, 'RANK': RANK, 'SCORE': SCORE, 'FAVOURITES': FAVOURITES},
        ]  # Here I am initiating the data that will go into the csv file
        with open('anime_list_csv', 'a') as file_object:
            writer = DictWriter(file_object, fieldnames=header_list)
            writer.writerows(anime_data_loop) # appending details of the new guesses to te csv

        if RANK in range(1,11):
            print('Congratulations! Your anime is in the top 10!')
            print(f'You can view more details of {TITLE} in the file anime_list_csv')
            break #ENDS THE LOOP ONCE THE PLAYER HAS GUESSED CORRECTLY

        else:
            print('Sorry, you have not guessed correctly!')
    print('You have now reached the end of this game :) ')
    print('You may view the details - including links- to all Anime you guessed in anime_list_csv.csv')
    print('Thank you for playing. ')





