<#
.SYNOPSIS
    Deserializes a Base64-encoded JSON string.

.DESCRIPTION
    Converts a Base64-encoded JSON string to a PowerShell object. You can specify the maximum depth of the object to deserialize.

.PARAMETER String
    The Base64-encoded JSON string to deserialize.

.PARAMETER Depth
    The maximum depth of the object to deserialize. Defaults to 5.

.OUTPUTS
    The unserialized object

.EXAMPLE
    Deserialize a Base64-encoded JSON string:
    "SGVsbG8gV29ybGQ=" | ConvertFrom-SerializedObject

.EXAMPLE
    Deserialize a Base64-encoded JSON string with a specific depth:
    "SGVsbG8gV29ybGQ=" | ConvertFrom-SerializedObject -Depth 3
#>
Function ConvertFrom-SerializedObject {
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [String]$String,
        [Int]$Depth = 5
    )

    Process {
        $String | ConvertFrom-Base64 | ConvertFrom-Json -Depth $Depth
    }
}