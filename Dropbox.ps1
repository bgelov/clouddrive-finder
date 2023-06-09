[string]$compName = $env:COMPUTERNAME
[string]$userName = $env:USERNAME
[string]$user_comp = "$userName;$compName;"
[string]$last_email = ""
[string]$email = ""
[string]$path = ""
[string]$result = $user_comp


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