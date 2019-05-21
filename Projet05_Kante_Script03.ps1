Import-module ActiveDirectory
 
$nomuser = Read-Host "Entrez le nom de l'utilisateur AD:"
#recupere la liste des groupes dont est membre un utilisateur
Get-ADPrincipalGroupMembership -Identity $nomuser | Out-File C:\Users\Administrateur\Desktop\MonPremierRepo\Script_ps\Script03\Projet05_Kante_AD03.txt