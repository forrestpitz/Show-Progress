$publishModuleSplat = @{
    Path        = ".\Show-Progress"
    NuGetApiKey = [System.Environment]::GetEnvironmentVariable("psgallaryapikey", "Machine")
    Verbose     = $true
    Force       = $true
    Repository  = "PSGallery"
    ErrorAction = "Stop"
}

"Files in module output:"
Get-ChildItem $publishModuleSplat.Path -Recurse -File | Select-Object -Expand FullName

"Publishing [$($publishModuleSplat.Path)] to [$($publishModuleSplat.Repository)]"

Publish-Module @publishModuleSplat