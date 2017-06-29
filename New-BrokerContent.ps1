<#

.SYNOPSIS
    This is a simple PowerShell script to create a Citrix XenApp 7.11+ published content with a custom icon.

.DESCRIPTION
    This is a simple PowerShell script to create a Citrix XenApp 7.11+ published content with a custom icon.

.PARAMETER Name
    The name you want for your new published content.

.PARAMETER Content
    The link to your publish content (HTTP/HTTPS link, .lnk files on your network share...)
    
.PARAMETER DesktopGroup
    The name of the Desktop Group you want to bind to your published content.
    
.PARAMETER iconpath
    (Optional) The path to the .ico file. Best resolution is 256px by 256px.

.EXAMPLE
    .\New-BrokerContent.ps1 -Name "Google Link" -Content "https://www.google.com" -DesktopGroup VDA-PrePROD-W2K12R2 -iconpath "c:\temp\google-1015752_640.ico"

.NOTES
    Author  : Etienne JEANNEAU 
    Twitter : @JeanneauEtienne

#>

Param(
    [Parameter(Mandatory=$true)][String]$Name,
    [Parameter(Mandatory=$true)][String]$Content,
    [Parameter(Mandatory=$true)][String]$DesktopGroup,
    [Parameter(Mandatory=$false)][String]$iconpath
    )

# Add Citrix Snapins
asnp citrix*

# Create the Citrix Published Content
New-BrokerApplication -ApplicationType PublishedContent -CommandLineExecutable $Content -Name $Name -DesktopGroup $DesktopGroup

if($iconpath -ne $null){
# Encode the .ico file in Base64
    $b64ico = [convert]::ToBase64String((get-content $iconpath -encoding byte))

    # Adds the encoded icon in Citrix Database
    $ctxico = New-BrokerIcon -EncodedIconData $b64ico

    # Set the icon to the newly created application
    Set-BrokerApplication -Name $Name -IconUid $ctxico.Uid
}
