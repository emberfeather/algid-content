<cfset viewContent = views.get('content', 'content') />

<cfset filter = {
	'domain' = theURL.search('domain'),
	'orderBy' = 'path',
	'search' = theURL.search('search')
} />

<!--- Check for no specified domain --->
<cfif filter.domain eq ''>
	<cfset filter.domain = CGI.SERVER_NAME />
</cfif>

<cfset domains = servDomain.getDomains() />

<cfoutput>
	#viewContent.filter( filter, domains )#
</cfoutput>
