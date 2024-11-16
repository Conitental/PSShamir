Function Get-ShamirSecretShares {
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [String]$Secret,
        [Int]$Shares = 7,
        [Int]$MinimumShares = 3
    )

    # Convert the secret to bytes and pad them for a consistent length of the single secrets
    $Bytes = ConvertTo-Bytes $Secret | ForEach-Object {
        If($_ -lt 10) {
            "00$_"
        } ElseIf($_ -lt 100) {
            "0$_"
        } Else {
            "$_"
        }
    }

    $ChunkIndex = 0
    # By splitting into chunks of 9 we manage to stay under 28 digits which would overflow [BigInt]
    $AllShares = Split-Array $Bytes -ChunkSize 9 | Foreach-Object {
        $Chunk = $_
        $ChunkSecret = $Chunk -join ''

        $ChunkShares = Get-RandomShares -Secret $ChunkSecret -MinShares $MinimumShares -Shares $Shares

        Foreach ($Share in $ChunkShares) {
            [PSCustomObject]@{
                id = $Share.id
                value = $Share.value.ToString()
                chunkindex = $ChunkIndex
            }
        }

        $ChunkIndex++
    }

    $ZippedShares = ($AllShares | Group-Object -Property id).Name | Foreach-Object {
        $ShareId = $_
        $SharesForId = $AllShares | Where-Object id -eq $ShareId

        $Data = Foreach ($Share in $SharesForId) {
            [PSCustomObject]@{
                value = $Share.value.ToString()
                chunkindex = $Share.chunkindex
            }
        }

        [PSCustomObject]@{
            Id = $ShareId
            Data = $Data
        }
    }

    Return $ZippedShares | ConvertTo-SerializedObject
}