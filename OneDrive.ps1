[string]$compName = $env:COMPUTERNAME
[string]$userName = $env:USERNAME
[string]$user_comp = "$userName;$compName;"
[string]$last_email = ""
[string]$email = ""
[string]$path = ""
[string]$result = $user_comp


# OneDrive
$regpath = 'HKCU:\SOFTWARE\Microsoft\OneDrive\Accounts\Personal'
if (Get-ItemProperty $regpath -ErrorAction SilentlyContinue) { 

    $result += "OneDrive installed;"
    $email = Get-ItemPropertyValue $regpath -Name UserEmail -ErrorAction SilentlyContinue
    $path = Get-ItemPropertyValue $regpath -Name UserFolder -ErrorAction SilentlyContinue
    if ($email) { $result += "$email;" } else { $result += "E-mail not configured;" }
    if ($path) { $result += "$path;" } else { $result += "Path not configured;" }
    if (($email) -and ($path)) { $result += "OneDrive is used;"} elseif (($email) -and !($path)) { $result += "OneDrive was once configured;"} else { $result += "OneDrive not used;"}
    
    } else { $result += "OneDrive not installed;;;;" } 

[string]$email = ""
[string]$path = ""
$result += "`n$user_comp"

$result > "\\fileserver\$compName-$userName.txt"