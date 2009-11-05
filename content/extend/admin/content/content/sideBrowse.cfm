<cfset viewContent = application.factories.transient.getViewContentForContent( transport ) />

<cfset filter = {
		'domain' = CGI.SERVER_NAME,
		'orderBy' = 'path',
		'search' = theURL.search('search')
	} />

<cfoutput>
	#viewContent.filter( filter )#
</cfoutput>