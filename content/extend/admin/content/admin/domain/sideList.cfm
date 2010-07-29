<cfset viewDomain = views.get('content', 'domain') />

<cfset filter = {
		'isArchived' = theURL.searchBoolean('isArchived'),
		'search' = theURL.search('search')
	} />

<cfoutput>
	#viewDomain.filter( filter )#
</cfoutput>