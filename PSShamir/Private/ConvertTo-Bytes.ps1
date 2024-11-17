<#
.SYNOPSIS
    Encodes a string to a byte array.

.DESCRIPTION
    Converts a string to a byte array using the specified encoding.

.PARAMETER String
    The string to encode.

.PARAMETER Encoding
    The encoding to use for the string. Defaults to UTF8.

.OUTPUTS
    A byte array of the input string

.EXAMPLE
    Encode a string to a byte array:
    "Hello, World!" | ConvertTo-Bytes
#>
Function ConvertTo-Bytes {
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [String]$String,
        [System.Text.Encoding]$Encoding = [System.Text.Encoding]::UTF8
    )

    Process {
        # Simply use the given encoder to return the bytes
        Return $Encoding.GetBytes($String)
    }
}
