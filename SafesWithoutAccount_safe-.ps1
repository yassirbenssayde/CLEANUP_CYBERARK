###############################################################################################
#Méthode1: Affiche les coffres qui commence par "Safe-" et ne contient pas de compte. 
$safes = Get-PASSafe
$emptyVaults = foreach ($safe in $safes) {
    if ($safe.SafeName -like "safe-*") {
        $accounts = Get-PASAccount -SafeName $safe.SafeName
        if ($accounts.Count -eq 0) {
            $safe
        }
    }
}
$emptyVaults
###############################################################################################

################################################################################################################################
#Méthode2: Affiche les coffres qui commence par "Safe-" et ne contient pas de compte. 
$emptyVaults = Get-PASSafe | Where-Object { $_.SafeName -like "safe-*" -and (Get-PASAccount -SafeName $_.SafeName).Count -eq 0 }
$emptyVaults
################################################################################################################################