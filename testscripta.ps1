Import-Module ActiveDirectory
Set-ExecutionPolicy Unrestricted


$leprenom=Read-Host "entrez le prénom de l'utilisateur"
$lesurnom=Read-Host "entrez le surnom de l'utilisateur"
$grputilisateur=Read-Host "entrez le nom de son groupe d'utilisateur"
$defaultmdp = "Chantellie@78"
$lenom= "$leprenom $lesurnom"
$leou=Read-Host "entrez son unité d'organisation"
$path="OU=$leou,OU=Acme group,DC=acme,DC=fr"
$mdpsecure= ConvertTo-SecureString $defaultmdp -AsPlainText -Force
$nomducompte= "$leprenom.$lesurnom"

New-Item -Name $lenom -ItemType Directory -Path E:\Shares\aduser
$pathhd="E:\Shares\aduser\$lenom"

New-ADUser -GivenName $leprenom -Surname $lesurnom -SamAccountName $nomducompte -Name $lenom -Path $path -AccountPassword $mdpsecure -UserPrincipalName "$nomducompte@acme.fr" -HomeDirectory $pathhd -Enabled $true -ProfilePath "E:\Shares\aduser\$lenom"
Add-ADGroupMember -Identity $grputilisateur -Members $nomducompte 

$Userad= Get-ADUser -Identity $nomducompte

$acl = Get-Acl $pathhd
$FileSystemRights= [System.Security.AccessControl.FileSystemRights]"Modify, Read "
$PropagationFlags= [System.Security.AccessControl.PropagationFlags]"InheritOnly"
$InheritanceFlags= [System.Security.AccessControl.InheritanceFlags]"ContainerInherit, ObjectInherit"
$AccesControlType= [System.Security.AccessControl.AccessControlType]::Allow
$shcd= acl.SetAccessRuleProtection($true,$true)
$Accesalluser1 = New-Object System.Security.AccessControl.FileSystemAccessRules("BUILTIN\Utilisateurs","

$AccesRule= New-Object System.Security.AccessControl.FileSystemAccessRule ($Userad.SID, $FileSystemRights, $InheritanceFlags, $PropagationFlags, $AccesControlType)
$acl.AddAccessRule($AccesRule)

Set-Acl -Path $pathhd -AclObject $acl -ea Stop



echo "terminé"