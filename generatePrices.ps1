$cardsPath = "MTGJSON\cards.csv"

$cards=@()
Import-Csv $cardsPath | ForEach-Object {
    $cards+=@($_.name,$_.identifiers.mtgjsonV4Id)
}

$cards|Export-Csv -path "cardid.csv"