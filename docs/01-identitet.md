# Fase 1: identitet og endepunkt

Design først, klikking etterpå. Prøveperioden på lisensene varer 30 dager, og den tiden skal brukes til å bygge og fotografere, ikke til å finne ut hva som skal bygges.

## Lisens og oppsett

Microsoft 365 E5 på prøve gir Entra ID P2, Intune, Defender og Exchange i samme pakke. Det er det eneste alternativet som dekker hele fasen uten å stykke opp arbeidet i flere prøveperioder som utløper på ulike datoer.

To ting å vite før du trykker:

Registreringen krever betalingskort. Prøven går automatisk over til betalt årsabonnement når de 30 dagene er ute hvis du ikke sier opp. Sett en påminnelse på dag 25 med én gang du har opprettet tenanten, ikke etterpå.

Sjekk om Kristiania gir deg Azure for Students. Det gir kreditt uten kort, og gjør at du kan holde en Entra-tenant i live etter at E5-prøven er borte. Selve arbeidet ditt overlever uansett prøveperioden, siden policyene eksporteres til JSON og skjermbildene ligger i repoet.

Tenantnavnet blir noe i retning av `nordvikmarine.onmicrosoft.com`. Får du ikke akkurat det, søk og erstatt i `data/brukere.csv` før import.

## Brukere

`data/brukere.csv` ligger klar i Entra sitt bulk-format med 54 rader. Første linje er `version:v1.0` og skal være der, den er en del av formatet.

Fordelingen følger organisasjonskartet i Fase 0. De fire siste radene er de delte verkstedkontoene, og de er med med vilje. Du skal opprette dem slik de faktisk er i dag, med passordet fra 2022, fordi hele Fase 1 handler om å komme seg vekk fra dem. Uten utgangspunktet blir forbedringen usynlig.

Alle kontoene opprettes med `Block sign in = No`. Passordene i fila er tilfeldige og skal byttes ved første pålogging uansett.

## Grupper

Tre familier, med prefiks så de ikke blandes i en liste som vokser.

Dynamiske grupper på avdeling, brukes til tilgang og til å målrette policyer. Regelen for konstruksjon blir `user.department -eq "Konstruksjon"`. Skriv avdelingsnavnet nøyaktig som det står i CSV-en, med æøå. En regel som sier `Innkjop` treffer ingen.

| Gruppe | Type | Regel eller innhold |
|---|---|---|
| `ROL-Ledelse` | Dynamisk | department eq Ledelse |
| `ROL-Salg` | Dynamisk | department eq Salg og prosjekt |
| `ROL-Konstruksjon` | Dynamisk | department eq Konstruksjon |
| `ROL-Verksted` | Dynamisk | department eq Verksted og service |
| `ROL-Innkjop` | Dynamisk | department eq Innkjøp og logistikk |
| `ROL-Okonomi` | Dynamisk | department eq Økonomi og lønn |
| `ROL-HR` | Dynamisk | department eq HR og administrasjon |
| `ROL-IT` | Dynamisk | department eq IT |
| `LIC-E3` | Tildelt | Kontoransatte, gruppebasert lisensiering |
| `LIC-F3` | Tildelt | Verksted og lager |
| `CA-Unntak-Brannkonto` | Tildelt | De to nødkontoene, ingen andre |
| `CA-Pilot` | Tildelt | IT og to frivillige fra salg |
| `CA-Reiser-Utland` | Tildelt | Salg og ledelse, tidsbegrenset medlemskap |

`CA-Pilot` er den viktigste av dem. Hver policy settes først i rapporteringsmodus, deretter på pilotgruppa, og først til slutt på alle. Skjermbildet av en policy som står i rapporteringsmodus med treff i loggen er mer overbevisende enn en policy som bare er skrudd på.

## Nødkontoer

To stykker, `brannkonto01` og `brannkonto02`. Rene skykontoer, ikke synkronisert, ikke knyttet til en person, permanent Global Administrator uten PIM.

De unntas fra samtlige Conditional Access-policyer. Det er hele poenget med dem, og det er også grunnen til at unntaket skal dokumenteres og overvåkes. Lag et varsel som fyrer på enhver pålogging fra disse to kontoene, og skriv ned hvem som skal ringes når det skjer.

Passordene er lange og tilfeldige, skrevet på papir og lagt i safen på Skøyen. Det høres gammeldags ut, men det er riktig svar når alternativet er en passordbehandler som selv krever pålogging.

To kontoer og ikke én, fordi du skal kunne teste den ene uten å stå uten den andre.

## Conditional Access

Rekkefølgen under er byggerekkefølgen. Ikke lag dem i én omgang og skru på alt samtidig.

**CA01, krev tofaktor for alle.** Alle brukere, alle skyapper, unntatt `CA-Unntak-Brannkonto`. Dette er policyen som Fase 0 sier ledelsen slapp unna i 2024. Nå slipper de ikke.

