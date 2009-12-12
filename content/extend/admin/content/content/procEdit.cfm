<cfset servContent = transport.theApplication.factories.transient.getServContentForContent(application.app.getDSUpdate(), transport) />

<!--- Retrieve the object --->
<cfset content = servContent.getContent( session.managers.singleton.getUser(), theURL.searchID('content') ) />

<cfif cgi.request_method eq 'post'>
	<!--- Process the form submission --->
</cfif>