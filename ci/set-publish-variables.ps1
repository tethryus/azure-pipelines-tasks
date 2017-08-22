# Determine whether to publish the milestone package
$publishMilestone = ''
if ($env:BUILD_SOURCEBRANCH -match '^refs/heads/releases/m[0-9]+$') {
    $publishMilestone = 'true'
}

Write-Host "Publish milestone: '$publishMilestone'"
Write-Host "##vso[task.setVariable variable=publish_milestone]$publishMilestone"

# Determine whether to publish the aggregate tasks
$publishAggregate = ''
if ($env:PUBLISH -or $env:BUILD_SOURCEBRANCH -like 'refs/heads/releases/*') {
    $publishAggregate = 'true'
}

Write-Host "Publish aggregate: '$publishAggregate'"
Write-Host "##vso[task.setVariable variable=publish_aggregate]$publishAggregate"

# Determine the milestone version
$milestoneVersion = ''
if ($publishMilestone) {
    Write-Host ""
    Write-Host "> git rev-parse --short=8 HEAD"
    $commit = & git rev-parse --short=8 HEAD
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Unexpected exit code: $LASTEXITCODE"
    }

    $milestoneVersion = "1.0.0-$env:BUILD_SOURCEBRANCHNAME-$commit"
}

Write-Host "Milestone version: '$milestoneVersion'"
Write-Host "##vso[task.setVariable variable=milestone_version]$milestoneVersion"

# Determine the aggregate version
$now = [System.DateTime]::UtcNow
$aggregateVersion = "1.$('{0:yyyyMMdd}' -f $now).$([System.Math]::Floor($now.timeofday.totalseconds))-$env:BUILD_SOURCEBRANCHNAME"
Write-Host "Aggregate version: '$aggregateVersion'"
Write-Host "##vso[task.setVariable variable=aggregate_version]$aggregateVersion"
