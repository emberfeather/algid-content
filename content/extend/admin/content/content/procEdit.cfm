<cfset servContent = transport.theApplication.factories.transient.getServContentForContent(application.app.getDSUpdate(), transport) />

<!--- Retrieve the object --->
<cfset content = servContent.getContent( session.managers.singleton.getUser(), theURL.searchID('content') ) />

<cfif CGI.ReqUEST_METHOD eq 'post'>
	<!--- Process the form submission --->
</cfif>