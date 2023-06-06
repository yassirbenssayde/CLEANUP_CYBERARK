# Import module psPAS
Import-Module psPAS

New-PASSession -Credential $cred -BaseURI https://bcnvsrv462.bouygues-construction.com/passwordvault/




##################### Lister tous les droits des membres (inclut groupe : operators) de chaque coffre ########

## Récupérer la liste des coffres
$safes = Get-PASSafe
# Initialiser le tableau de résultat
$result = @() 
# Parcourir chaque coffre
foreach ($safe in $safes) {
    # Vérifier si le nom du coffre correspond au modèle "safe-*"
    if ($safe.SafeName -like "safe-*") {
        # Modifier le nom du coffre en remplaçant les tirets par des points
        $vaultName = $safe.SafeName.Replace("-", ".")
        $vaultNameParts = $vaultName.Split('.')
        $partToKeep = '.' + $vaultNameParts[2]
        
        # Récupérer les membres des coffres
        $members = Get-PASSafeMember -SafeName $safe.SafeName
        # Récuperer les droits du groupe operators 
        $OperatorMember = Get-PASSafeMember -SafeName $safe.SafeName -MemberName operators

        # Vérifier si un membre contenant $partToKeep est présent
        $hasMatchingMember = $members | Where-Object { $_.MemberName -like "*$partToKeep*" } 
        
        if ($hasMatchingMember) {
             $operatorInfo = [PSCustomObject]@{
                        SafeName = $safe.SafeName
                        Owners = $operatorMember.MemberName
                        UseAccounts = $operatorMember.Permissions.useAccounts 
                        RetrieveAccounts = $operatorMember.Permissions.RetrieveAccounts 
                        ListAccounts = $operatorMember.Permissions.ListAccounts 
                        AddAccounts = $operatorMember.Permissions.AddAccounts 
                        UpdateAccountContent = $operatorMember.Permissions.UpdateAccountContent 
                        UpdateAccountProperties = $operatorMember.Permissions.UpdateAccountProperties 
                        InitiateCPMAccountManagementOperations = $operatorMember.Permissions.InitiateCPMAccountManagementOperations 
                        SpecifyNextAccountContent = $operatorMember.Permissions.specifyNextAccountContent 
                        RenameAccounts = $operatorMember.Permissions.renameAccounts 
                        DeleteAccounts = $operatorMember.Permissions.deleteAccounts 
                        UnlockAccounts = $operatorMember.Permissions.unlockAccounts 
                        ManageSafe = $operatorMember.Permissions.manageSafe 
                        ManageSafeMembers = $operatorMember.Permissions.manageSafeMembers 
                        BackupSafe = $operatorMember.Permissions.backupSafe 
                        viewAuditLog = $operatorMember.Permissions.viewAuditLog 
                        viewSafeMembers= $operatorMember.Permissions.viewSafeMembers 
                        requestsAuthorizationLevel1= $operatorMember.Permissions.requestsAuthorizationLevel1 
                        RequestsAuthorizationLevel2= $operatorMember.Permissions.requestsAuthorizationLevel2 
                        AccessWithoutConfirmation= $operatorMember.Permissions.accessWithoutConfirmation 
                        CreateFolders= $operatorMember.Permissions.createFolders 
                        DeleteFolders= $operatorMember.Permissions.deleteFolders 
                        MoveAccountsAndFolders= $operatorMember.Permissions.moveAccountsAndFolders
            }
              $result += $operatorInfo
            # Parcourir chaque membre du coffre
            foreach ($member in $members) {
                    # Parcourir les autres membres du coffre
                    $safeInfo = [PSCustomObject]@{
                        SafeName = $safe.SafeName
                        Owners = $member.MemberName
                        UseAccounts = $member.Permissions.useAccounts 
                        RetrieveAccounts = $member.Permissions.RetrieveAccounts 
                        ListAccounts = $member.Permissions.ListAccounts 
                        AddAccounts = $member.Permissions.AddAccounts 
                        UpdateAccountContent = $member.Permissions.UpdateAccountContent 
                        UpdateAccountProperties = $member.Permissions.UpdateAccountProperties 
                        InitiateCPMAccountManagementOperations = $member.Permissions.InitiateCPMAccountManagementOperations 
                        SpecifyNextAccountContent = $member.Permissions.specifyNextAccountContent 
                        RenameAccounts = $member.Permissions.renameAccounts 
                        DeleteAccounts = $member.Permissions.deleteAccounts 
                        UnlockAccounts = $member.Permissions.unlockAccounts 
                        ManageSafe = $member.Permissions.manageSafe 
                        ManageSafeMembers = $member.Permissions.manageSafeMembers 
                        BackupSafe = $member.Permissions.backupSafe 
                        ViewAuditLog = $member.Permissions.viewAuditLog 
                        ViewSafeMembers= $member.Permissions.viewSafeMembers 
                        RequestsAuthorizationLevel1= $member.Permissions.requestsAuthorizationLevel1 
                        RequestsAuthorizationLevel2= $member.Permissions.requestsAuthorizationLevel2 
                        AccessWithoutConfirmation= $member.Permissions.accessWithoutConfirmation 
                        CreateFolders= $member.Permissions.createFolders 
                        DeleteFolders= $member.Permissions.deleteFolders 
                        MoveAccountsAndFolders= $member.Permissions.moveAccountsAndFolders
                    }
                    $result += $safeInfo
            }
        }
    }
}
# Exporter le tableau de résultat vers un fichier CSV
$result | Export-Csv -Path "C:\Temp\PermissionsOperatorsPRÉPROD20230601.csv" -NoTypeInformation

#########################################################################################################




