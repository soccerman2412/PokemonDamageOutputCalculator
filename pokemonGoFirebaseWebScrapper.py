import firebase_admin
from firebase_admin import credentials, firestore, storage

import requests
from bs4 import BeautifulSoup

cred = credentials.Certificate("./serviceAccountKey.json")
firebase_admin.initialize_app(cred, {
    'storageBucket': 'pokemongodamagecalculator.appspot.com'
})

db = firestore.client()
fb_storage_bucket = storage.bucket()


# how to use:
# 1) open terminal and cd to the dir of the script
# 2) type 'python3 pokemonGoFirebaseWebScrapper.py' or whatever you python instance is (although this requires python 3 or later)
# 3) enter to run

#scrapePokemonSite(siteURL = "https://thesilphroad.com/species-stats")
#scrapePokemonMoveSite(siteURL = "https://pokeassistant.com/main/movelist?locale=en#mid444")
#scrapePokemonSiteForImages(siteURL = "https://thesilphroad.com/species-stats")



# ----- UPDATE/CREATE SPECIFIC POKEMON -----
def update(pokemonName, pokemonNumber):
    scrapePokemonSite(siteURL = "https://thesilphroad.com/species-stats", pokemonName=pokemonName)
    addImageForPokemonInfo(pNameStr=pokemonName, pNumStr=pokemonNumber)
    print("done")

# ----- UPDATE/CREATE ALL -----

def updateAll():
    scrapePokemonSite(siteURL = "https://thesilphroad.com/species-stats")
    scrapePokemonMoveSite(siteURL = "https://pokeassistant.com/main/movelist?locale=en#mid444")
    scrapePokemonSiteForImages(siteURL = "https://thesilphroad.com/species-stats")




# ----- SCRAPE POKEMON METHODS -----

def scrapePokemonSite(siteURL, pokemonName=None):
    response = requests.get(siteURL)
    html = response.content

    html_soup = BeautifulSoup(html, "html.parser")
    for div in html_soup.select('div[class*="speciesWrap"]'):
    #for div in html_soup.select('div'):
        # if div.has_attr('class'):
        #     print(div['class'])

        if (bool(pokemonName) and div.find(name='h1', string=pokemonName)):
            findPokemonDiv(div, ignoreCP=True)
            return
        elif (bool(pokemonName) == False):
            findPokemonDiv(div)

            # - Mew
            if div.find(name='h1', string='Mew'):
                mew = scrapePokemonStats(div = div, classNamesArr = ['speciesWrap', 'col-md-2', 'col-xs-6', 'col-sm-4', 'legendary', 'unreleased'], ignoreCP=True)
                if bool(mew):
                    print("mew")
                    mew['generation'] = 1
                    mew['legendary'] = True
                    addPokemonToFirebase(mew)
        

def findPokemonDiv(div, ignoreCP=False):
    #print(div)

    # gen 1
    # - NOT legendary
    gen1Pokemon = scrapePokemonStats(div = div, classNamesArr = ['speciesWrap', 'col-md-2', 'col-xs-6', 'col-sm-4', ''], ignoreCP=ignoreCP)
    if bool(gen1Pokemon):
        gen1Pokemon['generation'] = 1
        gen1Pokemon['legendary'] = False
        addPokemonToFirebase(gen1Pokemon)
    # - legendary
    legendaryGen1Pokemon = scrapePokemonStats(div = div, classNamesArr = ['speciesWrap', 'col-md-2', 'col-xs-6', 'col-sm-4', 'legendary', ''], ignoreCP=ignoreCP)
    if bool(legendaryGen1Pokemon):
        legendaryGen1Pokemon['generation'] = 1
        legendaryGen1Pokemon['legendary'] = True
        addPokemonToFirebase(legendaryGen1Pokemon)

    # gen 2
    # - NOT legendary
    gen2Pokemon = scrapePokemonStats(div = div, classNamesArr = ['speciesWrap', 'col-md-2', 'col-xs-6', 'col-sm-4', 'gen2', ''], ignoreCP=ignoreCP)
    if bool(gen2Pokemon):
        gen2Pokemon['generation'] = 2
        gen2Pokemon['legendary'] = False
        addPokemonToFirebase(gen2Pokemon)
    # - legendary
    legendaryGen2Pokemon = scrapePokemonStats(div = div, classNamesArr = ['speciesWrap', 'col-md-2', 'col-xs-6', 'col-sm-4', 'gen2', 'legendary', ''], ignoreCP=ignoreCP)
    if bool(legendaryGen2Pokemon):
        legendaryGen2Pokemon['generation'] = 2
        legendaryGen2Pokemon['legendary'] = True
        addPokemonToFirebase(legendaryGen2Pokemon)

    # gen 3
    # - NOT legendary
    gen3Pokemon = scrapePokemonStats(div = div, classNamesArr = ['speciesWrap', 'col-md-2', 'col-xs-6', 'col-sm-4', 'gen3', ''], ignoreCP=ignoreCP)
    if bool(gen3Pokemon):
        gen3Pokemon['generation'] = 3
        gen3Pokemon['legendary'] = False
        addPokemonToFirebase(gen3Pokemon)
    # - legendary
    legendaryGen3Pokemon = scrapePokemonStats(div = div, classNamesArr = ['speciesWrap', 'col-md-2', 'col-xs-6', 'col-sm-4', 'gen3', 'legendary', ''], ignoreCP=ignoreCP)
    if bool(legendaryGen3Pokemon):
        legendaryGen3Pokemon['generation'] = 3
        legendaryGen3Pokemon['legendary'] = True
        addPokemonToFirebase(legendaryGen3Pokemon)
        


