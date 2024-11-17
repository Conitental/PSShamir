<#
.SYNOPSIS
    Calculates the extended greatest common divisor.

.DESCRIPTION
    Calculates the extended greatest common divisor (GCD) of two integers using the extended Euclidean algorithm.

.PARAMETER a
    The first integer.

.PARAMETER b
    The second integer.

.OUTPUTS
    An array containing the GCD and the coefficients of Bézout's identity.

.EXAMPLE
    Calculate the extended GCD of 10 and 7:
    Get-ExtGreatestCommonDivisor -a 10 -b 7
#>
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
