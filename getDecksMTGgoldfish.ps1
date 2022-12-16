#download deck from mtggoldfish homepage pauper
#
$site="https://www.mtggoldfish.com"
$urlo="/deck/custom/pauper?page=10#paper"    # for more pages deck/custom/standard?page=2#paper
$savepath="decks\"


$uripathDownload="/deck/download/"
$regex = "/deck/([0-9]+)#paper"
#https://www.mtggoldfish.com/deck/download/5267732  to download txt format


$uri=$site+$urlo
$decklist=(Invoke-WebRequest –Uri $uri ).Links|  Where-Object {$_.href -like “/deck/*#paper"}|Select-Object -ExpandProperty href
#((Invoke-WebRequest –Uri $urlo).Links | Where-Object {$_.href -like “/deck"})
#Write-Host $decklist

#get the deck ids from urls /deck/1111111#paper
$numbers=$decklist| ForEach-Object {
    if($_ -match $regex){
        $Matches.1
    }

}
Write-Host $numbers
#loop 

#get contents from URI like #https://www.mtggoldfish.com/deck/download/5267732 
foreach ($num in $numbers) {
    $uri=$site+$uripathDownload+$num
    #Write-Host $uri
    #don't like this method to extract but it was the fastest
    $head=[string](Invoke-WebRequest –Uri $uri).Headers['Content-Disposition']
    $filename = $savepath+$num+"-"+$head.Substring($head.IndexOf("=")+1).Replace('"','').Replace('/','_')
    Write-Host $filename
    (Invoke-WebRequest –Uri $uri).Content | Out-File -FilePath $filename

}

