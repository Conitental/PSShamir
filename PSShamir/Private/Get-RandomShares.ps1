<#
.SYNOPSIS
    Generates Shamir's Secret Sharing scheme shares.

.DESCRIPTION
    Generates Shamir's Secret Sharing scheme shares for a given secret.

.PARAMETER Secret
    The secret to share.

.PARAMETER MinShares
    The minimum number of shares required to recover the secret.

.PARAMETER Shares
    The total number of shares to generate.

.PARAMETER Prime
    The prime modulus for the finite field.

.OUTPUTS
    An array of share objects, each containing an ID and a value.

.EXAMPLE
    Generate Shamir's Secret Sharing scheme shares:
    $Secret = 12345
    $MinShares = 3
    $Shares = 7
    $Prime = [bigint][math]::Pow(2,127) - 1
    Get-RandomShares -Secret $Secret -MinShares $MinShares -Shares $Shares -Prime $Prime
#>
Function Get-RandomShares {
    Param (
        [ValidateScript({
            If([BigInt]::Parse($_)) { $true }
        })]
        [String]$Secret,
        [int]$MinShares = 3,
        [int]$Shares = 7,
        [bigint]$Prime = [bigint][math]::Pow(2,127) - 1
    )

    If ($MinShares -gt $Shares) {
        throw "Less shares than minimun shares to recover make the secret irrecoverable"
    }

    # Create the polynomial coefficients
    $Polynomial = @($Secret) + (1..($MinShares - 1) | ForEach-Object { Get-Random -Minimum 0 -Maximum $Prime })

    # Generate the share points
    $Points = [System.Collections.ArrayList]@()
    for ($i = 1; $i -le $Shares; $i++) {
        $Value = Test-Polynomial -Polynomial $Polynomial -PointToEval $i -Prime $Prime
        # We output the shares as string as that will make the initial handling of the variables to recover as bigints more controllable
        $Points.Add(
            [pscustomobject]@{
                id = $i
                value = $Value
        }) | Out-Null
    }

    return $Points
}
