Function ConvertFrom-Base64 {
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [String]$String,
        [System.Text.Encoding]$Encoding = [System.Text.Encoding]::UTF8
    )

    Process {
        $Bytes = [System.Convert]::FromBase64String($String)
        Return $Bytes | ConvertFrom-Bytes -Encoding $Encoding
    }
}
