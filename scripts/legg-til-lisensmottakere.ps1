Connect-MgGraph -TenantId "nordvikmarine.onmicrosoft.com" `
                -Scopes "GroupMember.ReadWrite.All", "User.Read.All", "Group.Read.All"

$gruppe = Get-MgGroup -Filter "displayName eq 'LIC-E3'"
if (-not $gruppe) { throw "Fant ingen gruppe som heter LIC-E3" }

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
