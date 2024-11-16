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