<#
.SYNOPSIS
    Calculates the product of a list of numbers.

.DESCRIPTION
    Calculates the product of a list of numbers.

.PARAMETER Values
    The list of numbers to multiply.

.OUTPUTS
    The product of the numbers.

.EXAMPLE
    Calculate the product of 2, 3, and 4:
    Get-InputProduct -Values 2, 3, 4
#>
Function Get-InputProduct {
    Param(
        $Values
    )

    [bigint]$Accumulator = 1

    Foreach($Value in $Values) {
        $Accumulator *= $Value
    }

    Return $Accumulator
}