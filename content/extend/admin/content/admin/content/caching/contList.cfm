<cfset viewContent = transport.theApplication.factories.transient.getViewContentForContent( transport ) />

<cfoutput>
	#viewContent.caching( cachedIds )#
</cfoutput>
