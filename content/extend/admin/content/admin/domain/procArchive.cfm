<cfset servDomain = application.factories.transient.getServDomainForContent(application.app.getDSUpdate(), transport) />

<!--- Retrieve the object --->
<cfset domain = servDomain.getDomain( SESSION.managers.singleton.getUser(), theURL.searchID('domain') ) />

<cfset servDomain.archiveDomain( SESSION.managers.singleton.getUser(), domain ) />

<!--- Add a success message --->
<cfset SESSION.managers.singleton.getSuccess().addMessages('The domain ''' & domain.getDomain() & ''' (' & domain.getDomainID() & ') was successfully removed.') />

<!--- Redirect --->
<cfset theURL.setRedirect('_base', '.admin.domain.list') />

<cflocation url="#theURL.getRedirect(false)#" addtoken="false" />
