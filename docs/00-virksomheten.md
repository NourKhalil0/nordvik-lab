# Nordvik Marine AS

Oppdiktet selskap. Alt under her er konstruert for laben, men det er konstruert slik at det oppfører seg som et ekte selskap av denne typen og størrelsen.

## Hva de driver med

Nordvik Marine reparerer og bygger om hydraulisk dekksutstyr. Vinsjer, kraner og kveilere til fiskefartøy og offshore forsyningsskip. De tar imot utstyr på verkstedet i Ålesund, og de sender montører ut til fartøy som ligger til kai andre steder på kysten. Salg, konstruksjon og økonomi sitter på Skøyen i Oslo.

Selskapet ble stiftet i 1998 av to brødre som fortsatt eier det. Omsetningen ligger rundt 96 millioner. De har 56 ansatte, men bare 54 brukerkontoer, og seks av montørene deler de fire siste. Den forskjellen er en av tingene som skal ryddes opp i.

Kundene er i hovedsak rederier, men de siste fire årene har en større del av inntekten kommet fra to verft som bruker Nordvik som underleverandør. Det er derfra sikkerhetskravene kommer.

## Hvorfor dette arbeidet skjer nå

I januar sendte det ene verftet et leverandørskjema med 41 spørsmål om informasjonssikkerhet. Nordvik klarte å svare skikkelig på 14 av dem. På resten krysset de av for "delvis" eller lot være å svare. Kontrakten skal fornyes til høsten, og verftet har sagt at skjemaet blir del av vurderingen.

Daglig leder har gitt IT en ramme og en frist. Det er hele mandatet. Ingen har bedt om et styringssystem eller en sertifisering, de har bedt om å kunne svare ærlig på skjemaet neste gang.

## Folk og roller

| Avdeling | Antall | Hvor | Merknad |
|---|---|---|---|
| Ledelse | 3 | Oslo | Daglig leder, økonomisjef, teknisk sjef |
| Salg og prosjekt | 6 | Oslo | Reiser mye, jobber fra hotell og fartøy |
| Konstruksjon | 9 | Oslo | Tegner i CAD, sitter på kundetegningene |
| Verksted og service | 24 | Ålesund | Skift, montører ute på oppdrag |
| Innkjøp og logistikk | 5 | Ålesund | |
| Økonomi og lønn | 4 | Oslo | |
| HR og administrasjon | 3 | Oslo | |
| IT | 2 | Oslo | En systemansvarlig og en lærling |

Konstruksjon er den avdelingen som sitter på det som er verdt mest. Tegningene av kundenes dekksutstyr er dekket av taushetserklæring i nesten hver eneste kontrakt, og flere av dem beskriver fartøy som gjør oppdrag for Forsvaret. Det er også den avdelingen som har flest unntak fra alt, fordi CAD er tungt og folk har blitt vant til å få viljen sin.

Verkstedet er den vanskeligste gruppen å styre. Montørene har hansker på, står i en trang maskinrom med dårlig dekning, og skal registrere timer på en nettbrett-app mens de gjør det. Alt som krever at de logger inn på nytt blir omgått i løpet av en uke.

## Systemer

| System | Hva det gjør | Hvor det kjører |
|---|---|---|
| Microsoft 365 | E-post, Teams, filer for kontoret | Sky |
| Entra ID | Pålogging | Sky, synkronisert fra lokal AD |
| Windows Server 2019 | Domenekontroller og filserver | Oslo, i et skap ved siden av kopimaskinen |
| Visma Business | ERP, ordre og faktura | Lokal server i Oslo |
| Autodesk Inventor | CAD | Klienter i Oslo, filer på NAS i Ålesund |
| Synology NAS | Tegningsarkiv og servicehistorikk | Ålesund |
| Servicerapport-app | Timer og rapporter fra montører | Sky hos norsk leverandør |
| Siemens S7 og HMI | Styring av testriggen på verkstedet | Ålesund, eget nett |
| Adgangskontroll og kamera | Bygg | Ålesund, levert av vaktselskap |

Domenekontrolleren skulle vært avviklet i 2023. Den står fortsatt fordi Visma Business autentiserer mot den, og ingen har hatt tid til å finne ut hva som skjer hvis den slås av.

HMI-en på testriggen kjører Windows 10 uten oppdateringer siden mars 2021. Leverandøren av riggen støtter ikke nyere versjoner, og en oppgradering koster mer enn riggen er verdt på papiret. Maskinen står på samme nett som resten av verkstedet.

## Hva som faktisk stopper driften

Hvis Microsoft 365 er nede, blir folk irriterte og ringer hverandre i stedet. De taper ikke penger på det første dagen.

Hvis Visma Business er nede, kan de ikke fakturere eller bestille deler. Det tåler de i omtrent to dager før det gjør vondt.

Hvis tegningsarkivet på NAS-en blir kryptert eller borte, kan de ikke servicere utstyr de har levert tidligere, og de kan ikke dokumentere hva de har gjort. Mye av det finnes ikke andre steder. Dette er det som må beskyttes best.

Hvis testriggen står, kan ikke en reparasjon signeres ut. Da blir fartøyet liggende til kai. Teknisk sjef anslår at det koster kunden rundt 40 000 kroner i døgnet, og at regningen fort havner hos Nordvik.

## Det de vet er galt

Dette er listen IT-ansvarlig skrev ned da verftsskjemaet kom. Den er ikke sortert etter alvorlighet, den er sortert etter hva han kom på først.

Fire delte kontoer på verkstedet. En per skift pluss en for lærlingene. Alle kan passordet, og det har vært det samme siden 2022.

Han som hadde IT før har fortsatt Global Administrator. Han sluttet i mai 2024 og jobber nå hos en konkurrent. Kontoen er ikke brukt siden han sluttet, så vidt de kan se.

Tofaktor ble innført sommeren 2024, men bare som anbefaling. Omtrent halvparten har det. Ledelsen har det ikke, fordi de ba om å slippe.

Ingen vet hvilke private mobiler som har jobbmail. Folk har satt det opp selv gjennom årene.

HMI-en på testriggen.

Backup av NAS-en går hver natt og rapporterer grønt. Ingen har noen gang prøvd å hente noe tilbake fra den.

Leverandøren av servicerapport-appen har en støttebruker inn i systemet. Ingen hos Nordvik vet hvilke data den bruker faktisk kan se, og avtalen sier ikke noe om det.

## Rammer for arbeidet

Budsjettet er lite. Alt som koster ny lisens må begrunnes, og alt som krever at verkstedet endrer arbeidsvaner må avklares med teknisk sjef først. Han har sett flere gode ideer fra kontoret som ikke overlevde møtet med en maskinhall.

Nordvik er ikke selv omfattet av kravene som følger digitalsikkerhetsloven. Kravene kommer gjennom kontrakt fra verftene, som er omfattet. Det betyr at målestokken ikke er hva loven sier, men hva som står i leverandørskjemaet og hva Nordvik faktisk kan dokumentere når noen spør.
