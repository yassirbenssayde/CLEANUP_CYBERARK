#####################################################################################################
#Lister tous les coffres vides n'ayant pas d'utilisateurs actifs.
$safes = Get-PASSafe
## création foreach
$emptySafes = foreach ($safe in $safes) {
## filtrer les coffres commencant par safe-
    if ($safe.SafeName -like "safe-*") {
## lister les comptes du coffre de la boucle
    $accounts = Get-PASAccount -SafeName $safe.SafeName
## filtrer les coffres n'ayant aucun compte
    if ($accounts.Count -eq 0) {
        $safe.SafeName
    }
  }
}
$results = foreach ($safeName in $emptySafes) {
## Lister des membres du coffre $safeName
    $members = Get-PASSafeMember -SafeName $safeName
    foreach ($member in $members) {
## Obtenir les informations de l'utilisateur associé à $member.MemberName
    $users = Get-PASUser -UserName $member.MemberName
## Création d'un objet personnalisé [PSCustomObject] 
        [PSCustomObject]@{
           UserName = $member.MemberName
           SafeName = $memberName
           CPM = $safe.manssagingCPM
           Source = $users.source
           UserType = $users.userType
           Location = $users.location
        }
    }
}
## Affichage du contenu de la variable $users  
Write-Host $users

$results | Export-Csv -Path "D:\Test\EmptySafeMembersPROD.csv" -NoTypeInformation
######################################################################################################