def addPokemonToFirebase(pokemon):
    doc_ref = db.collection('scrapedPokemon').document(pokemon['name'])
    #doc_ref = db.collection('testPokemon').document(pokemon['name'])
    #TODO: figure out how to merge
    doc_ref.set(pokemon)
    # print(pokemon)
    # print("\n")



def scrapePokemonStats(div, classNamesArr, ignoreCP=False):
    pokemon = {}

    if div.has_attr('class') and div['class'] == classNamesArr:
        if (ignoreCP == False and int(div['data-max-cp']) < 1920):
            return

        pNameStr = ''
        for h1 in div.select('h1'):
            pNameStr = h1.string
            #print("name: " + pNameStr)
            pokemon['name'] = pNameStr
        pNumStr = div['data-species-num']
        #print("pokemonNumber: " + pNumStr)
        pokemon['pokemonNumber'] = int(pNumStr)
        #print("attack: " + div['data-base-attack'])
        pokemon['attack'] = int(div['data-base-attack'])
        # defense requires more work; div['data-base-defense'] was incorrect value
        for defenseDiv in div.find_all(name='div', string='Defense'):
            for span in defenseDiv.parent.select('span'):
                #print("defense: " + span.string)
                pokemon['defense'] = int(span.string)
        #print("stamina: " + div['data-base-stamina'])
        pokemon['stamina'] = int(div['data-base-stamina'])
        types = []
        for typesDiv in div.select('div.monTypes.row-fluid'):
            for currType in typesDiv.select('div'):
                types.append(currType.string)
        # print("type(s): ", end='')
        # print(*types, sep = ", ")
        pokemon['types'] = types
        #print("imageUrl: " + pNameStr.lower() + ".png")
        pokemon['imageUrl'] = pNameStr.lower() + ".png"
        scrapePokemonMoves(siteURL = "https://pokeassistant.com/pokedex/" + pNumStr + "?locale=en", pokemon = pokemon)
        
    return pokemon



def scrapePokemonMoves(siteURL, pokemon):
    #print(siteURL)
    response = requests.get(siteURL)
    html = response.content

    html_soup = BeautifulSoup(html, "html.parser")

    fast_moves = []
    charge_moves = []
    for div in html_soup.select('div.row.movesets'):
        for fMovesDiv in div.select('div.col-xs-12.col-md-6'):
            for currStr in fMovesDiv.stripped_strings:
                # print("fMovesDiv.strings: " + currStr)
                if (currStr == 'Fast Moves'):
                    fast_moves = populateMoves(div = fMovesDiv)
                elif (currStr == 'Charge Moves'):
                    charge_moves = populateMoves(div = fMovesDiv)

    # print("fastMoves: ", end='')
    # print(*fast_moves, sep = " | ")
    pokemon['fastMoves'] = fast_moves

    # print("chargeMoves: ", end='')
    # print(*charge_moves, sep = " | ")
    pokemon['chargeMoves'] = charge_moves



