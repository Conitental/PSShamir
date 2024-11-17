<#
.SYNOPSIS
    Encodes a string to Base64.

.DESCRIPTION
    Converts a string to a Base64-encoded string. You can specify the encoding to use for the string.

.PARAMETER String
    The string to encode.

.PARAMETER Encoding
    The encoding to use for the string. Defaults to UTF8.

.OUTPUTS
    A Base64 encoded string of the input

.EXAMPLE
    Encode a string to Base64:
    "Hello, World!" | ConvertTo-Base64
#>
Function ConvertTo-Base64 {
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [String]$String,
        [System.Text.Encoding]$Encoding = [System.Text.Encoding]::UTF8
    )

    Process {
        $Bytes = $String | ConvertTo-Bytes -Encoding $Encoding
        Return [System.Convert]::ToBase64String($Bytes)
    }
}
