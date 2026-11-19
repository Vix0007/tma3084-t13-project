# Creates the labels, milestones and issues from docs/GITHUB_SETUP.md on GitHub.
# Run once from the repo folder after `gh auth login`:
#   powershell -ExecutionPolicy Bypass -File scripts\github-setup.ps1
# Safe to re-run: labels are updated, and existing milestones/issues (same title) are skipped.

$ErrorActionPreference = 'Stop'
$repo = 'Vix0007/tma3084-t13-project'
$owner, $name = $repo.Split('/')

$people = @{
    Romeo   = 'Moreoss-creator'
    Izzan   = 'zannish05-code'
    Izzat   = 'izzatpatihie-dev'
    Vickson = 'Vix0007'
    Bryan   = 'yonandrew'
}

# ---------- Labels ----------
Write-Host "`n== Labels" -ForegroundColor Cyan
$labels = @(
    @('Must',           'f03234', 'Must-have requirement'),
    @('Should',         'fbca04', 'Should-have requirement'),
    @('Could',          '0052cc', 'Could-have requirement'),
    @('change-request', '5319e7', 'Requirement change after SRS baseline approval (SRS 4.4)')
)
foreach ($l in $labels) {
    gh label create $l[0] --repo $repo --color $l[1] --description $l[2] --force | Out-Null
    Write-Host "  label: $($l[0])"
}

# ---------- Milestones ----------
Write-Host "`n== Milestones" -ForegroundColor Cyan
$milestones = @(
    @('Milestone 1 (M1)', 'Proposal & Requirements'),
    @('Milestone 2 (M2)', 'Design and Prototype'),
    @('Milestone 3 (M3)', 'Product & Verification'),
    @('Milestone 4 (M4)', 'Final Release & Acceptance')
)
$existing = gh api "repos/$repo/milestones?state=all&per_page=100" | ConvertFrom-Json
foreach ($m in $milestones) {
    if ($existing.title -contains $m[0]) { Write-Host "  exists: $($m[0])"; continue }
    gh api "repos/$repo/milestones" -f title=$($m[0]) -f description=$($m[1]) | Out-Null
    Write-Host "  created: $($m[0])"
}
$ms = @{ M1 = 'Milestone 1 (M1)'; M2 = 'Milestone 2 (M2)'; M3 = 'Milestone 3 (M3)'; M4 = 'Milestone 4 (M4)' }

# ---------- Issues ----------
$existingIssues = gh issue list --repo $repo --state all --limit 500 --json number,title | ConvertFrom-Json

function New-Issue([string]$title, [string]$body, [string]$milestone, [string]$label, [string]$who) {
    $found = $existingIssues | Where-Object { $_.title -eq $title } | Select-Object -First 1
    if ($found) { Write-Host "  exists: #$($found.number) $title"; return [int]$found.number }

    $ghArgs = @('issue', 'create', '--repo', $repo, '--title', $title, '--body', $body, '--milestone', $ms[$milestone])
    if ($label) { $ghArgs += @('--label', $label) }
    $url = $null
    if ($who) {
        try { $url = & gh @($ghArgs + @('--assignee', $people[$who])) 2>$null } catch { $url = $null }
        if (-not $url) { Write-Host "  (couldn't assign $who yet - invite not accepted? created unassigned)" -ForegroundColor Yellow }
    }
    if (-not $url) { $url = & gh @ghArgs }
    if (-not $url) { throw "GitHub did not create the issue '$title' - see the message above." }
    $num = [int]($url.Trim() -replace '.*/', '')
    Write-Host "  created: #$num $title"
    return $num
}

function Add-SubIssue([int]$parent, [int]$child) {
    $childId = gh api "repos/$repo/issues/$child" --jq '.id'
    try {
        gh api -X POST "repos/$repo/issues/$parent/sub_issues" -F sub_issue_id=$childId 2>$null | Out-Null
    } catch { }  # already linked
}

