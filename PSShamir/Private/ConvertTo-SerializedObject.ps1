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