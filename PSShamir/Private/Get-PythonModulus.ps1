<#
.SYNOPSIS
    Calculates the modular reduction of a number.

.DESCRIPTION
    Calculates the modular reduction of a number, ensuring a positive result.

.PARAMETER Operant
    The number to reduce.

.PARAMETER Modulus
    The modulus to use for reduction.

.OUTPUTS
    The modular reduction of the number.

.EXAMPLE
    Calculate the modular reduction of -10 modulo 7:
    Get-PythonModulus -Operant -10 -Modulus 7
#>
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
