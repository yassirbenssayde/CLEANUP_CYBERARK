# Import module psPAS
Import-Module psPAS

$password = ConvertTo-SecureString '' -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ('', $password)
New-PASSession -Credential $cred -BaseURI https://bcnvsrv462.bouygues-construction.com/passwordvault/


# Récupérer la liste des coffres
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
        $partToKeep = $vaultNameParts[1] + '.' + $vaultNameParts[2]

        # Récupérer les membres des coffres
        $members = Get-PASSafeMember -SafeName $safe.SafeName
        # Vérifier si un membre correspondant à $partToKeep est présent
        $hasMatchingMember = $members | Where-Object { $_.MemberName -eq $partToKeep }

        # Si aucun membre correspondant n'est trouvé
        if (-not $hasMatchingMember) {
            # Lister les comptes du coffre
            $accounts = Get-PASAccount -SafeName $safe.SafeName
            if (-not $accounts) {
                # Si aucun compte n'est trouvé dans le coffre, ajouter les informations par défaut à la liste
                $accountInfo = [PSCustomObject]@{
                    Id = "NOT EXIST"
                    Address = "NOT EXIST"
                    UserName = "NOT EXIST"
                    SecretManagement_Status = "NOT EXIST"
                    SecretManagement_AutomaticManagementEnabled = "NOT EXIST"
                    SecretManagement_ManualManagementReason = "NOT EXIST"
                    SecretManagement_LastModifiedTime = "NOT EXIST"
                    SecretManagement_lastReconciledDateTime = "NOT EXIST"
                    CreatedTime = "NOT EXIST"
                }
                # Créer un objet personnalisé pour stocker les informations par défaut 
                $safeInfo = [PSCustomObject]@{
                    SafeName = $safe.SafeName
                    AccountId = $accountInfo.Id
                    AccountAdress = $accountInfo.Address
                    AccountUserName = $accountInfo.UserName
                    AccountSecretManagement_Status = $accountInfo.SecretManagement_Status
                    AccountSecretManagement_AutomaticManagementEnabled = $accountInfo.SecretManagement_AutomaticManagementEnabled
                    AccountSecretManagement_ManualManagementReason = $accountInfo.SecretManagement_ManualManagementReason
                    AccountSecretManagement_LastModifiedTime = $accountInfo.SecretManagement_LastModifiedTime
                    AccountSecretManagement_lastReconciledDateTime = $accountInfo.SecretManagement_lastReconciledDateTime
                    AccountCreatedTime = $accountInfo.CreatedTime
                    }
                $result += $safeInfo
            }
            else {
                # Parcourir chaque compte du coffre
                foreach ($account in $accounts) {
                    # S'il existe un compte dans le coffre
                    $accountInfo = [PSCustomObject]@{
                        Id = $account.Id
                        Address = $account.Address
                        UserName = $account.UserName
                        SecretManagement_Status = $account.SecretManagement.Status
                        SecretManagement_AutomaticManagementEnabled = $account.SecretManagement.AutomaticManagementEnabled
                        SecretManagement_ManualManagementReason = $account.SecretManagement.ManualManagementReason
                        SecretManagement_LastModifiedTime = $account.SecretManagement.LastModifiedTime
                        SecretManagement_lastReconciledDateTime = $account.SecretManagement.lastReconciledDateTime
                        CreatedTime = $account.CreatedTime
                    }
                    # Créer un objet personnalisé pour stocker les informations des comptes existant
                    $safeInfo = [PSCustomObject]@{
                        SafeName = $safe.SafeName
                        AccountId = $accountInfo.Id
                        AccountAdress = $accountInfo.Address
                        AccountUserName = $accountInfo.UserName
                        AccountSecretManagement_Status = $accountInfo.SecretManagement_Status
                        AccountSecretManagement_AutomaticManagementEnabled = $accountInfo.SecretManagement_AutomaticManagementEnabled
                        AccountSecretManagement_ManualManagementReason = $accountInfo.SecretManagement_ManualManagementReason
                        AccountSecretManagement_LastModifiedTime = $accountInfo.SecretManagement_LastModifiedTime
                        AccountSecretManagement_lastReconciledDateTime = $accountInfo.SecretManagement_lastReconciledDateTime
                        AccountCreatedTime = $accountInfo.CreatedTime
                    }
                    $result += $safeInfo
                }
            }
        }
    }
}

# Exporter le tableau de résultat vers un fichier CSV
$result | Export-Csv -Path "D:\Test\EmptyAccountsSafeMembersPREPROD20230525.csv" -NoTypeInformation 


