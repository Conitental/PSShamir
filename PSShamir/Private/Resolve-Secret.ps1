<#
.SYNOPSIS
    Recovers a secret from Shamir's Secret Sharing scheme shares.

.DESCRIPTION
    Recovers a secret from Shamir's Secret Sharing scheme by performing Lagrange interpolation over the provided shares.

.PARAMETER Shares
    An array of share objects, each containing an ID and a value.

.PARAMETER Prime
    The prime modulus for the finite field. Defaults to 2^127 - 1.

.OUTPUTS
    The recovered secret value.

.EXAMPLE
    Recover a secret from shares:
    $Shares = @(@{id = 1; value = "2"}, @{id = 2; value = "4"}, @{id = 3; value = "9"})
    $Prime = [bigint][math]::Pow(2,127) - 1
    Resolve-Secret -Shares $Shares -Prime $Prime
#>
Function Resolve-Secret {
    param (
        [array[]]$Shares,
        [bigint]$Prime = [bigint][math]::Pow(2,127) - 1
    )

    if ($Shares.Length -lt 3) {
        # throw "Need at least three shares."
    }

    # Unzip the shares into x_s and y_s
    $PointNums = [System.Collections.ArrayList]@()
    $PointPolynomials = [System.Collections.ArrayList]@()

    foreach ($Share in $Shares) {
        $PointNums.Add($Share.id) | Out-Null

        # Parse the given string for more accuracy
        $PointPolynomials.Add([bigint]::Parse($Share.value)) | Out-Null
    }

    Return (Get-LagrangeInterpolation -x 0 -PointNums $PointNums -PointPolynomials $PointPolynomials -Prime $Prime)

}
