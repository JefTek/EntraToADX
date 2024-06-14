<#
.DISCLAIMER
	THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
	ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
	THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
	PARTICULAR PURPOSE.

	Copyright (c) Microsoft Corporation. All rights reserved.
#>

## Initialize Module Variables

## Initialize Module Configuration
#Requires -Modules Microsoft.Graph.Authentication,az.accounts

# Import private and public scripts and expose the public ones
$privateScripts = @(Get-ChildItem -Path "$PSScriptRoot\internal" -Recurse -Filter "*.ps1")
$publicScripts = @(Get-ChildItem -Path "$PSScriptRoot\public" -Recurse -Filter "*.ps1")

foreach ($script in ($privateScripts + $publicScripts)) {
	try {
		. $script.FullName
	} catch {
		Write-Error -Message ("Failed to import function {0}: {1}" -f $script, $_)
	}
}