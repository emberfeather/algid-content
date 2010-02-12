<cfset servDomain = transport.theApplication.factories.transient.getServDomainForContent(transport.theApplication.managers.singleton.getApplication().getDSUpdate(), transport) />

<!--- Retrieve the object --->
<cfset domain = servDomain.getDomain( session.managers.singleton.getUser(), theURL.search('domain') ) />

<cfset servDomain.archiveDomain( session.managers.singleton.getUser(), domain ) />

<!--- Add a success message --->
<cfset session.managers.singleton.getSuccess().addMessages('The domain ''' & domain.getDomain() & ''' was successfully removed.') />

<!--- Redirect --->
<cfset theURL.setRedirect('_base', '/admin/domain/list') />
<cfset theURL.removeRedirect('domain') />

<cfset theURL.redirectRedirect() />
