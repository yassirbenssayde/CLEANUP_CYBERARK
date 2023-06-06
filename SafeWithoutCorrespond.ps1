######################################################################################################################
#Ce script a pour but de lister tous les coffres qui commence par safe- n'ayannt pas de membre correspondant au coffre
$safes = Get-PASSafe

foreach ($safe in $safes) {
    if ($safe.SafeName -like "safe-*") {
        $vaultName = $safe.SafeName.Replace("-", ".")
        $vaultNameParts = $vaultName.Split('.')
        $partToKeep = $vaultNameParts[1] + '.' + $vaultNameParts[2]

        #Récupérer les membres des coffres 
        $members = Get-PASSafeMember -SafeName $safe.SafeName
        #vérifier si un membre correspondant à $partToKeep est présent
        $hasMatchingMember = $members | Where-Object { $_.MemberName -eq $partToKeep }
        #Si aucun membre correspondant n'est trouvé 
        if (-not $hasMatchingMember) {
            Write-Host "Le coffre $($safe.SafeName) peut être supprimé"
        }
    }
}
#######################################################################################################################