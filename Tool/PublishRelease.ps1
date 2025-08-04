#param(
#    [string]$Major = "0",
#    [string]$Minor = "0",
#    [string]$Patch = "1"
#)

# THIS SCRIPT IS FOR LEARNING GITHUB ACTIONS ONLY.
#   NOT INTENDED FOR PRODUCTION

[string]$Major = "0"
[string]$Minor = "0"
[string]$Patch = "1"
[string]$Build = "0"

#FOR DEVELOPMENT PURPOSES
set-location C:\Git\GH-Actions-Learn

# ~~  SETTINGS  ~~
#   Branch that releases are built from.

$ReleaseBranch = 'main' 
$TagPrefix = 'Release_v' #Prefix used to identify Release tags.

# ~~  SETUP  ~~

# 1. Need to Fetch all changes and tags from all remote branchs
# 2. then merge changes into current branch. 
git fetch --all --tags 
git pull 

# Get the current branch name
#    rev-parse translates Git references like HEAD, main, HEAD~2, tags, partial shas INTO full SHA.
$currentBranch = git rev-parse --abbrev-ref HEAD

# Check if the branch is 'main' 
if ($currentBranch -ne 'main') {
    Write-Host "Error: Release tags should be only published on 'main' branch." -ForegroundColor Red
    exit 1
} else {
    Write-Host "Current branch ($currentBranch) is the designated release branch. Continueing ... " -ForegroundColor Green
}

# Determine the prefix for the tag
$prefix = "Release_$Major.$Minor.$Patch.$Build"

# Get all tags that match the pattern
$tags = git tag --list "$TagPrefix*"

# Sort tags using custom script block for version comparison
$sortedTags = $tags | Sort-Object { [version]( $_.replace($TagPrefix,'' ) ) } # -replace 'Release_', '') }

#[version]  Type Accelerator. version is a system.version class. Its it represents a version number.

$Arr_SortedTags = @()

$tags | ForEach-Object {
    $Arr_SortedTags += [string]( $_.replace($TagPrefix,'' ) )
}

$tags 

$Arr_SortedTags = $Arr_SortedTags | Sort-Object -Descending

# Select the last one (highest version)
$latestTag = $sortedTags | Select-Object -Last 1

# Determine the next build number
if (-not $latestTag) {
    $nextBuildNumber = 0
} else {
    $latestBuildNumber = [int]($latestTag -replace '^.*\.')
    $nextBuildNumber = $latestBuildNumber + 1
}

# Construct the next tag
$nextTag = "$prefix$nextBuildNumber"

# Output the next tag for confirmation
Write-Host "New tag will be $nextTag"

# Create the new tag
git tag -a $nextTag -m "SQLConfig_Release"
#git tag latest -f

# Push the new tag to the origin
git push origin $nextTag
#git push origin -f latest