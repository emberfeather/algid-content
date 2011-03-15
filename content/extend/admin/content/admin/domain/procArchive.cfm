<cfset servDomain = services.get('content', 'domain') />

<!--- Retrieve the object --->
<cfset domain = servDomain.getDomain( theURL.search('domain') ) />

<cfset servDomain.archiveDomain( domain ) />

<!--- Redirect --->
<cfset theURL.setRedirect('_base', '/admin/domain/list') />
<cfset theURL.removeRedirect('domain') />

<cfset theURL.redirectRedirect() />
