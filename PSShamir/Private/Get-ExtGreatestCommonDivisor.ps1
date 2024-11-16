function Get-FloorDivision {
    Param(
        [bigint]$a,
        [bigint]$b
    )
    $rem = 0
    $div = [bigint]::DivRem($a, $b, [ref]$rem)

    if ($div -lt 0 -and $rem -ne 0)
    {
        $div -= 1
    }

    return $div
}

Function Get-ExtGreatestCommonDivisor {
	Param(
        [bigint]$a,
        [bigint]$b
    )

    $X = 0
    $LastX = 1

    $Y = 1
    $LastY = 0
    $step = 0
    While($b -ne 0) {
        $step++

        # TODO: Find a better way to keep the precicion and accuracy
        $Quot = Get-FloorDivision $a $b

        $a, $b = $b, (Get-PythonModulus -Operant $a -Modulus $b)

        $X, $LastX  = ($LastX - $Quot * $X), $X
        $Y, $LastY  = ($LastY - $Quot * $Y), $Y
    }

    Return @($LastX, $LastY)
}
