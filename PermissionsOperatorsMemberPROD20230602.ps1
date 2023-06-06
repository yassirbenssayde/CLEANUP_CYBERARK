# Import module psPAS
Import-Module psPAS









################# Script qui permet de vérifier si le groupe "operators" a tous les droits sur tous les coffres #################

# Récupérer la liste des coffres
$safes = Get-PASSafe
# Initialiser le tableau de résultat
$result = @() 
# Parcourir chaque coffre
foreach ($safe in $safes) {
    # Vérifier si le nom du coffre correspond au modèle "safe-*"
    if ($safe.SafeName -like "safe-*") {

        $Operatormembers = Get-PASSafeMember -SafeName $safe.SafeName -MemberName operators

            foreach ($operatorMember in $operatorMembers) {
                 # Parcourir les membres du coffre
                    $safeInfo = [PSCustomObject]@{
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
                        ViewAuditLog = $operatorMember.Permissions.viewAuditLog 
                        ViewSafeMembers= $operatorMember.Permissions.viewSafeMembers 
                        RequestsAuthorizationLevel1= $operatorMember.Permissions.requestsAuthorizationLevel1 
                        RequestsAuthorizationLevel2= $operatorMember.Permissions.requestsAuthorizationLevel2 
                        AccessWithoutConfirmation= $operatorMember.Permissions.accessWithoutConfirmation 
                        createFolders= $operatorMember.Permissions.createFolders 
                        DeleteFolders= $operatorMember.Permissions.deleteFolders 
                        MoveAccountsAndFolders= $operatorMember.Permissions.moveAccountsAndFolders        
                    }
                    $result += $safeInfo
            }
     }
}
# Exporter le tableau de résultat vers un fichier CSV avec la date dans le nom du fichier
$csvFileName = "D:\Test\PermissionsOperatorsPROD$date.csv"
$result | Export-Csv -Path $csvFileName -NoTypeInformation

###########################################################################################################################