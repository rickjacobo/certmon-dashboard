Do {

$MySqlHostname  = $env:ENV_SQL_HOSTNAME
$MySqlUserName  = $env:ENV_SQL_USERNAME
$MySqlPassword  = $env:ENV_SQL_PASSWORD
$MySqlDatabase  = $env:ENV_SQL_DATABASE
$MySqlTable     = $env:ENV_SQL_TABLE

$SQL = @"
mysql -h $MySqlHostname -u $MySqlUserName -p$MySqlPassword $MySQLDatabase -e "SELECT * FROM $MySqlTable ORDER BY status DESC, url ASC ;" 2>/dev/null | ConvertFrom-Csv -delimiter ``t
"@

$SQL = Invoke-Expression $SQL 
$SQL | Select url,@{n="expires";e={[int]($_.daysuntilexpiration)}},status,lastupdate_utc | Sort-Object expires | Export-CSV query.csv -Force

$Head = @"
<meta http-equiv="refresh" content="30">
"@

Import-csv ./query.csv | ConvertTo-Html -Title Status -Head $Head | Out-File /powershell/html/status/index.html -Force
Import-csv ./query.csv | where status -eq "OK" | ConvertTo-Html -Title Status -Head $Head | Out-File /powershell/html/status/ok/index.html -Force
Import-csv ./query.csv | where status -eq "Replace" | ConvertTo-Html -Title Status -Head $Head | Out-File /powershell/html/status/replace/index.html -Force

Import-csv ./query.csv | ConvertTo-Json | out-file /powershell/html/api/v1/status/index.html -Force

if ( (Test-Path /usr/local/apache2/htdocs/) ) {
    cp -R ./html/* /usr/local/apache2/htdocs/
}

Start-Sleep -S 3600
} While ("1" -eq "1")
