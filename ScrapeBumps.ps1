# folder to store bumps (feel free to change this)
$bumpFolder = "$env:USERPROFILE\Desktop\Bumps"

# required page urls
$pageUrl = "https://www.bumpworthy.com/bumps"
$downloadUrl = "https://www.bumpworthy.com/download/video"

# this is roughly how many videos there are URLs for! its not exact...bitch.
[int]$totalVids = 8748

# turn off the progress bar for faster downloads
$ProgressPreference = 'SilentlyContinue'

# make folder to store bumps on desktop if it doesnt exist
if(!(Test-Path -Path $bumpFolder))
{
    Write-Host "--------------------------------------------------------------------------------"
    Write-Host -nonewline "Making folder on desktop to store bumps...please wait..."
    New-Item -ItemType Directory -Path "$bumpFolder" | Out-Null
    Write-Host "DONE"
}
 # open the folder to show where bumps are being downloaded
 Start-Process $downloadFolder

for ($num = 1 ; $num -le $totalVids ; $num++)
{
    $errorFlag = $false

    # scrape video title
    $title = ((invoke-webrequest -Uri "$($pageUrl)/$($num)").content -match "<title>(.*) \| BumpWorthy.com" | % {$matches[1]}).replace(" ","_")

    # sanitize non-character letters from title
    $cleanTitle = $title -replace '\W',''

    # output video number, name, and progress
    write-Host -nonewline "downloading video $num - " -ForegroundColor Cyan
    write-Host -nonewline "$title" -ForegroundColor Yellow
    write-Host -nonewline " - Please Wait..." -ForegroundColor Cyan

    # attempt download of video file, output results
    try{Invoke-WebRequest -Uri "$($downloadUrl)/$($num)" -OutFile "$($bumpFolder)\$($cleanTitle).mp4"}
    catch{Write-Host "FAILED" -ForegroundColor Red; $errorFlag = $true}
    if(!$errorFlag){write-Host "DONE" -ForegroundColor Green}

    Write-Host "Finished downloading bumps" -ForegroundColor Yellow
}

