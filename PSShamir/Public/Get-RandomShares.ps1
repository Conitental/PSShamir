Function Get-RandomShares {
    Param (
        [bigint]$Secret,
        [int]$MinShares = 3,
        [int]$Shares,
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
                num = $i
                value = $Value | Out-String
        }) | Out-Null
    }

    return $Points
}
