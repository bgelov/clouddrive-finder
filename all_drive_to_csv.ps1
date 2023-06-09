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


# Google disk
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

# Dropbox
if (Test-Path "$env:LOCALAPPDATA\Dropbox" -ErrorAction SilentlyContinue) { 
    
    $result += "Dropbox installed;" 
    if (Test-Path "$env:LOCALAPPDATA\Dropbox\info.json" -ErrorAction SilentlyContinue) { 

        $DropBox = (Get-Content "$env:LOCALAPPDATA\Dropbox\info.json" | Out-String | ConvertFrom-Json).personal | select path,subscription_type 
        if ($DropBox) {
            $result += ";" #email 
            $path = $DropBox.path
            $subscription_type = $DropBox.subscription_type
            $result += "$path;"
            $result += "Dropbox is used. Subscription Type: $subscription_type;"
         }

        } else { $result += ";;Dropbox not configured;" } 

} else { $result += "Dropbox not installed;;;;" } 


$result > "\\fileserver\$compName-$userName.txt"