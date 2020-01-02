function Show-Progress {
    <#
        .SYNOPSIS
            Show progress as items pass through a section of the pipline
        .DESCRIPTION
            This function allows you to show progress from the pipeline.
            Its intentionally written for efficiency/speed so some compromises on readability were made
        .PARAMETER InputObject
            The items on the pipeline being processed
        .PARAMETER Activity
            The activity being measured
        .PARAMETER UpdatePercentage
            The percentage of time to update the progress bar.
            Write-Progress is a slow cmdlet so this is used for performance reasons with larger data sets
        .EXAMPLE
            # This runs through the numbers 1 through 1000 and displays a progress bar based on how many have gone through the pipeline
            1..1000 | Show-Progress
        .EXAMPLE
            # Showing progress with a specific activity message and only updating at 10%, 20% etc
            1..1000 | Show-Progress -Activity "doin stuff" -UpdatePercentage 10
        #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [PSObject[]]
        $InputObject,

        [string]
        $Activity = "Processing items",

        [ValidateRange(1, 100)]
        [int]
        $UpdatePercentage
    )

    $count = 0
    [int]$totalItems = $Input.count
    $progressWritten = @()

    # use a dot sourced scriptblock to loop despite its lower redability as its extremely fast
    $Input | . {
        process {
            # pass thru the input
            #$_

            $count++

            [int]$percentComplete = ($Count / $totalItems * 100)

            $writeProgressSplat = @{
                Activity        = $Activity
                PercentComplete = $percentComplete
                Status          = "Working - $percentComplete%"
            }

            if ($percentComplete -notin $progressWritten -and ($UpdatePercentage -eq 0 -or $percentComplete % $UpdatePercentage -eq 0)) {
                $progressWritten += $percentComplete
                Write-Progress @writeProgressSplat
            }
        }
    }
}