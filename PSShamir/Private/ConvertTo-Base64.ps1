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
