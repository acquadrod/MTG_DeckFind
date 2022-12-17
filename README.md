# MTG_DeckFind

### checkInventory
This powershell script check your MTG card inventory and calculates the percetage of matching with decks saved in a folder.

### getDecksMTGgoldfish
The script downloads user custom decks from MTGGoldfish site and save it. it is a bit tricky. It gets only one page. for other pages you need to edit *$urlo* variable.

## checkInventory.ps1 parameters
Usually shows deck in compact format (dect file path and match percentage).

**inventoryPath <filepath>**: path to MTG dragon shield card scanner CSV. (default: all-folders.csv) <br>
**deckPath <path>**: path to a folder containing decks' card lists in .txt format like this <br>
    `4 Burning-Tree Emissary` <br>`4 Castle Embereth` <br> `4 Dragon Fodder` <br>
    the path can point even to a single deck txt file
**showDeatil n**: show top n in JSON format <br>
**top n**: show top n results in compact mode

***HINT*** to export missing cards in text format for card market site type this command line
    `./checkInventory.ps1  -showDetail 1|ConvertFrom-Json|Select-Object notFound|Foreach-object {foreach ($c in $_.notFound) {write-host $c.quantity $c.name}}`

    
## getDecksMTGgoldfish.ps1
No line parameters, check the first lines of the code.


## License
### Attribution-NonCommmercial-ShareAlike 4.0 International 
[![License: CC BY-NC-SA 4.0](https://img.shields.io/badge/License-CC_BY--NC--SA_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-sa/4.0/)
