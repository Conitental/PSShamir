<#
.SYNOPSIS
    Splits a secret into shares using Shamir's Secret Sharing scheme.

.DESCRIPTION
    This function takes a secret string and splits it into shares using Shamir's Secret Sharing scheme. It first converts the secret into bytes, pads them, and splits them into chunks. Each chunk is then shared using Shamir's Secret Sharing, and the resulting shares are combined and serialized.

.PARAMETER Secret
    The secret string to be shared.

.PARAMETER Shares
    The total number of shares to generate. Defaults to 7.

.PARAMETER MinimumShares
    The minimum number of shares required to reconstruct the secret. Defaults to 3.

.OUTPUTS
    A serialized object containing an array of share objects, each with an ID, value, and chunk index.

.EXAMPLE
    Share a secret:
    $Secret = "MySecretMessage"
    Get-ShamirSecretShares -Secret $Secret
#>
Function Get-ShamirSecretShares {
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [String]$Secret,
        [ValidateRange(2, [Int]::MaxValue)]
        [Int]$Shares = 7,
        [ValidateRange(2, [Int]::MaxValue)]
        [Alias('MinShares')]
        [Int]$MinimumShares = 3
    )

    # Validate the amount of shares. This is being done outside of Param() as the parameters would be handled differently if -MinShares would be given later
    If( $Shares -lt $MinimumShares) {
        Throw [System.Management.Automation.ValidationMetadataException] "$Shares shares and $MinimumShares minimum shares. The secret would not be recoverable."
    }

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