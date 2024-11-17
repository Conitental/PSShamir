<#
.SYNOPSIS
    Calculates the floor division of two integers.

.DESCRIPTION
    Calculates the floor division of two integers, handling negative numbers correctly.

.PARAMETER a
    The dividend.

.PARAMETER b
    The divisor.

.OUTPUTS
    The floor division of the two integers.

.EXAMPLE
    Calculate the floor division of -10 and 3:
    Get-FloorDivision -a -10 -b 3
#>
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