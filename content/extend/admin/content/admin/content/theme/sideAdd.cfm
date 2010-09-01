<cfset viewTheme = views.get('content', 'theme') />

<cfset filter = {
		'isExisting' = false,
		'search' = theURL.search('search')
	} />

<cfoutput>
	#viewTheme.filter( filter )#
</cfoutput>
