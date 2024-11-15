Function Test-Polynomial  {
    param (
        [bigint[]]$Polynomial,
        [bigint]$PointToEval,
        [bigint]$Prime
    )

    $Accumulator = 0
    # Iterate over the coefficients in reverse order
    for ($i = $Polynomial.Length - 1; $i -ge 0; $i--) {
        $Accumulator *= $PointToEval
        $Accumulator += $Polynomial[$i]
        $Accumulator %= $Prime
    }

    return $Accumulator
}
