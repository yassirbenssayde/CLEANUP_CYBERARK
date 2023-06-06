# Import module psPAS
Import-Module psPAS

$password = ConvertTo-SecureString '' -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ('', $password)
New-PASSession -Credential $cred -BaseURI https://bcnvsrv462.bouygues-construction.com/passwordvault/




############################## Lister les coffres vides et les informations de l’utilisateur associé pour chaque membre  ################################
## Lister tous les coffres
$safes = Get-PASSafe

## Création d'une boucle foreach pour chaque coffre
$emptySafes = foreach ($safe in $safes) {
    ## Filtrer les coffres commençant par "safe-"
    if ($safe.SafeName -like "safe-*") {
        ## Obtenir la liste des comptes du coffre actuel
        $accounts = Get-PASAccount -SafeName $safe.SafeName
        
        ## Filtrer les coffres n'ayant aucun compte
        if ($accounts.Count -eq 0) {
            # Ajouter le nom du coffre à la liste des coffres vides
            $safe.SafeName
        }
    }
}

## Création d'une liste de résultats pour chaque coffre vide
$results = foreach ($safeName in $emptySafes) {
    ## Obtenir les membres du coffre $safeName
    $members = Get-PASSafeMember -SafeName $safeName
    
    ## Pour chaque membre, obtenir les informations de l'utilisateur associé
    foreach ($member in $members) {
        ## Obtenir les informations de l'utilisateur associé à $member.MemberName
        $users = Get-PASUser -UserName $member.MemberName
        
        ## Création d'un objet personnalisé [PSCustomObject] contenant les informations
        [PSCustomObject]@{
            UserName = $member.MemberName
            SafeName = $safeName
            CPM = $safe.manssagingCPM
            Source = $users.source
            UserType = $users.userType
            Location = $users.location
        }
    }
}

## Affichage du contenu de la variable $users
Write-Host $users

## Exportation des résultats vers un fichier CSV
$results | Export-Csv -Path "D:\Test\EmptySafeMembersPROD.csv" -NoTypeInformation

#############################################################################################################################################################