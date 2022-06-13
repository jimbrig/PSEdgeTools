# Install / Ensure have sqlite3 executable
If (!(Get-Command sqlite3)) {
	scoop install sqlite
}

# Create sql_script.sql
If (!(Test-Path "$PWD\bin\sql_export_script.sql")) {
	$SqlScriptPath = "$PWD\bin\sql_export_script.sql"
	New-Item -ItemType File -Path $SqlScriptPath
	$SqlScriptPath = Convert-Path $SqlScriptPath
	echo '.output EdgeKeywords.sql' > $SqlScriptPath
	echo '.dump keywords' >> $SqlScriptPath
}

$SqlScriptPath = (Convert-Path $PWD\bin\sql_export_script.sql)

# Copy Web Data
If (Test-Path "$PWD\temp\Web Data") {
	Remove-Item -Path "$PWD\temp\Web Data" -Force
}

$EdgeWebDataFilePath = (Convert-Path "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Web Data")
$Destination = "$PWD\temp\Web Data"
Copy-Item $EdgeWebDataFilePath $Destination

# Set Database
$Database = $Destination

# Export keywords from database to sql file
If (Test-Path "$PWD\output\EdgeKeywords.sql") {
	Move-Item "$PWD\output\EdgeKeywords.sql" "$PWD\output\EdgeKeywords.sql.bak" -Force
}

$OutputFile = "$PWD\output\EdgeKeywords.sql"
sqlite3.exe -init $SqlScriptPath $Database .exit

# Move output
Move-Item "$PWD\EdgeKeywords.sql" "$PWD\output\EdgeKeywords.sql" -Force

# Cleanup
Remove-Item "$PWD\temp\Web Data"

# View
bat output\EdgeKeywords.sql