def populateMoves(div):
    moves = []
    # find all active moves
    for subDiv in div.select('div[class*="remfalse"]'):
        for currStr in subDiv.stripped_strings:
            if currStr.replace('.','',1).isdigit() == False:
                #print("remfalse" + currStr)
                moves.append({'name': currStr.replace(" ", ""), 'active': True})
    
    # find all inactive moves
    for subDiv in div.select('div[class*="remtrue"]'):
        for currStr in subDiv.stripped_strings:
            if currStr.replace('.','',1).isdigit() == False:
                #print("remtrue" + currStr)
                moves.append({'name': currStr.replace(" ", ""), 'active': False})
    return moves



# ----- SCRAPE POKEMON MOVES METHODS -----

def scrapePokemonMoveSite(siteURL):
    response = requests.get(siteURL)
    html = response.content

    html_soup = BeautifulSoup(html, "html.parser")
    chargeMoves = False
    for tr in html_soup.select('tr'):
        if len(tr.contents) >= 4 and tr.contents[3].string == 'Charge Moves':
            #print("found Charge Moves")
            chargeMoves = True
            
        if tr.has_attr('class') and tr['class'] == ['onclick']:
            #print("----------\n\n")
            if chargeMoves == False:
                move = {}
                i = 0
                for currStr in tr.stripped_strings:
                    if i == 0:
                        move['type'] = determinMoveType(typeAbrevStr = currStr)
                    elif i == 1:
                        move['name'] = currStr
                    elif i == 3:
                        move['damage'] = int(currStr)
                    elif i == 4:
                        move['energyGain'] = int(currStr)
                    elif i == 5:
                        move['duration'] = float(currStr)
                    i += 1
                # print("fastMove: ", end='')
                # print(move)
                doc_ref = db.collection('scrapedFastMoves').document(move['name'].replace(" ", ""))
                doc_ref.set(move)
            else:
                move = {}
                i = 0
                for currStr in tr.stripped_strings:
                    if i == 0:
                        move['type'] = determinMoveType(typeAbrevStr = currStr)
                    elif i == 1:
                        move['name'] = currStr
                    elif i == 4:
                        move['damage'] = int(currStr)
                    elif i == 5:
                        move['energyCost'] = abs(int(currStr))
                    elif i == 6:
                        move['duration'] = float(currStr)
                    i += 1
                # print("chargeMove: ", end='')
                # print(move)
                doc_ref = db.collection('scrapedChargeMoves').document(move['name'].replace(" ", ""))
                doc_ref.set(move)

def determinMoveType(typeAbrevStr):
    mapping = {
        'nor': 'normal',
        'fig': 'fighting',
        'fly': 'flying',
        'poi': 'poison',
        'gro': 'ground',
        'roc': 'rock',
        'bug': 'bug',
        'gho': 'ghost',
        'ste': 'steel',
        'fir': 'fire',
        'wat': 'water',
        'gra': 'grass',
        'ele': 'electric',
        'psy': 'psychic',
        'ice': 'ice',
        'dra': 'dragon',
        'dar': 'dark',
        'fai': 'fairy'
    }
    return mapping.get(typeAbrevStr.lower(), "none")




# ----- SCRAPE POKEMON IMAGES METHODS -----

def scrapePokemonSiteForImages(siteURL):
    response = requests.get(siteURL)
    html = response.content

    html_soup = BeautifulSoup(html, "html.parser")
    for div in html_soup.select('div[class*="speciesWrap"]'):
        pNameStr = ''
        for h1 in div.select('h1'):
            pNameStr = h1.string
            #print("name: " + pNameStr)
        pNumStr = div['data-species-num']
        #print("num: " + pNumStr)
        addImageForPokemonInfo(pNameStr = pNameStr, pNumStr = pNumStr)
    
    print("done")
        
def addImageForPokemonInfo(pNameStr, pNumStr):
    url = "http://static.pokemonpets.com/images/monsters-images-800-800/" + pNumStr + "-" + pNameStr + ".png"
    response = requests.get(url)
    blob = fb_storage_bucket.blob(pNameStr.lower()+".png")
    blob.upload_from_string(response.content, content_type='image/png')
