Import-Module ActiveDirectory
Set-ExecutionPolicy Unrestricted

# demande des informations pour le nouvel utilisateur

$leprenom=Read-Host "entrez le prénom de l'utilisateur"
$lesurnom=Read-Host "entrez le surnom de l'utilisateur"
$grputilisateur=Read-Host "entrez le nom de son groupe d'utilisateur"

#attribution de l'unite d'organisation en fonction du groupe
switch ($grputilisateur)
{
    "Acceuil" {$leou ="Acceuil" ; break}
    "Financière" {$leou ="Direction financière"; break}
    "Assistant dg" {$leou ="Direction Général"; break}
    "Directeur général" {$leou ="Direction Général"; break}
    "Marketing" {$leou ="Responsables,OU=Direction marketing"; break}
    "Stagiaire" {$leou ="Stagiaire,OU=Direction marketing"; break}
    "Ressources humaines" {$leou ="Direction ressources humaines"; break}
    "Technique" {$leou ="Direction technique"; break}
    default {""; break}
}

#definition du mot de passe par défaut
$defaultmdp = "Openclassrooms@78"
$mdpsecure= ConvertTo-SecureString $defaultmdp -AsPlainText -Force

# definition du nom d'utilisateur
$lenom= "$leprenom $lesurnom"


#emplacement ldap de l'objet utilisateur ad
$path="OU=$leou,OU=Acme group,DC=acme,DC=fr"
$nomducompte= "$leprenom.$lesurnom"

New-Item -Name $lenom -ItemType Directory -Path E:\Shares\aduser
$pathhd="E:\Shares\aduser\$lenom"
#creation de l'utilisateur ad
New-ADUser -GivenName $leprenom -Surname $lesurnom -SamAccountName $nomducompte -Name $lenom -Path $path -AccountPassword $mdpsecure -UserPrincipalName "$nomducompte@acme.fr" -HomeDirectory $pathhd -Enabled $true 
Add-ADGroupMember -Identity $grputilisateur -Members $nomducompte 

$Userad= Get-ADUser -Identity $nomducompte
#on recupere les proprietés des droits du dossier
$acl = Get-Acl $pathhd
#on cree nos regles
$FileSystemRights= [System.Security.AccessControl.FileSystemRights]"Modify, Read "
$PropagationFlags= [System.Security.AccessControl.PropagationFlags]"InheritOnly"
$InheritanceFlags= [System.Security.AccessControl.InheritanceFlags]"ContainerInherit, ObjectInherit"
$AccesControlType= [System.Security.AccessControl.AccessControlType]::Allow


$AccesRule= New-Object System.Security.AccessControl.FileSystemAccessRule ($Userad.SID, $FileSystemRights, $InheritanceFlags, $PropagationFlags, $AccesControlType)
$acl.AddAccessRule($AccesRule) 
#on applique les règls au dossier
Set-Acl -Path $pathhd -AclObject $acl -ea Stop
#on désactive l'hérédité des règles pour pouvoir les supprimer au besoins
$acl.SetAccessRuleProtection($true,$true)

$acl |Set-Acl


echo "terminé"