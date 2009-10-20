<cfset viewContent = application.factories.transient.getViewContentForContent( transport ) />

<cfset filter = {
		domain = CGI.SERVER_NAME,
		orderBy = 'path'
	} />

<!--- TODO Tree-based navigation --->
<cfset contents = servContent.getContents( filter ) />

<cfoutput>#viewContent.list( contents )#</cfoutput>