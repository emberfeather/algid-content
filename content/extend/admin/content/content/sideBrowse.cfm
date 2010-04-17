<cfset viewContent = transport.theApplication.factories.transient.getViewContentForContent( transport ) />

<cfset filter = {
		'domain' = theURL.search('domain'),
		'orderBy' = 'path',
		'search' = theURL.search('search'),
		'type' = theURL.search('domain')
	} />

<!--- Check for no specified domain --->
<cfif filter.domain eq ''>
	<cfset filter.domain = CGI.SERVER_NAME />
</cfif>

<cfset domains = servDomain.getDomains() />
<cfset types = servType.getTypes() />

<cfoutput>
	#viewContent.filter( filter, domains, types )#
</cfoutput>
