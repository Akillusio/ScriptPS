
$nomuser = [Environment]::UserName
$pathgen = "\\Srvdcpar001\sav"
$pathdos = "\\Srvdcpar001\sav\$nomuser"
$pathloc = "C:\Users\$nomuser"
#Je vérifie si un dossier à son nom existe deja, sinon , je le cree

If (-not (Test-Path $pathdos))
{
    New-Item -ItemType Directory -Name $nomuser -Path $pathgen
}

xcopy $pathloc $pathdos /D /E /C /R /H /I /K /Y
echo "terminé"