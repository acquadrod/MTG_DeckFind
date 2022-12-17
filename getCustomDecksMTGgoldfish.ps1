#download deck from mtggoldfish homepage pauper
#
$type="pauper"
$site="https://www.mtggoldfish.com"
$urlo="/deck/custom/"+$type+"?page="    # add page number for more pages deck/custom/standard?page=2#paper
$savepath="decks\goldfish\custom\"+$type+"\"

New-item -type directory -path $savepath -Force

$uripathDownload="/deck/download/"
$regex = "/deck/([0-9]+)#paper"
#https://www.mtggoldfish.com/deck/download/5267732  to download txt format

for ($i=1;$i -le 20;$i++) {
    $uri=$site+$urlo+$i+"#paper"
    Write-Host $uri
    $decklist+=(Invoke-WebRequest –Uri $uri ).Links|  Where-Object {$_.href -like “/deck/*#paper"}|Select-Object -ExpandProperty href
}
Write-Host $decklist

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
    $head=[string]((Invoke-WebRequest –Uri $uri).Headers['Content-Disposition'])
    $filename = $savepath+$num+"-"+$head.Substring($head.IndexOf("=")+1).Replace('"','').Replace('/','_')
    Write-Host $filename
    if ('' -eq ($head.Substring($head.IndexOf("=")+1).Replace('"','').Replace('/','_')) ) {
        Write-Warning "no Content-Disposition Header for  $uri"
    } else {
        (Invoke-WebRequest –Uri $uri).Content | Out-File -FilePath $filename
    }
   

}

