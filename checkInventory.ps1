param(
    [Parameter()]
    [String]$inventoryPath="all-folders.csv",
    [String]$deckPath="decks\"
)

#common variables

$regex = "^(\d)x?\ (.+)$"



# group inventory by card name
# key = "Urza's Rebuff",
# value = { name ="Urza's Rebuff", total=2, 
#           languages = [{lang="english",tot=1},{lang="italian",tot=1}]},
#           folders = [{name="bro",tot=1},{name="starter set",tot=1}]
#         }

function GetInventory ($filePath) {
    $out=@{}
    Import-Csv $filePath | ForEach-Object {
        if (!$out.ContainsKey($_.CardName)) {
            Write-debug "not found $($_.CardName)"
            $folder=@{}
            $folder.add($_.FolderName, [int]$_.Quantity)
            $lang=@{}
            $lang.add($_.Language,[int]$_.Quantity)

            $obj=New-Object PSObject -Property @{name=$_.CardName; tot=$_.Quantity; folders=$folder; languages=$lang}
            $out.add($_.CardName, $obj)
        } else {
            Write-debug  "found $($_.CardName)"
            $out[$_.CardName].tot = [int]$out[$_.CardName].tot + [int]$_.quantity
            #check folders counter
            if ($out[$_.CardName].folders.ContainsKey($_.FolderName)) {
                $out[$_.CardName].folders[$_.FolderName] += $_.Quantity
        
            } else {
                $out[$_.CardName].folders.add($_.FolderName, [int]$_.Quantity)
            }
            #check languages count
            if ($out[$_.CardName].languages.ContainsKey($_.Language)) {
                $out[$_.CardName].languages[$_.Language] += $_.Quantity
        
            } else {
                $out[$_.CardName].languages.add($_.Language, [int]$_.Quantity)
            }
        }
    }

    
    return $out

}

#read deck  format  <quantity> <card name>
Function ReadDeck($f) {
    $d=@{}
    Write-Information $f
    Get-Content -Path $f | ForEach-Object {
        if($_ -match $regex){
            if ($d.ContainsKey($Matches.2)) {
                $d[$Matches.2] += [int]$Matches.1
            } else {
                $d.add($Matches.2,[int]$Matches.1)
            }
            
            
        }
    }
    return $d
}

function CheckDeck ($path) {
    $list=@{}
    $found=@{}
    $notfound=@{}

    
    $list=ReadDeck($path[0])

    $deckCardsCount =($list.Values |Measure-Object -sum ).sum
    $cardFound=0

    
    

    foreach ($card in $list.Keys) {
        if ($inventory.ContainsKey($card)) {
            if ($inventory[$card].tot -ge $list[$card]) {
                $found.add($card,$list[$card])
                $cardFound += $list[$card]
            } else {
                $found.add($card,$inventory[$card].tot)
                $cardFound += $inventory[$card].tot
                $notfound.add($card,$list[$card] - $inventory[$card].tot)

            }
        } else {
            $notfound.add($card,$list[$card])
        }
        
    }
    $deckname=([string]$path[0]).Substring(([string]$path[0]).LastIndexOf("/")+1)
    $deckname=($deckname).Substring(($deckname).LastIndexOf("\")+1)

    $obj=New-Object PSObject -Property @{deckName=$deckname; cardsCount = $deckCardsCount; cardsFoundCount=$cardFound; perc= 100*$cardFound/$deckCardsCount ; found=$found; notFound=$notfound }
    return $obj
}
#########################
# main loop  
#
$stats =@()
$decks=Get-ChildItem -Path $deckPath -File -Filter *.txt | Select-Object -ExpandProperty FullName 


#read inventory
$inventory=GetInventory ($inventoryPath)

#cycle on decks
foreach ($dd in $decks) {
    Write-Host $dd
    $stats+=CheckDeck ($dd,$inventory)
}

$stats|Sort-Object  perc -Descending |Select-Object deckName, perc
#Write-Output $notfound
 