**CA02, blokker eldre autentisering.** Treffer klienter som ikke støtter moderne pålogging. Kjør denne i rapporteringsmodus i minst tre døgn før du skrur den på, og se hva som dukker opp. Hos Nordvik er sjansen stor for at noe i Visma-oppsettet eller en gammel skanner på verkstedet fortsatt bruker det. Fangsten av akkurat det treffet er et av de beste skjermbildene i hele fasen.

**CA03, krev samsvarende enhet for administratorroller.** Gjelder de privilegerte rollene, ikke vanlige brukere.

**CA04, geografisk begrensning.** Navngitt lokasjon Norge. Blokker pålogging utenfra, med unntak for `CA-Reiser-Utland`. Salg reiser og skal ikke stoppes på et hotell i Rotterdam, men de skal være medlem av en gruppe noen har meldt dem inn i, ikke ha unntaket for alltid.

**CA05, risikobasert.** Krev tofaktor på nytt ved forhøyet påloggingsrisiko, krev passordbytte ved forhøyet brukerrisiko. Dette er P2-funksjonalitet og faller bort hvis du ender på P1.

**CA06, mobil.** Krev godkjent klientapp og appbeskyttelsespolicy for e-post på telefon. Dette er svaret på punktet i Fase 0 om at ingen vet hvilke private mobiler som har jobbmail. Etter denne vet du det, og du kan fjerne jobbdata fra en telefon uten å røre resten av den.

**CA07, sesjonslengde på uadministrerte enheter.** Kortere levetid og ingen "husk meg" når enheten ikke er kjent.

## Verkstedet

Dette er den eneste virkelig vanskelige avveiningen i fasen, og den er verdt å bruke tid på fordi den er den mest sannsynlige tingen en intervjuer graver i.

Montørene står med hansker i et maskinrom med dårlig dekning og skal registrere timer på et nettbrett. Krever du at de låser opp telefonen, åpner Authenticator og taster et tosifret tall, blir tofaktor omgått innen en uke. Enten deler de kontoen videre, eller så lar de nettbrettet stå pålogget hele skiftet med skjermlåsen av.

Det som faktisk fungerer: de delte kontoene avvikles, hver montør får personlig konto, og nettbrettene settes opp i Intune i delt enhetsmodus. Til pålogging brukes FIDO2-nøkler på nøkkelbånd i stedet for telefon. En fysisk nøkkel som trykkes med en hanske på tar to sekunder, tåler et verksted og krever ikke dekning.

Kostnaden er reell. Nøklene koster noe per stykk, de blir mistet, og noen må ha ansvar for å dele ut nye. Det skal stå i teksten. En løsning uten oppgitt kostnad ser ut som noe man har lest seg til.

Ålesund legges også inn som navngitt lokasjon, og innenfor den kan påloggingsfrekvensen være mildere enn ute på et fartøy.

## Intune

Compliance først, konfigurasjon etterpå. En enhet skal regnes som samsvarende når den har diskkryptering, oppdatert operativsystem, skjermlås og Defender aktivt.

Lag med vilje én enhet som ikke oppfyller kravet, og ta skjermbilde av både statusen i portalen og det brukeren får se. Et bilde av en liste der alt er grønt beviser ingenting.

Windows-klientene får BitLocker, Defender for Endpoint og en oppdateringsring. Nettbrettene på verkstedet får delt enhetsmodus. Mobilene får appbeskyttelse uten full enhetsregistrering, siden det er private telefoner og Nordvik ikke skal styre hele telefonen til folk.

## Privileged Identity Management

Ingen skal gå rundt med permanent Global Administrator. Systemansvarlig gjøres kvalifisert for rollen og aktiverer den når han trenger den, med begrunnelse og et tidsvindu.

Kontoen til han som sluttet i mai 2024 fjernes. Ta skjermbilde av rollelisten før du gjør det.

## Eksport

Alt som er konfigurert eksporteres som JSON til `config/entra/` og `config/intune/` før prøveperioden er over. Bruk Graph eller de innebygde eksportknappene. Dette er det som gjør at arbeidet fortsatt finnes når lisensen er borte, og det er også det en teknisk leser vil åpne først.

Husk sladdingen i `SKJERMBILDER.md`. Eksportene inneholder tenant-ID og objekt-ID-er, og de skal vaskes før commit.

## Rekkefølge

1. Opprett tenant, sett påminnelse på dag 25
2. Importer `data/brukere.csv`, verifiser 54 kontoer
3. Nødkontoer og unntaksgruppe
4. Dynamiske grupper, kontroller at medlemstallene stemmer med tabellen i Fase 0
5. Lisensiering via `LIC-E3` og `LIC-F3`
6. CA01 og CA02 i rapporteringsmodus, la dem stå i tre døgn
7. Les rapporten, ta skjermbildene, skru dem på for `CA-Pilot`
8. Resten av policyene, samme løype
9. Intune compliance og konfigurasjon
10. PIM, og fjern kontoen til han som sluttet
11. Eksporter alt til JSON
