###############################################################################################
#Affiche tous les coffres qui ne contient pas de compte. 
$safes = Get-PASSafe
$emptyVaults = foreach ($safe in $safes) {
    $accounts = Get-PASAccount -SafeName $safe.SafeNamess
    if ($accounts.Count -eq 0) {
        $safe
    }
}
$emptyVaults
###############################################################################################