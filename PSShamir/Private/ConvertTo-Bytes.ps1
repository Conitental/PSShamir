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
