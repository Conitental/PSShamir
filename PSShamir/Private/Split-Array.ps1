<#
.SYNOPSIS
    Splits an array into smaller chunks of a specified size.

.DESCRIPTION
    Divides an array into smaller chunks of a specified size. If the array length isn't divisible by the chunk size, the last chunk will be smaller.

.PARAMETER Array
    The array to split.

.PARAMETER ChunkSize
    The desired size of each chunk. Defaults to 10.

.OUTPUTS
    An array of arrays, each representing a chunk of the original array.

.EXAMPLE
    Split an array into chunks of 3:
    $myArray = @(1, 2, 3, 4, 5, 6, 7, 8, 9)
    Split-Array -Array $myArray -ChunkSize 3
#>
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