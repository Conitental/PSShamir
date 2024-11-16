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
