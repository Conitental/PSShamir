Function Resolve-ShamirSecretShares {
    Param(
        [Parameter(Mandatory)]
        [String[]]$Shares
    )

    # Retrieve the actual encrypted data from the base64 string
    $UnserializedData = $Shares | ConvertFrom-SerializedObject

    # Unzip the shares 
    $AllShares = Foreach($SharePackageById in $UnserializedData) {
        $ShareId = $SharePackageById.Id

        Foreach($Share in $SharePackageById.Data) {
            [PSCustomObject]@{
                id = $ShareId
                value = $Share.value
                chunkindex = $Share.chunkindex
            }
        }
    }

    $SortedChunks = $UnserializedData.Data.chunkindex | Select-Object -Unique | Sort-Object
    $RecoveredChunks = Foreach($ChunkIndex in $SortedChunks) {
        # Get all shares for the current data chunk
        $ChunkShares = $AllShares | Where-Object chunkindex -eq $ChunkIndex

        $ExpectedShares = $ChunkShares | Select-Object @{
            Name = 'id'
            Expr = { $_.id }
        }, @{
            Name = 'value'
            Expr = { $_.value }
        }

        [String]$Secret = Resolve-Secret $ExpectedShares

        # Pad the resolved secret to accomodate for lost leading zeros due to the type conversion
        If(($Secret.Length % 3) -ne 0) {
            $ExpectedSize = $Secret.Length + (3 - ($Secret.Length % 3))
            $Secret = $Secret.PadLeft($ExpectedSize, '0')
        }

        Write-Output $Secret    
    }

    # Join the resolved secrets and split the resulting string to chunks of 3 chars
    [Byte[]]$Bytes = Split-Array -Array ($RecoveredChunks -join '').ToCharArray() -ChunkSize 3 | Foreach-Object { $_ -join '' }

    $Bytes | ConvertFrom-Bytes
}