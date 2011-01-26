<cfset servDomain = services.get('content', 'domain') />

<!--- Retrieve the object --->
<cfset domain = servDomain.getDomain( session.managers.singleton.getUser(), theURL.search('domain') ) />

<cfset servDomain.archiveDomain( session.managers.singleton.getUser(), domain ) />

<!--- Redirect --->
<cfset theURL.setRedirect('_base', '/admin/domain/list') />
<cfset theURL.removeRedirect('domain') />

<cfset theURL.redirectRedirect() />
