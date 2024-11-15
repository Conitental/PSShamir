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
        If($b -lt 5) {
            $Quot = [bigint]::Divide($a, $b)
        } Else {
            [bigint]$Quot = [math]::Floor([double]$a / [double]$b)
        }

        $a, $b = $b, (Get-PythonModulus -Operant $a -Modulus $b)

        $X, $LastX  = ($LastX - $Quot * $X), $X
        $Y, $LastY  = ($LastY - $Quot * $Y), $Y
    }

    Return @($LastX, $LastY)
}
