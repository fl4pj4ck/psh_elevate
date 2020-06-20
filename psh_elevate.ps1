#Borrowed from https://community.spiceworks.com/scripts/show/2980-self-elevate-powershell-script
#Define Admin Account
#please note that this is not an ideal way to run things as admin, it is not reccomended to store passwords in scripts
#
$Username = 'username'
$Password = 'plain text password'
$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($Username, $SecurePassword)
# Admin Account end

function IsAdministrator
{
    $Identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $Principal = New-Object System.Security.Principal.WindowsPrincipal($Identity)
    $Principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

function IsUacEnabled
{
    (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System).EnableLua -ne 0
}

#If user is admin
if (IsAdministrator)
{
#Paste your code here

}

#Elevation Script here
if (!(IsAdministrator)) 
{	Write-Host "I am not admin"
    if (IsUacEnabled)
    {
		 Start-Process Powershell.exe -Credential $Credential -NoNewWindow -ArgumentList "Start-Process Powershell.exe $PSCommandPath -Verb Runas"
		 exit 0
    }
    else
    {
        throw "You must be administrator to run this script"
    }
}