#param(
#    [string]$Major = "0",
#    [string]$Minor = "0",
#    [string]$Patch = "1"
#)

[string]$Major = "0"
[string]$Minor = "0"
[string]$Patch = "1"
[string]$Build = "0"

#FOR DEVELOPMENT PURPOSES
set-location C:\Git\GH-Actions-Learn

# 1. Need to Fetch all changes and tags from all remote branchs
# 2. then merge changes into current branch. 
git fetch --all --tags
git pull

# Get the current branch name
$currentBranch = git rev-parse --abbrev-ref HEAD

# Check if the branch is 'main' 
if ($currentBranch -ne 'main') {
    Write-Host "`e[31mError: Release tags should be only published on 'main' branch.`e[0m"
    exit 1
}

# Determine the prefix for the tag
$prefix = "Release_$Major.$Minor.$Patch."

# Get all tags that match the pattern
$tags = git tag --list "$prefix*"

# Sort tags using custom script block for version comparison
$sortedTags = $tags | Sort-Object { [version]($_ -replace 'Release_', '') }

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