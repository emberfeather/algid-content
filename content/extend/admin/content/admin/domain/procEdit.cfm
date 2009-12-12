<cfset servDomain = transport.theApplication.factories.transient.getServDomainForContent(application.app.getDSUpdate(), transport) />

<!--- Retrieve the object --->
<cfset domain = servDomain.getDomain( session.managers.singleton.getUser(), theURL.searchID('domain') ) />

<cfif CGI.REQUEST_METHOD EQ 'post'>
	<!--- Process the form submission --->
	<cfset domain.deserialize(FORM) />
	
	<cfset servDomain.setDomain( session.managers.singleton.getUser(), domain ) />
	
	<!--- Add a success message --->
	<cfset session.managers.singleton.getSuccess().addMessages('The domain ''' & domain.getDomain() & ''' was successfully saved.') />
	
	<!--- Redirect --->
	<cfset theURL.setRedirect('_base', '.admin.domain.list') />
	<cfset theURL.removeRedirect('domain') />
	
	<cflocation url="#theURL.getRedirect(false)#" addtoken="false" />
</cfif>