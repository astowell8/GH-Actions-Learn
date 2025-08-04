clear-host

# Setting Variables

$ReleaseBranch = 'main' 
$TagPrefix     = 'Release_v' #Prefix used to identify Release tags.
$CurrentBranch = $null
$ReleaseSHA    = $null #SHA of the current release.
$PreviousSHA   = $null #SHA of the previous release.

# Get Current branch
$CurrentBranch = git rev-parse --abbrev-ref HEAD

# Check if the branch is 'main' 
if ($currentBranch -ne 'main') {
    Write-Host "Error: Release tags should be only published on 'main' branch." -ForegroundColor Red
    exit 1
} else {
    Write-Host "Current branch ($currentBranch) is the designated release branch. Continueing ... " -ForegroundColor Green
}

# Make sure Repo is up to day.
git fetch --all --tags 
git pull 


$CurrentBranch = git rev-parse --abbrev-ref HEAD

$tags = @( git tag --list "$TagPrefix*" )

#$SortedTags = $tags | 
#    Sort-Object -Descending |
#    ForEach-Object{ $_.replace($TagPrefix,'') }

$SortedTags = $tags | Sort-Object -Descending 

$ReleaseSHA = ( git rev-parse $SortedTags[0] )
$PreviousSHA  = ( git rev-parse $SortedTags[1] )

Write-Host $ReleaseSHA
Write-Host $PreviousSHA

git diff --name-only $ReleaseSHA $PreviousSHA

