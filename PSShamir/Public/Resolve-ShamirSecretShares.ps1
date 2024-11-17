<#
.SYNOPSIS
    Recovers a secret from Shamir's Secret Sharing scheme shares.

.DESCRIPTION
    This function takes an array of Base64 encoded share objects and recovers the original secret string using Shamir's Secret Sharing. It deserializes the shares, extracts individual share information, sorts shares by chunk index, recovers each chunk secret, and finally combines the recovered chunks back into the original secret.

.PARAMETER Shares
    An array of strings containing Base64 encoded share objects, generated by the `Get-ShamirSecretShares` function.

.OUTPUTS
    The recovered secret as a byte array. You can further convert it to a string using `ConvertFrom-Bytes`.

.EXAMPLE
    Recover a secret from shares:
    Resolve-ShamirSecretShares -Shares $Shares
#>
Function Resolve-ShamirSecretShares {
    Param(
        [Parameter(Mandatory)]
        [String[]]$Shares
    )

    # Retrieve the actual encrypted data from the base64 string
    Try {
        $UnserializedData = $Shares | ConvertFrom-SerializedObject
    } Catch {
        Throw [System.Management.Automation.ParsingMetadataException] "Could not unserialize share data"
    }


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
    Try {
        # TODO: Find a better way to handle supposedly wrong or few shares
        [Byte[]]$Bytes = Split-Array -Array ($RecoveredChunks -join '').ToCharArray() -ChunkSize 3 | Foreach-Object { $_ -join '' }
    } Catch {
        throw "Could not resolve secret. Did you provide the correct amount of the correct shares?"
    }

    $Bytes | ConvertFrom-Bytes
}