<cfset viewContent = application.managers.transient.getViewContentForContent(theURL) />

<cfset filter = {
		domain = CGI.SERVER_NAME,
		orderBy = 'path'
	} />

<!--- TODO Tree-based navigation --->
<cfset contents = servContent.getContents( filter ) />

<cfoutput>#viewContent.list( contents, filter )#</cfoutput>