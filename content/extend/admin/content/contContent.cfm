<cfset viewContent = createObject('component', 'plugins.content.inc.view.viewContent').init(theURL) />

<cfset filter = {
	} />

<cfset contents = servContent.getContents( filter ) />

<cfif contents.recordCount>
	<h3>Expired Content</h3>
	
	<cfoutput>#viewContent.list( contents, filter )#</cfoutput>
</cfif>

<h3>Recent Changes</h3>

<p>
	List of recent pages updated and who updated them...
</p>

<h3>Statistics</h3>

<p>
	Statistics about the number of pages, users making changes, average page age, etc.
</p>