<h1>Azure CAF Migration Landingzone</h1>
<p>Tässä Git Repositoryssa on esimerkki miten provisioidaan Microsoft Cloud Adaptation Frameworkin Migration Landingzone esimerkki blueprint loppuasiakkaan Azure subscriptioniin Azure Lighthousella.</p>
<p>Tarvittavat asiat:</p>
<ul>
<li>Git-komentorivityökalut.</li>
<li>Azure tenantti hallintapuolelle.</li>
<li>Azure tenantti ja subscription loppuasiakkaan puolelle.</li>
<li>Powershell modulit: Az.Blueprint, Az.ManagedServiceIdentity</li>
<li>Azure AD-ryhmä hallinta-tenanttiin jolla annetaan pääsy loppuasiakkaan subscriptioniin.</li>
</ul>
</p>
<p>Tämän esimerkin oletus regioona on North Europe.</p>

<h2>1. Valmistelevat toimenpiteet</h2>
<p>1.1 Asenna Git koneellesi. <a href="https://github.com/git-guides/install-git#:~:text=To%20install%20Git%2C%20navigate%20to,installation%20by%20typing%3A%20git%20version%20.">Ohje</a>.</p>
<p>1.2 Kopioi/kloonaa tämä Github repository paikalliselle koneellesi. (komento: "git clone https://github.com/ArrowFi-Tech-Insights/MigrationLZ.git")</p>
<p>1.3 Asenna Powershell modulit. (Powershell-komento: Install-Module -Name Az.Blueprint, Az.ManagedServiceIdentity)</p>
<p>1.4 Luo Azure AD-ryhmä hallinta-tenanttiin</p>

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
<img src="https://raw.githubusercontent.com/ArrowFi-Tech-Insights/MigrationLZ/main/_images/example1.png?token=APHBNNI67GXSIR5DKYIGUT274HYGY" width="800px" height="auto">
<p>2.4 Suorita "create_delegation.ps1"-skripti ja ota talteen skriptin tulostama User Assigned Identity ID</p>
<p>Tämän jälkeen hallinta-tenantista on pääsy määrittelemääsi subsriptioniin.</p>
<h2>3. Blueprintin deployment loppuasiakkaan subscriptioniin</h2>
<p>3.1 Importtaa Blueprint tiedostot azureen komennolla: "Import-AzBlueprintWithArtifact -Name Migration_LZ -SubscriptionId 752467a1-ff3d-49f0-a1fe-5650aeed594a -InputPath /Users/136159/Documents/Git/MigrationLZ/caf-migration-landing-zone -IncludeSubFolders"</p>
<p>3.2 Julkaise blueprintistä ensimmäinen version:</p>
<p>3.2.1 Hae blueprintin tiedot $bp muuttujaan komennolla: "$bp = Get-AzBlueprint -Name Migration_LZ"</p>
<p>3.2.2 Julkaise ensimmäinen versio blueprintistä komennolla: "Publish-AzBlueprint -Blueprint  $bp -Version 1.0"</p>
<p>3.3.3 Muokkaa blueprintAssigment.json tiedostoon seuraavat arvot:
<ul>
<li>blueprintId. Lisää kohde-subscriptionin ID</li>
<li>Organization_Name. Lisää organisaatiosi nimi</li>
<li>userAssignedIdentities. Lisää kohdassa 2.4 talteen otettu User Assigned Identity ID</li>
</ul>
<img src="https://raw.githubusercontent.com/ArrowFi-Tech-Insights/MigrationLZ/main/_images/example2.png?token=APHBNNI67GXSIR5DKYIGUT274HYGY" width="800px" height="auto">
<img src="https://raw.githubusercontent.com/ArrowFi-Tech-Insights/MigrationLZ/main/_images/example3.png?token=APHBNNI67GXSIR5DKYIGUT274HYGY" width="800px" height="auto">
</p>

<p>3.2.4 Assignaa julkaistu blueprint kohde subsciptioniin komennolla: <br><br>"New-AzBlueprintAssignment -Blueprint $bp -Name 'assignMyBlueprint' -AssignmentFile .\blueprintAssignment.json -SubscriptionId 752467a1-ff3d-49f0-a1fe-5650aeed594a"</p> 