[string]$compName = $env:COMPUTERNAME
[string]$userName = $env:USERNAME
[string]$user_comp = "$userName;$compName;"
[string]$last_email = ""
[string]$email = ""
[string]$path = ""
[string]$result = $user_comp


# Mail.Ru Cloud
$regpath = 'HKCU:\SOFTWARE\Mail.Ru\Mail.Ru_Cloud'
if (Get-ItemProperty $regpath -ErrorAction SilentlyContinue) { 
    
    $result += "Mail.Ru Cloud installed;"
    $email = Get-ItemPropertyValue $regpath -Name email -ErrorAction SilentlyContinue
    if ($email) { $result += "$email;"} else { $result += "E-mail not configured;" }
    $path = (Get-ItemProperty $regpath | foreach { $_.PSObject.Properties } | select name, value | where { $_.Name -match "^folder_" }).Value -replace '/','\'
    if ($path) { $result += "$path;"} else { $result += "Path not configured;" }
    if ((Get-ItemProperty $regpath | foreach { $_.PSObject.Properties } | select name | where { $_.Name -match "refreshToken" }).Name) { $result += "Mail.Ru Cloud is used;" } else { $result += "Mail.Ru Cloud was once configured;"} 

    } else { $result += "Mail.Ru Cloud not installed;;;;" }

[string]$email = ""
[string]$path = ""
$result += "`n$user_comp"

$result > "\\fileserver\$compName-$userName.txt"