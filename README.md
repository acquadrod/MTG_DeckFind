# MTG_DeckFind

This powershell script check your MTG card inventory and calculates the percetage of matching with decks saved in a folder.

## parameters

param(
    [Parameter()]
    [String]$inventoryPath="all-folders.csv",
    [String]$deckPath="decks\"
)