function Export-EntraUsersForADX {
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
        "Id" = "ObjectID"
        "accountEnabled" = "accountEnabled"
        "displayName" = "displayName"
        "employeeId" = "employeeId"
        "givenName" = "givenName"
        "mail" = "mail"
        "surname" = "surname"
        "userPrincipalName" = "userPrincipalName" 
        "userType" = "userType"

        #"aboutMe" = "aboutMe"
        "city" = "city"
        "companyName" = "companyName"
        "country" = "country"
        "createdDateTime" = "createdDateTime"
        "creationType" = "creationType"
        "deletedDateTime" = "deletedDateTime"
        "department" = "department"
        
        "employeeHireDate" = "employeeHireDate"
        "employeeLeaveDateTime" = "employeeLeaveDateTime"
        
        "employeeType" = "employeeType"
        "externalUserState" = "externalUserState"
        "externalUserStateChangeDateTime" = "externalUserStateChangeDateTime"
        "faxNumber" = "faxNumber"
       
        #"hireDate" = "hireDate"
        "jobTitle" = "jobTitle"
        "lastPasswordChangeDateTime" = "lastPasswordChangeDateTime"

        "mailNickname" = "mailNickname"
        "mobilePhone" = "mobilePhone"
        #"mySite" = "mySite"
        "officeLocation" = "officeLocation"
        "onPremisesDistinguishedName" = "onPremisesDistinguishedName"
        "onPremisesDomainName" = "onPremisesDomainName"
        "onPremisesImmutableId" = "onPremisesImmutableId"
        "onPremisesLastSyncDateTime" = "onPremisesLastSyncDateTime"
        "onPremisesSamAccountName" = "onPremisesSamAccountName"
        "onPremisesSecurityIdentifier" = "onPremisesSecurityIdentifier"
        "onPremisesSyncEnabled" = "onPremisesSyncEnabled"
        "onPremisesUserPrincipalName" = "onPremisesUserPrincipalName"
        "postalCode" = "postalCode"
        "preferredDataLocation" = "preferredDataLocation"
        "preferredLanguage" = "preferredLanguage"
        #"preferredName" = "preferredName"
        "securityIdentifier" = "securityIdentifier"
        "showInAddressList" = "showInAddressList"
        "state" = "state"
        "streetAddress" = "streetAddress"
       
        "usageLocation" = "usageLocation"
        
    
    # Add custom properties as needed 
        "custom_extension" = "CustomExtension" 
       } 

    }
process {
    
      # Retrieve users with specified properties and create custom objects directly 
       $users = Get-MgUser -Select ($propertyMappings.Keys) -All | ForEach-Object { 
          $userObject = @{} 
          foreach ($key in $propertyMappings.Keys) { 

            if ($key -eq "CreatedDateTime") { 
              # Convert date string directly to DateTime and format it 
              $date = [datetime]::Parse($_.$key) 
              $userObject[$propertyMappings[$key]] = $date.ToString("yyyy-MM-dd") 
            } else { 
              $userObject[$propertyMappings[$key]] = $_.$key 
            } 
          } 
          # Additional properties or transformations
          $userObject["TenantId"] = $TenantId 
          $userObject["TenantName"] = $TenantName
          $userObject["SnapshotDate"] = $SnapShotDate
          [pscustomobject]$userObject 
        } 
        # Convert the user data to JSON and save it to a file 
        $users | ConvertTo-Json -Depth 2 | Set-Content "..\exported\EntraUsers.json" 
      } 
    }
