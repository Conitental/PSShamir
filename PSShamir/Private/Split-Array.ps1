Function Split-Array {
    Param(
        [Parameter(Mandatory)]
        [Array]$Array,
        [int]$ChunkSize = 10
    )

    # Calculate how many chunks we need to return
    $ChunkCount = [Math]::Ceiling($Array.Length / $ChunkSize)

    $Chunks = [System.Collections.ArrayList]@()

    Foreach ($ChunkIndex in 0..($ChunkCount -1)) {
        # For each chunk we slice a part of the array and skip the chunksize times the chunkindex
        [Array]$Slice = $Array | Select-Object -Skip ($ChunkIndex * $ChunkSize) -First $ChunkSize
        $Chunks.Add($Slice) | Out-Null
    }

    Return $Chunks
}