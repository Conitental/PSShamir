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

Function Get-LagrangeInterpolation {
    Param(
        $x,
        [ValidateScript({
            If($_.Count -eq ($_ | Select-Object -Unique).Count) { $true }
            Else { $false }
        })]
        [bigint[]]$PointNums,
        [bigint[]]$PointPolynomials,
        [bigint]$Prime
    )

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
