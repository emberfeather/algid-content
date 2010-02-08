<cfset servContent = transport.theApplication.factories.transient.getServContentForContent(transport.theApplication.managers.singleton.getApplication().getDSUpdate(), transport) />

<!--- Retrieve the object --->
<cfset content = servContent.getContent( session.managers.singleton.getUser(), theURL.search('content') ) />

<cfif cgi.request_method eq 'post'>
	<!--- Process the form submission --->
	<cfset objectSerial.deserialize(form, content) />
	
	<cfset servContent.setContent( session.managers.singleton.getUser(), content ) />
	
	<!--- Add a success message --->
	<cfset session.managers.singleton.getSuccess().addMessages('The ''' & content.getTitle() & ''' content was successfully saved.') />
	
	<!--- Redirect --->
	<cfset theURL.setRedirect('_base', '.content.browse') />
	<cfset theURL.removeRedirect('content') />
	
	<cfset theURL.redirectRedirect() />
</cfif>