<cfset servDomain = services.get('content', 'domain') />

<!--- Retrieve the object --->
<cfset domain = servDomain.getDomain( transport.theSession.managers.singleton.getUser(), theURL.search('domain') ) />

<cfif cgi.request_method eq 'post'>
	<!--- Process the form submission --->
	<cfset modelSerial.deserialize(form, domain) />
	
	<cfset servDomain.setDomain( transport.theSession.managers.singleton.getUser(), domain ) />
	
	<!--- Check to make sure there is a host defined for the domain --->
	<cfif not arrayLen(domain.getHosts())>
		<cfset host = servDomain.getHost( transport.theSession.managers.singleton.getUser(), domain.getDomain() ) />
		
		<cfset host.setDomainID(domain.getDomainID()) />
		<cfset host.setHostname(domain.getDomain()) />
		<cfset host.setIsPrimary(true) />
		
		<cfset domain.addHosts(host) />
		
		<cfset servDomain.setHosts( transport.theSession.managers.singleton.getUser(), domain.getHosts() ) />
	</cfif>
	
	<!--- Add a success message --->
	<cfset transport.theSession.managers.singleton.getSuccess().addMessages('The domain ''' & domain.getDomain() & ''' was successfully saved.') />
	
	<!--- Redirect --->
	<cfset theURL.setRedirect('_base', '/admin/domain/list') />
	<cfset theURL.removeRedirect('domain') />
	
	<cfset theURL.redirectRedirect() />
</cfif>