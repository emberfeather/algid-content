<cfset servDomain = application.factories.transient.getServDomainForContent(application.app.getDSUpdate(), transport) />

<!--- Retrieve the object --->
<cfset domain = servDomain.getDomain( SESSION.managers.singleton.getUser(), theURL.searchID('domain') ) />

<cfif CGI.REQUEST_METHOD EQ 'post'>
	<!--- Process the form submission --->
	<cfset domain.deserialize(FORM) />
	
	<cfset servDomain.setDomain( SESSION.managers.singleton.getUser(), domain ) />
	
	<!--- Redirect --->
	<cfset theURL.setRedirect('_base', '.admin.domain.list') />
	
	<cflocation url="#theURL.getRedirect(false)#" addtoken="false" />
</cfif>