Function Get-PythonModulus {
	Param(
        [bigint]$Operant,
        [bigint]$Modulus
    )

    $Result = $Operant % $Modulus

    If($Result -lt 0) {
        $Result += $Modulus
    }

    Return $Result
}
