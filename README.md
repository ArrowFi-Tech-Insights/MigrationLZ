<h1>Azure CAF Migration Landingzone</h1>
<p>Tässä Git Repositoryssa on esimerkki miten provisioidaan Microsoft Cloud Adaptation Frameworkin Migration Landingzone esimerkki blueprint loppuasiakkaan Azure subscriptioniin Azure Lighthousella.</p>
<p>Tarvittavat asiat:</p>
<ul>
<li>Git-komentorivityökalut.</li>
<li>Azure tenantti hallintapuolelle.</li>
<li>Azure tenantti ja subscription loppuasiakkaan puolelle.</li>
<li>Powershell modulit: Az.Blueprint, Az.ManagedServiceIdentity</li>
<li>Azure AD-ryhmä hallinta-tenanttiin jolla annetaan pääsy loppuasiakkaan subscriptioniin.</li>
<li>Azure AD-ryhmä loppuasiakkaan-tenanttiin, jolle annetaan key vaultin käyttöoikeus</li>
</ul>
</p>
<p>Tämän esimerkin oletus regioona on North Europe.</p>

<h2>1. Valmistelevat toimenpiteet</h2>
<p>1.1 Aseta Powershell execution policy komennolla: "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine"</p>
<p>1.2 Asenna Git-työkalut koneellesi. <a href="https://github.com/git-guides/install-git#:~:text=To%20install%20Git%2C%20navigate%20to,installation%20by%20typing%3A%20git%20version%20.">Ohje</a>.</p>
<p>1.3 Kopioi/kloonaa tämä Github repository paikalliselle koneellesi. (komento: "git clone https://github.com/ArrowFi-Tech-Insights/MigrationLZ.git")</p>
<p>1.4 Asenna Powershell modulit. (Powershell-komento: Install-Module -Name Az, Az.Blueprint, Az.ManagedServiceIdentity)</p>
<p>1.5 Luo Azure AD-ryhmä hallinta-tenanttiin. AD-ryhmän jäsenet saavat contributor-tason oikeudet loppuasiakkaan subscriptioniin.</p>
<p>1.6 Luo Azure AD-ryhmä loppuasiakkaan-tenanttiin, jolle annetaan key vaultin käyttöoikeus.</p>

<h2>2. Lighthouse delegaation tekeminen</h2>
<p>2.1 Kirjaudu Powershellillä loppuasiakkaan Azure-tenanttiin tunnuksella jolla on owner tason oikeudet loppuasiakkaan Azure subscriptioniin.</p>
<p>2.2 Valitse Azure subscription jolle haluat tehdä delegaation. (Powershell komento "Select-AzSubscription -SubscriptionId XXXXXXSubIDXXXXX")</p>
<p>2.3 Avaa "delegation_templates" kansiosta "delegatedResourceManagement.parameters.json" tiedosto editoriin ja muokkaa seuraavat asiat:</p>
<ul>
<li>mspOfferName: Hallinta-tenantin yrityksen nimi</li>
<li>mspOfferDescription: </li>
<li>managedByTenantId: Hallinta-tenantin ID</li>
<li>principalId: Jokaiseen authorization kohtaan laitetaan principalID:ksi hallinta-tenanttiin luoman AD-ryhmän ID.</li>
</ul>
<img src="https://raw.githubusercontent.com/ArrowFi-Tech-Insights/MigrationLZ/main/_images/example1.png" width="800px" height="auto">
<p>2.4 Suorita "create_delegation.ps1"-skripti ja ota talteen skriptin tulostama User Assigned Identity ID</p>
<p>Tämän jälkeen hallinta-tenantista on pääsy määrittelemääsi subsriptioniin.</p>
<h2>3. Blueprintin deployment loppuasiakkaan subscriptioniin</h2>
<p>3.1 Kirjaudu hallinta-tenanttiin Powershellillä.</p>
<p>3.2 Valitse loppuasiakkaan subscription komennolla: "Select-AzSubscription -Subscription ##SubscriptionID##"
<p>3.3 Aseta $sub muuttuja komennolla: "$sub = (Get-AzContext).Subscription.id". Muuttujaa käytetään jatkossa komentojen yhteydessä.
<p>3.4 Importtaa Blueprint tiedostot azureen komennolla: "Import-AzBlueprintWithArtifact -Name Migration_LZ -SubscriptionId $sub -InputPath ./caf-migration-landing-zone -IncludeSubFolders"</p>
<p>3.5 Julkaise blueprintistä ensimmäinen versio:</p>
<p>3.5.1 Hae blueprintin tiedot $bp muuttujaan komennolla: "$bp = Get-AzBlueprint -Name Migration_LZ"</p>
<p>3.5.2 Julkaise ensimmäinen versio blueprintistä komennolla: "Publish-AzBlueprint -Blueprint  $bp -Version 1.0"</p>
<p>3.5.3 Muokkaa blueprintAssigment.json tiedostoon seuraavat arvot:
<ul>
<li>blueprintId. Lisää kohde-subscriptionin ID</li>
<li>Organization_Name. Lisää organisaatiosi nimi</li>
<li>KV-AccessPolicy. Loppuasiakkaan Azure AD-ryhmän ID, jolle sallitaan Key Vaultin käyttö.</li>
<li>tenantId. Lisää asiakkaan Azure AD-tenantin ID User Assigned Identity ID:lle</li>
<li>userAssignedIdentities. Lisää kohdassa 2.4 talteen otettu User Assigned Identity ID</li>
</ul>
<img src="https://raw.githubusercontent.com/ArrowFi-Tech-Insights/MigrationLZ/main/_images/example2.png" width="800px" height="auto">
<img src="https://raw.githubusercontent.com/ArrowFi-Tech-Insights/MigrationLZ/main/_images/example3.png" width="800px" height="auto">
<img src="https://raw.githubusercontent.com/ArrowFi-Tech-Insights/MigrationLZ/main/_images/example4.png" width="800px" height="auto">
</p>

<p>3.5.4 Assignaa julkaistu blueprint kohde subsciptioniin komennolla: <br><br>"New-AzBlueprintAssignment -Blueprint $bp -Name 'assignMigrationLZ' -AssignmentFile ./caf-migration-landing-zone/blueprintAssignment.json -SubscriptionId $sub""</p> 