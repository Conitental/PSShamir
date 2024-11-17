<#
.SYNOPSIS
    Evaluates a polynomial at a given point over a finite field.

.DESCRIPTION
    Evaluates a polynomial at a given point over a finite field using Horner's method for efficient calculation.

.PARAMETER Polynomial
    An array of coefficients representing the polynomial.

.PARAMETER PointToEval
    The point at which to evaluate the polynomial.

.PARAMETER Prime
    The prime modulus of the finite field.

.OUTPUTS
    The value of the polynomial at the given point.

.EXAMPLE
    Evaluate the polynomial x^2 + 2x + 1 at point 3 over the field modulo 7:
    $Polynomial = @(1, 2, 1)
    $PointToEval = 3
    $Prime = 7
    Test-Polynomial -Polynomial $Polynomial -PointToEval $PointToEval -Prime $Prime
#>
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
