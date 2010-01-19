<cfset servContent = transport.theApplication.factories.transient.getServContentForContent(transport.theApplication.managers.singleton.getApplication().getDSUpdate(), transport) />

<!--- Retrieve the object --->
<cfset content = servContent.getContent( session.managers.singleton.getUser(), theURL.search('content') ) />

<cfif cgi.request_method eq 'post'>
	<!--- Process the form submission --->
</cfif>