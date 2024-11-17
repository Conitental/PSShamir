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
