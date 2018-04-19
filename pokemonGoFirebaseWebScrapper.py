import firebase_admin
from firebase_admin import credentials, firestore

import requests
from bs4 import BeautifulSoup

cred = credentials.Certificate("./serviceAccountKey.json")
firebase_admin.initialize_app(cred)

db = firestore.client()



def scrapePokemonSite(siteURL):
    response = requests.get(siteURL)
    html = response.content

    html_soup = BeautifulSoup(html, "html.parser")
    for div in html_soup.select('div'):
        # if div.has_attr('class'):
        #     print(div['class'])

        # gen 1
        # - NOT legendary
        if scrapePokemonStats(div = div, classNamesArr = ['speciesWrap', 'col-md-2', 'col-xs-6', 'col-sm-4', '']):
            print("generation: 1")
            print("legendary: false")
            print("\n")
        # - legendary
        if scrapePokemonStats(div = div, classNamesArr = ['speciesWrap', 'col-md-2', 'col-xs-6', 'col-sm-4', 'legendary', '']):
            print("generation: 1")
            print("legendary: true")
            print("\n")

        # gen 2
        # - NOT legendary
        if scrapePokemonStats(div = div, classNamesArr = ['speciesWrap', 'col-md-2', 'col-xs-6', 'col-sm-4', 'gen2', '']):
            print("generation: 2")
            print("legendary: false")
            print("\n")
        # - legendary
        if scrapePokemonStats(div = div, classNamesArr = ['speciesWrap', 'col-md-2', 'col-xs-6', 'col-sm-4', 'gen2', 'legendary', '']):
            print("generation: 2")
            print("legendary: true")
            print("\n")

        # gen 3
        # - NOT legendary
        if scrapePokemonStats(div = div, classNamesArr = ['speciesWrap', 'col-md-2', 'col-xs-6', 'col-sm-4', 'gen3', '']):
            print("generation: 3")
            print("legendary: false")
            print("\n")
        # - legendary
        if scrapePokemonStats(div = div, classNamesArr = ['speciesWrap', 'col-md-2', 'col-xs-6', 'col-sm-4', 'gen3', 'legendary', '']):
            print("generation: 3")
            print("legendary: true")
            print("\n")
        

def scrapePokemonStats(div, classNamesArr):
    if div.has_attr('class') and div['class'] == classNamesArr and int(div['data-max-cp']) >= 1920:
        pNameStr = ''
        for h1 in div.select('h1'):
            pNameStr = h1.string
            print("name: " + pNameStr)
        pNumStr = div['data-species-num']
        print("pokemonNumber: " + pNumStr)
        print("attack: " + div['data-base-attack'])
        # defense requires more work; div['data-base-defense'] was incorrect value
        for defenseDiv in div.find_all(name='div', string='Defense'):
            for span in defenseDiv.parent.select('span'):
                print("defense: " + span.string)
        print("stamina: " + div['data-base-stamina'])
        types = []
        for typesDiv in div.select('div.monTypes.row-fluid'):
            for currType in typesDiv.select('div'):
                types.append(currType.string)
        print("type(s): ", end='')
        print(*types, sep = ", ")
        print("imageUrl: " + pNameStr.lower() + ".png")
        scrapePokemonMoves(siteURL="https://pokeassistant.com/pokedex/" + pNumStr + "?locale=en")
        return True
    return False



def scrapePokemonMoves(siteURL):
    #print(siteURL)
    response = requests.get(siteURL)
    html = response.content

    html_soup = BeautifulSoup(html, "html.parser")

    fast_moves = []
    for div in html_soup.select_one('div.row.movesets'):
        #find_all(name='div', string="Fast Moves"):
        print("TEST")
        # if div.has_attr('class') and div['class'] == ['col-xs-12', 'Type12', 'dextypespan', 'typespan', 'remfalse', 'movehover']:
        #     fast_moves.append((div.string, 'true'))
        # elif div.has_attr('class') and div['class'] == ['col-xs-12', 'Type12', 'dextypespan', 'typespan', 'remtrue', 'movehover']:
        #     fast_moves.append((div.string, 'false'))
    print("fastMoves: ", end='')
    print(*fast_moves, sep = " | ")

    charge_moves = []
    for div in html_soup.find_all(name='div', string='Charge Moves'):
        if div.has_attr('class') and div['class'] == ['col-xs-12', 'Type12', 'dextypespan', 'typespan', 'remfalse', 'movehover']:
            charge_moves.append((div.string, 'true'))
        elif div.has_attr('class') and div['class'] == ['col-xs-12', 'Type12', 'dextypespan', 'typespan', 'remtrue', 'movehover']:
            charge_moves.append((div.string, 'false'))
    print("chargeMoves: ", end='')
    print(*charge_moves, sep = " | ")



#moves https://pokeassistant.com/pokedex/3?locale=en => swap pokemon number
#images http://www.pokemonpets.com/MonsterArtwork.aspx?MonsterName=latios => swap name



scrapePokemonSite(siteURL = "https://thesilphroad.com/species-stats")