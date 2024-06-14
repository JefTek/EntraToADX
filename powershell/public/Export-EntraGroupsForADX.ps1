function Export-EntraGroupsForADX {
    [OutputType([System.Collections.ArrayList])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $TenantId,

        [Parameter(Mandatory = $true)]
        [string]
        $TenantName,

        [Parameter(Mandatory = $false)]
        [string]
        $SnapShotDate = (get-date).ToString("yyyy-MM-dd")
    )
    begin {
        # Define a hash table for property mappings 
        $propertyMappings = @{ 
            #core attributes
            "Id"                            = "ObjectID"
            "displayName"                   = "displayName"
            "mail"                          = "mail"
            "createdDateTime"               = "createdDateTime"
            "description"                   = "description"
            "mailEnabled"                   = "mailEnabled"
            "mailNickname"                  = "mailNickname"
            "securityEnabled"               = "securityEnabled"

            #extended attributes
            #"allowExternalSenders"         = "allowExternalSenders"
            #"classification"               = "classification"
            #"deletedDateTime"              = "deletedDateTime"
            #"expirationDateTime"           = "expirationDateTime"
            #"hidefromAddressLists"          = "hidefromAddressLists"
            "isAssignableToRole"            = "isAssignableToRole"
            "membershipRule"                = "membershipRule"
            "membershipRuleProcessingState" = "membershipRuleProcessingState"
            "onPremisesLastSyncDateTime"    = "onPremisesLastSyncDateTime"
            "onPremisesSamAccountName"      = "onPremisesSamAccountName"
            "onPremisesSecurityIdentifier"  = "onPremisesSecurityIdentifier"
            "onPremisesSyncEnabled"         = "onPremisesSyncEnabled"
            "preferredDataLocation"         = "preferredDataLocation"

            #relationship attributes
            "owners"                        = "owners"
            # Add custom properties as needed 
            "custom_extension"              = "CustomExtension" 
        } 

    }
    process {
    
        # Retrieve groups with specified properties and create custom objects directly 
        $groups = Get-MgGroup -Select ($propertyMappings.Keys) -All | ForEach-Object { 
            $groupObject = @{} 
            foreach ($key in $propertyMappings.Keys) { 

                if ($key -eq "CreatedDateTime") { 
                    # Convert date string directly to DateTime and format it 
                    $date = [datetime]::Parse($_.$key) 
                    $groupObject[$propertyMappings[$key]] = $date.ToString("yyyy-MM-dd") 
                }
                else { 
                    $groupObject[$propertyMappings[$key]] = $_.$key 
                } 
            } 
            # Additional properties or transformations
            $groupObject["TenantId"] = $TenantId 
            $groupObject["TenantName"] = $TenantName
            $groupObject["SnapshotDate"] = $SnapShotDate
            [pscustomobject]$groupObject 
        } 
        # Convert the group data to JSON and save it to a file 
        $groups | ConvertTo-Json -Depth 2 | Set-Content "..\exported\EntraGroups.json" 
    } 
}
