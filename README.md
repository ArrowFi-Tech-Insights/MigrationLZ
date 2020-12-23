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
<p>Asenna Git koneellesi. <a href="https://github.com/git-guides/install-git#:~:text=To%20install%20Git%2C%20navigate%20to,installation%20by%20typing%3A%20git%20version%20.">Ohje</a>.</p>
<p>Kopioi/kloonaa tämä Github repository paikalliselle koneellesi. (komento: "git clone https://github.com/ArrowFi-Tech-Insights/MigrationLZ.git")</p>
<p>Asenna Powershell modulit. (komento: Install-Module -Name Az.Blueprint, Az.ManagedServiceIdentity)</p>
<p>Luo Azure AD-ryhmä hallinta-tenanttiin</p>

<h2>2. Lighthouse delegaation tekeminen</h2>
<p>Kirjaudu Powershellillä loppuasiakkaan Azure-tenanttiin tunnuksella jolla on owner tason oikeudet loppuasiakkaan Azure subscriptioniin.</p>
<p>Valitse Azure subscription jolle haluat tehdä delegaation.</p>
<p>Avaa "delegation_templates" kansiosta "delegatedResourceManagement.parameters.json" tiedosto editoriin ja muokkaa seuraavat asiat:</p>
<ul>
<li>mspOfferName: Hallinta-tenantin yrityksen nimi</li>
<li>mspOfferDescription: </li>
<li>managedByTenantId: Hallinta-tenantin ID</li>
<li>principalId: Jokaiseen authorization kohtaan laitetaan principalID:ksi hallinta-tenanttiin luoman AD-ryhmän ID.</li>
</ul>
<img src="https://raw.githubusercontent.com/ArrowFi-Tech-Insights/MigrationLZ/main/_images/example1.png?token=APHBNNI67GXSIR5DKYIGUT274HYGY" width="800px" height="auto">
