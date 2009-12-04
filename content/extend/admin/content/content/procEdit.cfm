<cfset servContent = transport.theApplication.factories.transient.getServContentForContent(application.app.getDSUpdate(), transport) />

<!--- Retrieve the object --->
<cfset content = servContent.getContent( SESSION.managers.singleton.getUser(), theURL.searchID('content') ) />

<cfif CGI.REQUEST_METHOD EQ 'post'>
	<!--- Process the form submission --->
</cfif>