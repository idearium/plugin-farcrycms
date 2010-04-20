<cfsetting enablecfoutputonly="yes" />
<!--- @@Copyright: Daemon Pty Limited 2002-2008, http://www.daemon.com.au --->
<!--- @@License:
    This file is part of FarCry CMS Plugin.

    FarCry CMS Plugin is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    FarCry CMS Plugin is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with FarCry CMS Plugin.  If not, see <http://www.gnu.org/licenses/>.
--->

<cfimport taglib="/farcry/core/tags/wizard" prefix="wiz" />
<cfimport taglib="/farcry/core/tags/formtools" prefix="ft" />


<!--- PROCESS WIZARD SUBMISSION --->
<!--- Always save wizard WDDX data --->


<wiz:processwizard excludeAction="Cancel">

	<!--- Save any Types submitted (including any new ones) --->
	<wiz:processWizardObjects typename="ruleHandpicked" />
	<ft:processFormObjects typename="ruleHandpicked_aObjects" />
	
</wiz:processwizard>


<!--- Save Wizard Data manually to avoid overriding the extended array table data --->
<wiz:processWizard action="Save" RemoveWizard="true" Exit="true">
	<cfset stProperties = stWizard.data[stobj.objectid] />
	<cfset structDelete(stProperties, "aObjects") />
	<cfset stResult = setData(stProperties=stProperties)>
	
</wiz:processWizard>

<wiz:processwizard action="Cancel" Removewizard="true" Exit="true" /><!--- remove wizard --->


<!--- RENDER THE WIZARD --->
<wiz:wizard ReferenceID="#stobj.objectid#" r_stWizard="stWizard">

	<wiz:step name="Select Objects">
		<wiz:object stobject="#stobj#" wizardID="#stWizard.ObjectID#" lfields="Intro" format="edit" legend="Introduction" />
		<wiz:object stobject="#stobj#" wizardID="#stWizard.ObjectID#" lfields="aObjects" format="edit" legend="Select Handpicked Objects" />
	</wiz:step>
	
	<wiz:step name="Select Webskin Templates">

		<cfoutput><h3>Selected Handpicked Objects</h3></cfoutput>

		<cfif structKeyExists(stWizard.data, stobj.objectid)>
			<cfif arrayLen(stWizard.data[stobj.objectid].aObjects)>		
				
				<cfoutput>
				<table width="100%">
				<tr>
					<th>Handpicked Object</th>
					<th>Content Template</th>
				</tr>
				</cfoutput>
					
				<cfloop from="1" to="#arrayLen(stWizard.data[stobj.objectid].aObjects)#" index="i">

					<cfset oType = createObject("component", application.stcoapi["#stWizard.data[stobj.objectid].aObjects[i].typename#"].packagePath) />
					<cfset teaserHTML = oType.getView(objectid=stWizard.data[stobj.objectid].aObjects[i].data, template="librarySelected", alternateHTML="") />
					<cfif not len(teaserHTML)>
						<cfset st = oType.getData(objectid=stWizard.data[stobj.objectid].aObjects[i].data) />
						<cfset teaserHTML = st.label />
					</cfif>
					<ft:object objectid="#stWizard.data[stobj.objectid].aObjects[i].objectid#" lfields="webskin" r_stFields="stFields" />
					
					
					<cfoutput>
					<tr>
						<td style="padding:10px;">#teaserHTML#</td>
						<td style="padding:10px;">#stFields.webskin.html#</td>
					</tr>
					</cfoutput>
				</cfloop>
				
				<cfoutput>
				</table>
				</cfoutput>
			</cfif>
		<cfelse>
			<cfoutput><p>OBJECT NOT YET STORED IN THE WIZARD</p></cfoutput>
		</cfif>
			
	
	</wiz:step>
</wiz:wizard>

<cfsetting enablecfoutputonly="no" />