# [parent title, parent body, sub-issues: @(title, priority, owner)]
$screens = @(
    @('UI-01 Login', 'Login screen with role-based routing (Customer / Driver / Admin).', @(
        @('UI-01: Register and log in, routed by role (add FR ID in SRS)', 'Must', 'Vickson'))),
    @('UI-02 Home: van availability', 'Customer home: search vans by date and group size.', @(
        @('FR-01 Reserve a van for a date range', 'Must', 'Izzat'))),
    @('UI-03 Booking form', 'Rental mode, destination, pickup point and price estimate.', @(
        @('FR-02 Choose self-drive or with-driver', 'Must', 'Izzat'),
        @('FR-10 Show the price per trip or per km', 'Must', 'Izzan'))),
    @('UI-04 Upload + summary', 'Upload IC/passport and rental form; booking summary.', @(
        @('FR-03 Select destination and upload IC and rental forms', 'Must', 'Izzat'))),
    @('UI-05 AI suggestions', 'AI place recommendations with a popular-places fallback.', @(
        @('FR-AI-01 AI place recommendations for the trip', 'Must', 'Vickson'))),
    @('UI-06 My bookings', 'Customer booking list with live status.', @(
        @('UI-06: View bookings and their live status (add FR ID in SRS)', 'Should', 'Izzat'))),
    @('UI-07 Trip schedule', 'Driver trips, start/end trip, earnings.', @(
        @('FR-21 View assigned trips and schedule', 'Should', 'Romeo'))),
    @('UI-08 Admin dashboard', 'Pending bookings, fleet today, income and pricing.', @(
        @('FR-10 Manage pricing rules (per trip / per km)', 'Must', 'Izzan'))),
    @('UI-09 Assign van & driver', 'Assign a van and driver to a booking.', @(
        @('FR-20 Assign a driver and van to a booking with no clashes', 'Must', 'Vickson'))),
    @('UI-10 Income & salary', 'Income summary, ledger and driver salaries.', @(
        @('FR-30 Record income per trip and calculate driver salary', 'Must', 'Vickson'))),
    @('UI-11 Booking review', 'Verify documents and deposit, then confirm the booking.', @(
        @('UI-11: Verify documents and deposit, then confirm (add FR ID in SRS)', 'Must', 'Izzat')))
)

Write-Host "`n== Screen issues (M2) and requirement sub-issues (M3)" -ForegroundColor Cyan
foreach ($s in $screens) {
    $parent = New-Issue $s[0] "$($s[1])`n`nClickable prototype screen is done (see src/). Real implementation is tracked in the sub-issues." 'M2' $null $null
    # PowerShell flattens a list holding a single sub-issue into that sub-issue's
    # fields, so wrap it back into a list of one.
    $subs = $s[2]
    if ($subs[0] -is [string]) { $subs = ,$subs }
    foreach ($fr in $subs) {
        $child = New-Issue $fr[0] "Sub-issue of #$parent. Priority and owner from Proposal v1.0 (Tables 5 and 9)." 'M3' $fr[1] $fr[2]
        Add-SubIssue $parent $child
    }
}

Write-Host "`n== Testing, documents and process issues" -ForegroundColor Cyan
$process = @(
    @('Test plan and LOGTEST: 50+ test cases, 60%+ coverage', 'M3', 'Bryan'),
    @('CI/CD: GitHub Actions, secret scan, required PR checks', 'M2', 'Bryan'),
    @('Proposal (docs/Proposal)', 'M1', 'Romeo'),
    @('SRS (docs/SRS)', 'M2', 'Izzan'),
    @('Slides and demo video (docs/Slides)', 'M2', 'Romeo'),
    @('SDD (docs/SDS)', 'M3', 'Izzat'),
    @('STD (docs/STD)', 'M3', 'Bryan'),
    @('Keep process_forms/LOGAI.md up to date', 'M4', 'Vickson')
)
foreach ($p in $process) { New-Issue $p[0] 'Course deliverable. See docs/README.md.' $p[1] 'documentation' $p[2] | Out-Null }

Write-Host "`nDone. Open https://github.com/$repo/issues to check." -ForegroundColor Green

