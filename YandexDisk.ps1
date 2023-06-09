[string]$compName = $env:COMPUTERNAME
[string]$userName = $env:USERNAME
[string]$user_comp = "$userName;$compName;"
[string]$last_email = ""
[string]$email = ""
[string]$path = ""
[string]$result = $user_comp


# YandexDisk
$regpath = 'HKCU:\SOFTWARE\Yandex\Yandex.Disk'
if (Get-ItemProperty $regpath -ErrorAction SilentlyContinue) { 
    
    $result += "Yandex.Disk installed;"
    [xml]$xmlfile = Get-Content "$env:LOCALAPPDATA\Yandex\Yandex.Disk\config.xml"
    if ($xmlfile."Yandex.Disk".User.Login) {
        $email = $xmlfile."Yandex.Disk".User.Login + "@yandex.ru"
        $result += "$email;" } else { $result += "E-mail not configured;" }
    $path = Get-ItemPropertyValue $regpath -Name RootFodler -ErrorAction SilentlyContinue
    if ($path) { $result += "$path;"} else { $result += "Path not configured;" }
    $last_email = $xmlfile."Yandex.Disk".User.LastLogin + "@yandex.ru"
    if ((($email) -and !($last_email)) -or (($email) -and ($last_email)))  { $result += "Yandex.Disk is used;"} elseif (!($email) -and ($last_email)) { $result += "Yandex.Disk was once configured ($last_email);"}
    
    } else { $result += "Yandex.Disk not installed;;;;" } 

[string]$email = ""
[string]$path = ""
$result += "`n$user_comp"

$result > "\\fileserver\$compName-$userName.txt"