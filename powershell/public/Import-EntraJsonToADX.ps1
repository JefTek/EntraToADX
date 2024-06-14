function Import-EntraJsonToADX.ps1 {
    [CmdletBinding()]
    param (
        $ClusterUri = "https://kvc-4twdu3r7j1jv7026r5.southcentralus.kusto.windows.net",
        $DataIngestionUri = "https://ingest-kvc-4twdu3r7j1jv7026r5.southcentralus.kusto.windows.net",
        $DatabaseName = "MyEntraID",
        $TableName="EntraUsers",
        $Path
    )
    
    begin {

        $accessToken = (Get-AzAccessToken -ResourceUrl $ClusterUri).Token
        $authHeader = @{
            'Content-Type'  = 'application/json'
            'Authorization' = 'Bearer ' + $accessToken
            'Host'          = $DataIngestionUri
        }
    }
    
    process {


        $IngestionUri = ("{0}/v1/rest/ingest/{1}/{2}}?streamFormat=json" -f $DataIngestUri, $DatabaseName,$TableName)
        $Response = Invoke-RestMethod -Uri $Uri -Method POST -Headers $authHeader -Body $Collection -Verbose

        
    }
    
    end {
        
    }
