$kontekst = Get-MgContext
if (-not $kontekst) { throw "Ikke tilkoblet Graph. Kjør Connect-MgGraph først." }
Write-Output "Tilkoblet som $($kontekst.Account)"

New-Item -ItemType Directory -Force -Path .\config\entra, .\config\intune | Out-Null

function Lagre($objekt, $sti) {
    $objekt | ConvertTo-Json -Depth 20 | Set-Content -Path $sti -Encoding UTF8
    Write-Output "  $sti"
}

function RentNavn($tekst) {
    ($tekst.Trim() -replace '[\\/:*?"<>|]', '_')
}

function HentAlle($url) {
    $resultat = @()
    while ($url) {
        $svar = Invoke-MgGraphRequest -Method GET -Uri $url
        $resultat += $svar.value
        $url = $svar.'@odata.nextLink'
    }
    $resultat
}

Write-Output "Conditional Access:"
foreach ($p in HentAlle "https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies") {
    Lagre $p ".\config\entra\ca-$(RentNavn $p.displayName).json"
}

Write-Output "Grupper:"
$grupper = Get-MgGroup -All | Where-Object { $_.DisplayName -match '^(ROL|LIC|CA)-' }
foreach ($g in $grupper) {
    $medlemmer = Get-MgGroupMember -GroupId $g.Id -All |
        ForEach-Object { $_.AdditionalProperties.userPrincipalName }
    $ut = [pscustomobject]@{
        displayName     = $g.DisplayName
        description     = $g.Description
        membershipRule  = $g.MembershipRule
        membershipTypes = $g.GroupTypes
        memberCount     = @($medlemmer).Count
        members         = $medlemmer
    }
    Lagre $ut ".\config\entra\gruppe-$(RentNavn $g.DisplayName).json"
}

Write-Output "Intune compliance:"
foreach ($c in HentAlle "https://graph.microsoft.com/v1.0/deviceManagement/deviceCompliancePolicies") {
    Lagre $c ".\config\intune\compliance-$(RentNavn $c.displayName).json"
}

Write-Output "Intune konfigurasjonsprofiler:"
foreach ($k in HentAlle "https://graph.microsoft.com/v1.0/deviceManagement/deviceConfigurations") {
    Lagre $k ".\config\intune\config-$(RentNavn $k.displayName).json"
}

$antall = (Get-ChildItem .\config -Recurse -File -Filter *.json).Count
Write-Output "Ferdig. $antall JSON-filer skrevet."
