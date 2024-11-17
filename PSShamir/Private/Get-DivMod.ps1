<#
.SYNOPSIS
    Calculates the modular multiplicative inverse of a number.

.DESCRIPTION
    Calculates the modular multiplicative inverse of a number using the extended Euclidean algorithm.

.PARAMETER Numerator
    The numerator of the fraction.

.PARAMETER Denominator
    The denominator of the fraction.

.PARAMETER Prime
    The prime modulus.

.OUTPUTS
    The modular multiplicative inverse of the fraction.

.EXAMPLE
    Calculate the modular multiplicative inverse of 10/7 modulo 11:
    Get-DivMod -Numerator 10 -Denominator 7 -Prime 11
#>
Function Get-DivMod {
    Param(
        [bigint]$Numerator,
        [bigint]$Denominator,
        [bigint]$Prime
    )

    $Inverse = (Get-ExtGreatestCommonDivisor -a $Denominator -b $Prime)[0]

    $Output = $Numerator * $Inverse

    Return $Output
}
