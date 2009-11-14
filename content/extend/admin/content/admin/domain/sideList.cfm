<cfset viewDomain = application.factories.transient.getViewDomainForContent( transport ) />

<cfset filter = {
		'isArchived' = theURL.searchBoolean('isArchived'),
		'search' = theURL.search('search')
	} />

<cfoutput>
	#viewDomain.filter( filter )#
</cfoutput>