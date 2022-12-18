# MTG_DeckFind

Requirements:
- powershell (even on Mac and Linux)
- MTG dragon shield card scanner CSV inventory. Scan your cards and then export all your inventory.

### checkInventory
This powershell script check your MTG card inventory and calculates the percetage of matching with decks saved in a folder.

### getCustomDecksMTGgoldfish
The script downloads user custom decks from MTGGoldfish site and save it. it is a bit tricky. Check the for loop to download multiple pages. Change $type variable to get different formats

### getMetaDecksMTGgoldfish
The script downloads user Metagame decks from MTGGoldfish site and save it. it is a bit tricky. Check the for loop to download multiple pages. Change $type variable to get different metagame formats

### getMTGJsonDecks
Generates txt deck files from MTGJSON allDeckFiles.zip. https://mtgjson.com/api/v5/AllDeckFiles.zip 

### getTappedOutDecks
The script downloads deck txt files from Tappedout site. the site blocks massive downloads. use carefully.

## checkInventory.ps1 parameters
Usually shows deck in compact format (dect file path and match percentage).

**- inventoryPath filepath**: path to MTG dragon shield card scanner CSV. (default: all-folders.csv) <br>
**- deckPath path**: path to a folder containing decks' card lists in .txt format like this <br>
    `4 Burning-Tree Emissary` <br>`4 Castle Embereth` <br> `4 Dragon Fodder` <br> 
**- showDetail n**: show top n in JSON format <br>
**- top n**: show top n results in compact mode <br>

***HINTS*** 
- to export missing cards in text format for card market site type this command line <br>
    `./checkInventory.ps1  -showDetail 1|ConvertFrom-Json|Select-Object notFound|Foreach-object {foreach ($c in $_.notFound) {write-host $c.quantity $c.name}}`
- the *deckPath* can point even to a single deck txt file <br>

    
## getDecksMTGgoldfish.ps1
No line parameters, check the first lines of the code.


## License
### Attribution-NonCommmercial-ShareAlike 4.0 International 
[![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC_BY--NC--SA_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-sa/4.0/)<br>
All trademarks are property of their owners <br>
This is a completely indipendent project unlinked to Dragonshield, TappedOut.net, MTGGoldfish site
