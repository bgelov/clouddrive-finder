[string]$compName = $env:COMPUTERNAME
[string]$userName = $env:USERNAME
[string]$user_comp = "$userName;$compName;"
[string]$last_email = ""
[string]$email = ""
[string]$path = ""
[string]$result = $user_comp


# Google Drive
$regpath = 'HKCU:\SOFTWARE\Google\Drive'
if (Get-ItemProperty $regpath -ErrorAction SilentlyContinue) { 
    
    $result += "Google Drive installed;"
    $path = Get-ItemPropertyValue $regpath -Name Path -ErrorAction SilentlyContinue
    $result += ";" #email
    if ($path) { $result += "$path;"} else { $result += "Path not configured;" }
    if ((Get-ItemProperty $regpath | foreach { $_.PSObject.Properties } | select name | where { $_.Name -match "OAuthToken" }).Name) { $result += "Google Drive is used;" } else { $result += "Google Drive was once configured;"}

    } else { $result += "Google Drive not installed;;;;" } 

[string]$email = ""
[string]$path = ""
$result += "`n$user_comp"

$result > "\\fileserver\$compName-$userName.txt"