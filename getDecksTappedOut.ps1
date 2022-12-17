#  to get deck:https://tappedout.net/mtg-decks/songs-of-the-damned-bgr/?fmt=txt
# https://tappedout.net/mtg-decks/search/?format=pioneer&o=-date_updated&d=desc&p=4&page=4
# filter urls /mtg-decks/(solving-tron)/

#download deck from tappedout homepage pauper
#
$type="pauper"
$site="https://tappedout.net/"
$urlo="/mtg-decks/search/?format=$type&o=-date_updated&d=desc&page="    # change this path
$savepath="decks\tapped\$type\"

New-item -type directory -path $savepath -Force


$uripathDownload="/mtg-decks/"
$regex = "/mtg-decks/(.+)/"

function randomPause($max) {
    $pause = Get-Random -Minimum .2 -Maximum $max
    Start-Sleep -Milliseconds $pause
}

for ($i=6;$i -le 10;$i++) {
    $uri=$site+$urlo+$i
    Write-Host $uri
    $decklist+=(Invoke-WebRequest –Uri $uri ).Links|  Where-Object {$_.href -like “/mtg-decks/*/"}|Select-Object -ExpandProperty href
    randomPause(3000)
}

Write-Host $decklist.Count

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
    $body=(Invoke-WebRequest –Uri $uri)
    $head=[string]$body.Headers['Content-Disposition']
    
    $filename = $savepath+$num+"-"+$head.Substring($head.IndexOf("=")+1).Replace('"','').Replace('/','_')
    Write-Host $filename
    if ('' -eq ($head.Substring($head.IndexOf("=")+1).Replace('"','').Replace('/','_')) ) {
        Write-Warning "no Content-Disposition Header for  $uri"
    } else {
        $body.Content | Out-File -FilePath $filename
    }
    randomPause(2000)
    

}

