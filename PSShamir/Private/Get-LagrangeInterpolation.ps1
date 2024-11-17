<#
.SYNOPSIS
    Performs Lagrange interpolation over a finite field.

.DESCRIPTION
    Performs Lagrange interpolation over a finite field to recover a secret value.

.PARAMETER x
    The input value to interpolate.

.PARAMETER PointNums
    An array of point numbers.

.PARAMETER PointPolynomials
    An array of polynomial values at the corresponding point numbers.

.PARAMETER Prime
    The prime modulus of the finite field.

.OUTPUTS
    The interpolated secret value.

.EXAMPLE
    Interpolate a secret value:
    $x = 5
    $PointNums = @(1, 2, 3)
    $PointPolynomials = @(2, 4, 9)
    $Prime = 11
    Get-LagrangeInterpolation -x $x -PointNums $PointNums -PointPolynomials $PointPolynomials -Prime $Prime
#>
Function Get-LagrangeInterpolation {
    Param(
        $x,
        [bigint[]]$PointNums,
        [bigint[]]$PointPolynomials,
        [bigint]$Prime
    )

    If($PointNums.Count -ne ($PointNums | Select-Object -Unique).Count) {
        throw 'Share ids need to be unique'
    }

    $PointCount = $PointNums.Count

    $Numerators = [System.Collections.ArrayList]@()
    $Denominators = [System.Collections.ArrayList]@()

    0..($PointCount-1) | Foreach-Object {
        $Others = [System.Collections.ArrayList]$PointNums

        $Current = $Others[$_]

        $Others.RemoveAt($_)

        $Numerators.Add((Get-InputProduct -Values ($Others | Foreach-Object {
            $x - $_
        }))) | Out-Null

        $Denominators.Add((Get-InputProduct -Values ($Others | Foreach-Object {
            $Current - $_
        }))) | Out-Null
    }

    $Denominator = Get-InputProduct -Values $Denominators
    $NumeratorTotal = Foreach($i in 0..($PointCount-1)) {
        # Make sure the numerator is positive
        $Num = Get-PythonModulus -Operant ($Numerators[$i] * $Denominator * $PointPolynomials[$i]) -Modulus $Prime

        If($Numerators[$i] -eq 42) { $print = $true} Else {$print = $false}
        Get-DivMod -Numerator $Num -Denominator $Denominators[$i] -Prime $Prime -print $print
    }

    [bigint]$NumeratorSum = 0
    $NumeratorTotal | ForEach-Object {
        $NumeratorSum += $_
    }

    $Secret = Get-PythonModulus -Operant (Get-DivMod -Numerator $NumeratorSum -Denominator $Denominator -Prime $Prime) -Modulus $Prime

    Return $Secret
}
