#####################################################################################################
#Lister les utilisateurs des coffres vides qui commence par SAFE- et les extraire dans un fichier CSV
$safes = Get-PASSafe
$emptySafes = foreach ($safe in $safes) {
   if ($safe.SafeName -like "safe-*") {
    $accounts = Get-PASAccount -SafeName $safe.SafeName
    if ($accounts.Count -eq 0) {
        $safe.SafeName
    }
  }
}
$results = foreach ($safeName in $emptySafes) {
    $members = Get-PASSafeMember -SafeName $safeName
    foreach ($member in $members) {
        [PSCustomObject]@{
            UserName = $member.MemberName
            SafeName = $SafeName
        }
    }
}
$results | Export-Csv -Path "D:\Test\EmptySafeMembers20230517.csv" -NoTypeInformation

#####################################################################################################