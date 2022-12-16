Get-ChildItem -Path "AllDeckFiles\" -Filter *.json -File | Select-Object -ExpandProperty FullName | ForEach-Object {

    $obj=(Get-Content -Path $_|ConvertFrom-Json).data

    $deckname="decks\" + $obj.name +"_" + $obj.code +".txt"
    Write-Host $deckname
    $content=$obj.mainBoard|Select-Object count,name |ForEach-Object {"" + $_.count + " " + $_.name}
    $content+=$obj.sideBoard|Select-Object count,name |ForEach-Object {"" + $_.count + " " + $_.name}

    $content|Out-File -FilePath $deckname

}


