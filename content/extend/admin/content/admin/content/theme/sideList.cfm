<cfset viewTheme = views.get('content', 'theme') />

<cfset filter = {
		'isArchived' = false,
		'search' = theURL.search('search')
	} />

<cfoutput>
	#viewTheme.filter( filter )#
</cfoutput>
