import firebase_admin
from firebase_admin import credentials, firestore

import requests
from bs4 import BeautifulSoup

cred = credentials.Certificate("./serviceAccountKey.json")
firebase_admin.initialize_app(cred)

db = firestore.client()



# def scrapePokemonStats(siteURL):
#     response = requests.get(url)
#     html = response.content

#     soup = BeautifulSoup(html)
#     table = soup.find('tbody', attrs={'class': 'stripe'})

#     list_of_rows = []
#     for row in table.findAll('tr'):
#         list_of_cells = []
#         for cell in row.findAll('td'):
#             text = cell.text.replace('&nbsp;', '')
#             list_of_cells.append(text)
#         list_of_rows.append(list_of_cells)

#     print list_of_rows