#download deck from mtggoldfish homepage pauper
#
$type="commander"
$site="https://www.mtggoldfish.com"
#check out loop 
$urlo="/metagame/"+$type+"/full?page="    # for more pages metagame/standard/full?page=2#paper
$savepath="decks\goldfish\meta\"+$type+"\"

New-item -type directory -path $savepath -Force

$uripathDownload="/deck/download/"
$regex = "/archetype/(.+)#paper"
#https://www.mtggoldfish.com/deck/download/5267732  to download txt format

#checkout this loop
for ($i=1;$i -le 17;$i++) {
    $uri=$site+$urlo+$i+"#paper"
    Write-Host $uri
    $decklist+=(Invoke-WebRequest –Uri $uri ).Links|  Where-Object {$_.href -like “/archetype/*#paper"}|Select-Object -ExpandProperty href
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
    $uri=$site+"/archetype/"+$num
    $dl= $site+((Invoke-WebRequest –Uri $uri).Links|  Where-Object {$_.href -like “/deck/download/*"}|Select-Object -ExpandProperty href)[0]

    #Write-Host $dl
    
    #don't like this method to extract but it was the fastest
    $body=(Invoke-WebRequest –Uri $dl)
    $head=[string]$body.Headers['Content-Disposition']
    $filename = $savepath+$num+"-"+$head.Substring($head.IndexOf("=")+1).Replace('"','').Replace('/','_')
    Write-Host $filename
    if ('' -eq ($head.Substring($head.IndexOf("=")+1).Replace('"','').Replace('/','_')) ) {
        Write-Warning "no Content-Disposition Header for  $uri"
    } else {
        $body.Content | Out-File -FilePath $filename
    }
    
    
}

