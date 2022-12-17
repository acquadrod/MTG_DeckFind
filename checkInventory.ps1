param(
    [Parameter()]
    [String]$inventoryPath="all-folders.csv",
    [String]$deckPath="decks\",
    [int]$showDetail = 0,
    [int]$top = 10
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
    $total=0
    Import-Csv $filePath | ForEach-Object {
        if (!$out.ContainsKey($_.CardName)) {
            $total+=[int]$_.Quantity
            Write-debug "not found $($_.CardName)"
            $folder=@{}
            $folder.add($_.FolderName, [int]$_.Quantity)
            $lang=@{}
            $lang.add($_.Language,[int]$_.Quantity)

            $obj=New-Object PSObject -Property @{name=$_.CardName; tot=$_.Quantity; folders=$folder; languages=$lang}
            $out.add($_.CardName, $obj)
        } else {
            $total+=[int]$_.Quantity
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
    Write-Host "Found $total cards in your inventory"
    
    return $out

}

#read deck  format  <quantity> <card name>
Function ReadDeck($f) {
    $d=@{}
    #Write-Information $f
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

    $card_found_list=@()
    $card_not_found_list=@()

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
            $tmp=New-Object PSObject -Property @{name=$card;quantity=$list[$card]; folders=$inventory[$card].folders.Keys;languages=$inventory[$card].languages.Keys }
            $card_found_list += $tmp
        } else {
            $notfound.add($card,$list[$card])
            $tmp=New-Object PSObject -Property @{name=$card;quantity=$list[$card] }
            $card_not_found_list += $tmp
        }
        
    }
    $deckname=([string]$path[0]).Substring(([string]$path[0]).LastIndexOf("/")+1)
    $deckname=($deckname).Substring(($deckname).LastIndexOf("\")+1)
    if ($showDetail) {
        $obj=New-Object PSObject -Property @{deckName=$deckname; cardsCount = $deckCardsCount; cardsFoundCount=$cardFound; perc= 100*$cardFound/$deckCardsCount ; found=$card_found_list; notFound=$card_not_found_list }
    } else {
        $obj=New-Object PSObject -Property @{deckName=$deckname; cardsCount = $deckCardsCount; cardsFoundCount=$cardFound; perc= 100*$cardFound/$deckCardsCount ; found=$found; notFound=$notfound }
    }
    return $obj
}
#########################
# main loop  
#
$stats =@()
$decks=Get-ChildItem -Path $deckPath -File -Filter *.txt -Recurse| Select-Object -ExpandProperty FullName 


Write-Host "Found $($decks.Count) decks"

#read inventory
$inventory=GetInventory ($inventoryPath)

#cycle on decks
foreach ($dd in $decks) {
    #Write-Host $dd
    $stats+=CheckDeck ($dd,$inventory)
}

#you can limit output
if ($showDetail) {
    $stats|Sort-Object  perc -Descending|Select-Object -first $showDetail |ConvertTo-Json  -Depth 3
} else {
    $stats|Sort-Object  perc -Descending |Select-Object deckName, perc -First $top
}

#Write-Output $notfound
 