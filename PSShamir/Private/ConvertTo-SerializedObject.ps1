<#
.SYNOPSIS
    Serializes an object to a Base64-encoded JSON string.

.DESCRIPTION
    Converts a PowerShell object to a Base64-encoded JSON string. You can specify the maximum depth of the object to serialize.

.PARAMETER InputObject
    The object to serialize.

.PARAMETER Depth
    The maximum depth of the object to serialize. Defaults to 5.

.OUTPUTS
    A Base64 string of the input object in json format

.EXAMPLE
    Serialize an object to a Base64-encoded JSON string:
    @{ Name = "John Doe"; Age = 30 } | ConvertTo-SerializedObject
#>
Function ConvertTo-SerializedObject {
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [Object]$InputObject,
        [Int]$Depth = 5
    )

    Process {
        Return $InputObject | ConvertTo-Json -Depth $Depth | Out-String | ConvertTo-Base64
    }
}