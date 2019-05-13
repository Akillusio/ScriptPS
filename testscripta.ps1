Import-Module ActiveDirectory
Import-Module ntfssecurity
$leprenom=Read-Host "entrez le prénom de l'utilisateur"
$lesurnom=Read-Host "entrez le surnom de l'utilisateur"
$defaultmdp = "Chantellie@78"
$lenom= "$leprenom $lesurnom"
$leou=Read-Host "entrez son unité d'organisation"
$path="OU=$leou,OU=Acme group,DC=acme,DC=fr"
$mdpsecure= ConvertTo-SecureString $defaultmdp -AsPlainText -Force
$nomducompte= "$leprenom.$lesurnom"
New-Item -Name $lenom -ItemType Directory -Path E:\Shares\aduser
$pathhd="E:\Shares\aduser\$lenom"

New-ADUser -GivenName $leprenom -Surname $lesurnom -SamAccountName $nomducompte -Name $lenom -Path $path -AccountPassword $mdpsecure -UserPrincipalName "$nomducompte@acme.fr" -HomeDirectory $pathhd -Enabled $true
echo "terminé"