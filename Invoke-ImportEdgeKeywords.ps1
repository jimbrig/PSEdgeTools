# Install / Ensure have sqlite3 executable
If (!(Get-Command sqlite3)) {
	scoop install sqlite
}

# Ensure Edge is not running:
$EdgeRunning = (((Get-Process -Name *msedge*).ProcessName).Count -gt 0)
If ($EdgeRunning) {
	$answer = Read-Host "Edge must be closed before proceeding, close? (y/n)"
	If ($answer -eq 'y') {
		Stop-Process -Name *msedge* -Force
	} else {
		throw "Quitting.."
	}
}

$answer = Read-Host "[NOTE] This will overwrite your Micrsoft Edge search engines, are you sure you want to continue? (y/n)"
If ($answer -ne 'y') {
	throw "Quitting..."
}

$SqlScriptPath = (Convert-Path "$PWD\bin\sql_import_script.sql")

$EdgeWebDataFilePath = (Convert-Path "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Web Data")
$EdgeCanaryWebDataFilePath = (Convert-Path "$env:LOCALAPPDATA\Microsoft\Edge SxS\User Data\Default\Web Data")

# Set Database
$Database = $EdgeWebDataFilePath
$DatabaseCanary = $EdgeCanaryWebDataFilePath

# Import keywords to database
sqlite3.exe -init $SqlScriptPath $Database .exit
sqlite3.exe -init $SqlScriptPath $DatabaseCanary .exit
