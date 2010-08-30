<cfset viewContent = views.get('content', 'content') />

<cfoutput>
	#viewContent.caching( cachedIds )#
</cfoutput>
