# Import module psPAS
Import-Module psPAS





################# Script qui permet de vérifier si tous les coffres ont la même configuration #################

# Récupérer la liste des coffres
$safes = Get-PASSafe
# Initialiser le tableau de résultat
$result = @() 
# Générer la date du fichier CSV
$date = Get-Date -Format "yyyyMMdd"

# Parcourir chaque coffre
foreach ($safe in $safes) {
    # Vérifier si le nom du coffre correspond au modèle "safe-*"
    if ($safe.SafeName -like "safe-*") {
        # Vérifier si le coffre existe déjà dans le tableau de résultats
        $existingSafe = $result | Where-Object { $_.SafeName -eq $safe.SafeName }
        if ($existingSafe -eq $null) {
            $operatorInfo = [PSCustomObject]@{
                SafeName = $safe.SafeName
                SafeNumber = $safe.safeNumber
                Description = $safe.description
                Creatorid = $safe.creator.id
                Creatorname = $safe.creator.name
                OlacEnabled = $safe.olacEnabled
                ManagingCPM = $safe.managingCPM
                NumberOfVersionsRetention = $safe.numberOfVersionsRetention
                NumberOfDaysRetention = $safe.numberOfDaysRetention
                AutoPurgeEnabled = $safe.autoPurgeEnabled
                CreationTime = $safe.creationTime 
                LastModificationTime = $safe.lastModificationTime
                IsExpiredMember = $safe.isExpiredMember
                Date = $date
            } 
            # Ajouter le coffre au tableau de résultats
            $result += $operatorInfo
        }
    }
}
# Exporter le tableau de résultats vers un fichier CSV avec la date dans le nom du fichier
$csvFileName = "C:\Temp\ConfigurationSafesPROD$date.csv"
$result | Export-Csv -Path $csvFileName -NoTypeInformation

################################################################################################################