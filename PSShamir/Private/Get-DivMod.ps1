Function Get-DivMod {
    Param(
        [bigint]$Numerator,
        [bigint]$Denominator,
        [bigint]$Prime
    )

    $Inverse = (Get-ExtGreatestCommonDivisor -a $Denominator -b $Prime)[0]
    $InverseNew = [bigint]::GreatestCommonDivisor($Denominator, $Prime)

    $Output = $Numerator * $Inverse

    Return $Output
}
