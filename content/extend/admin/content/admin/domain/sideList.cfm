<cfset viewDomain = application.factories.transient.getViewDomainForContent( transport ) />

<cfset filter = {
		'search' = theURL.search('search')
	} />

<cfoutput>
	#viewDomain.filter( filter )#
</cfoutput>