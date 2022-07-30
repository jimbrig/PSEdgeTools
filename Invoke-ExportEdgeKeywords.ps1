# Install / Ensure have sqlite3 executable
If (!(Get-Command sqlite3)) {
	scoop install sqlite
}

# Create sql_script.sql
If (!(Test-Path "$PWD\bin\sql_export_script.sql")) {
	$SqlScriptPath = "$PWD\bin\sql_export_script.sql"
	New-Item -ItemType File -Path $SqlScriptPath
	$SqlScriptPath = Convert-Path $SqlScriptPath
	Write-Output '.output EdgeKeywords.sql' > $SqlScriptPath
	Write-Output '.dump keywords' >> $SqlScriptPath
}

$SqlScriptPath = (Convert-Path $PWD\bin\sql_export_script.sql)

# Copy Web Data - Edge (Default)
If (Test-Path "$PWD\temp\Edge\Web Data") {
	Remove-Item -Path "$PWD\temp\Edge\Web Data" -Force
}

$EdgeWebDataFilePath = (Convert-Path "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Web Data")
$Destination = "$PWD\temp\Edge\Web Data"
Copy-Item $EdgeWebDataFilePath $Destination

# Copy Web Data - Edge (Canary)

If (Test-Path "$PWD\temp\EdgeCanary\Web Data") {
	Remove-Item -Path "$PWD\temp\EdgeCanary\Web Data" -Force
} 

If (!(Test-Path "$PWD\temp\EdgeCanary")) {
	New-Item -ItemType Directory -Path "$PWD\temp\EdgeCanary"
}

$EdgeCancaryWebDataFilePath = (Convert-Path "$env:LOCALAPPDATA\Microsoft\Edge SxS\User Data\Default\Web Data")
$CanaryDestination = "$PWD\temp\EdgeCanary\Web Data"
Copy-Item $EdgeCancaryWebDataFilePath $CanaryDestination -Force

# Set Database (Default)
$Database = $Destination

# Set Database (Canary)
$DatabaseCanary = $CanaryDestination

# Export keywords from database to sql file
If (Test-Path "$PWD\output\EdgeKeywords.sql") {
	Move-Item "$PWD\output\EdgeKeywords.sql" "$PWD\output\EdgeKeywords.sql.bak" -Force
}

$OutputFile = "$PWD\output\Edge\EdgeKeywords.sql"
$OutputFileCanary = "$PWD\output\EdgeCanary\EdgeKeywords.sql"
sqlite3.exe -init $SqlScriptPath $Database .exit
Move-Item "$PWD\EdgeKeywords.sql" $OutputFile -Force

sqlite3.exe -init $SqlScriptPath $DatabaseCanary .exit
Move-Item "$PWD\EdgeKeywords.sql" $OutputFileCanary -Force

# Move output

Move-Item "$PWD\EdgeCanary\EdgeKeywords.sql" $OutputFileCanary -Force

# Cleanup
Remove-Item "$PWD\temp\Web Data"

# View
bat output\Edge\EdgeKeywords.sql