#  to get deck:https://tappedout.net/mtg-decks/songs-of-the-damned-bgr/?fmt=txt
# filter urls /mtg-decks/(solving-tron)/

#download deck from tappedout homepage pauper
#
$site="https://tappedout.net/"
$urlo="/mtg-deck-builder/pioneer/"    # 
$savepath="decks\"


$uripathDownload="/mtg-decks/"
$regex = "/mtg-decks/(.+)/"



$uri=$site+$urlo
$decklist=(Invoke-WebRequest –Uri $uri ).Links|  Where-Object {$_.href -like “/mtg-decks/*/"}|Select-Object -ExpandProperty href
#((Invoke-WebRequest –Uri $urlo).Links | Where-Object {$_.href -like “/deck"})
#Write-Host $decklist

#get the deck ids from urls /deck/1111111#paper
$numbers=$decklist| ForEach-Object {
    if($_ -match $regex){
        $Matches.1
    }

} | Get-Unique
#Write-Host $numbers
#loop 

#get contents from URI like #https://tappedout.net/mtg-decks/songs-of-the-damned-bgr/?fmt=txt
foreach ($num in $numbers) {
    $uri=$site+$uripathDownload+$num +"/?fmt=txt"
    #Write-Host $uri
    #don't like this method to extract but it was the fastest
    $head=[string](Invoke-WebRequest –Uri $uri).Headers['Content-Disposition']
    
    $filename = $savepath+$num+"-"+$head.Substring($head.IndexOf("=")+1).Replace('"','').Replace('/','_')
    Write-Host $filename
    (Invoke-WebRequest –Uri $uri).Content | Out-File -FilePath $filename

}

