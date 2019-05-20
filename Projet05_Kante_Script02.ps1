Import-Module ActiveDirectory
Set-ExecutionPolicy Unrestricted

$ngroup= Read-Host "Entrez le nom du groupe"
#récupère le nom du groupe , liste ses membres et écrit le résultat dans le répertoire sur un fichier .txt.
Get-ADGroupMember -Identity $ngroup | Out-File C:\Users\Administrateur\Desktop\MonPremierRepo\Script_ps\Script02\Projet05_Kante_AD02.txt
echo "terminé"