<cfset viewContent = application.factories.transient.getViewContentForContent( transport ) />

<cfset filter = {
		domain = CGI.SERVER_NAME
	} />

<cfset contents = servContent.getContents( filter ) />

<cfif contents.recordCount>
	<cfoutput>#viewContent.list( contents )#</cfoutput>
</cfif>

<cfset filter = {
		domain = CGI.SERVER_NAME,
		limit = 7,
		orderBy = 'updatedOn',
		orderSort = 'desc'
	} />

<cfset contents = servContent.getContents( filter ) />

<cfif contents.recordCount>
	<cfoutput>#viewContent.list( contents )#</cfoutput>
</cfif>

<p>
	TODO: Statistics about the number of pages, users making changes, average page age, etc.
</p>