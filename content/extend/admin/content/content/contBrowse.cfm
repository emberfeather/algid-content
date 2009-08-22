<cfset viewContent = createObject('component', 'plugins.content.inc.view.viewContent').init(theURL) />

<cfset filter = {
		domain = CGI.SERVER_NAME,
		orderBy = 'path'
	} />

<!--- TODO Tree-based navigation --->
<cfset contents = servContent.getContents( filter ) />

<cfoutput>#viewContent.list( contents, filter )#</cfoutput>