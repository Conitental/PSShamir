Function ConvertFrom-Bytes {
    Param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [Byte]$Bytes,
        [System.Text.Encoding]$Encoding = [System.Text.Encoding]::UTF8
    )

    Begin {
        $ByteArray = [System.Collections.ArrayList]@()
    }

    Process {
        $ByteArray.Add($Bytes) | Out-Null
    }

    End {
        Return $Encoding.GetString([byte[]]$ByteArray)
    }
}
