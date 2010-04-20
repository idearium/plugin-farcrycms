<cfsetting enablecfoutputonly="true" />
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
<!--- @@displayname: ruleNews execute --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />


<cfparam name="request.mode.lValidStatus" default="approved">


<!--- If Archive: Get Maximum Rows in New Table --->
<cfif stObj.bArchive>
	<cfquery datasource="#arguments.dsn#" name="qCount">
		SELECT count(objectID) as total
		FROM #application.dbowner#dmNews
	</cfquery>
	<cfset maximumRows = qCount.total>
<cfelse>
	<cfset maximumRows = stObj.numItems>
</cfif>

<!--- check if filtering by categories --->
<cfif len(trim(stobj.metadata))>

	<cfset oCat = createObject("component", "farcry.core.packages.types.category") />
	<cfset q = oCat.getDataQuery(lCategoryIDs="#stObj.metadata#"
		,typename="dmNews"
		,maxRows="#maximumRows#"
		,bMatchAll="#stobj.bMatchAllKeywords#"
		,sqlWhere="publishdate <= #now()# AND (expirydate >= #now()# OR expirydate is NULL)"
		,sqlOrderBy="publishDate DESC"
		) />

<cfelse>
	<!--- don't filter on categories --->
	<cfset q=application.fapi.getContentObjects(typename="dmNews", publishdate_lte=now(), expirydate_gte=now(), orderby="publishdate DESC")>
</cfif>



<cfif len(trim(stObj.intro)) AND q.recordCount>
	<cfoutput>#stObj.intro#</cfoutput>
</cfif>

<cfif stObj.bArchive>
	<!--- THIS MEANS PAGINATE --->
	<skin:pagination query="#q#" typename="dmNews" r_stObject="stNews" paginationID="ruleNews" recordsPerPage="#stObj.numItems#">
		<skin:view objectID="#stNews.objectID#" typename="dmNews" webskin="#stObj.displaymethod#" />
	</skin:pagination>
<cfelse>

	<cfloop query="q">
		<skin:view objectid="#q.objectid#" typename="dmNews" webskin="#stObj.displaymethod#" />
	</cfloop>
	

</cfif>

<cfif len(trim(stObj.suffix)) AND q.recordCount>
	<cfoutput>#stObj.suffix#</cfoutput>
</cfif>

<cfsetting enablecfoutputonly="false" />