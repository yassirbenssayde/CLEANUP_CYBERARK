###############################################################################################
#Lister les utilisateurs des coffres vides et les extraire dans un fichier CSV
$safes = Get-PASSafe
$emptySafes = foreach ($safe in $safes) {
    $accounts = Get-PASAccount -SafeName $safe.SafeName
    if ($accounts.Count -eq 0) {
        $safe.SafeName
    }
}
$safeMember = foreach ($safeName in $emptySafes) {
    Get-PASSafeMember -SafeName $safeName
}
$safeMember | Export-Csv -Path "D:\Test\EmptySafeMembers20230517.csv" -NoTypeInformation
###############################################################################################