if (-not (Get-MgContext)) {
    Connect-MgGraph -TenantId "nordvikmarine.onmicrosoft.com" `
                    -Scopes "GroupMember.ReadWrite.All", "User.Read.All", "Group.Read.All"
}

$kontekst = Get-MgContext
if (-not $kontekst) { throw "Ikke tilkoblet Graph. Kjør Connect-MgGraph først." }
Write-Output "Tilkoblet som $($kontekst.Account) i $($kontekst.TenantId)"

$gruppe = Get-MgGroup -Filter "displayName eq 'LIC-E3'"
if (-not $gruppe) {
    $finnes = Get-MgGroup -Filter "startsWith(displayName,'LIC')" | ForEach-Object { $_.DisplayName }
    throw "Fant ingen gruppe LIC-E3. Grupper som starter med LIC: $($finnes -join ', ')"
}

$upn = Import-Csv .\data\lisensmottakere.csv | ForEach-Object { $_.Brukernavn }
Write-Output "Legger til $($upn.Count) brukere i $($gruppe.DisplayName)"

foreach ($u in $upn) {
    try {
        $bruker = Get-MgUser -UserId $u -ErrorAction Stop
        New-MgGroupMember -GroupId $gruppe.Id -DirectoryObjectId $bruker.Id -ErrorAction Stop
        Write-Output "  lagt til   $u"
    }
    catch {
        Write-Output "  hoppet over $u  ($($_.Exception.Message))"
    }
}

$antall = (Get-MgGroupMember -GroupId $gruppe.Id -All).Count
Write-Output "LIC-E3 har na $antall medlemmer"
