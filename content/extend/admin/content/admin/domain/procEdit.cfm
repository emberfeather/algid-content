<cfset servDomain = services.get('content', 'domain') />

<!--- Retrieve the object --->
<cfset user = transport.theSession.managers.singleton.getUser() />
<cfset domain = servDomain.getDomain( user, theURL.search('domain') ) />

<cfif cgi.request_method eq 'post'>
	<!--- Process the form submission --->
	<cfset modelSerial.deserialize(form, domain) />
	
	<cfset servDomain.setDomain( user, domain ) />
	
	<!--- Find/Update all hosts --->
	<cfset usedHosts = [] />
	
	<cfloop list="#form.fieldnames#" index="i">
		<cfif left(i, 4) eq 'host' and not right(i, 3) eq '_id' and trim(form[i]) neq ''>
			<!--- Check if we were provided an id to edit --->
			<!--- Get the host from the contentID/create a new host --->
			<cfset host = servDomain.getHost(user, (structKeyExists(form, i & '_id') ? form[i & '_id'] : '')) />
			
			<cfset host.setHostname(form[i]) />
			
			<cfif host.getHostID() eq ''>
				<cfset host.setDomainID(domain.getDomainID()) />
			</cfif>
			
			<cfset servDomain.setHosts(user, [ host ]) />
			
			<cfset arrayAppend(usedHosts, host.getHostID()) />
		</cfif>
	</cfloop>
	
	<!--- Remove any unused hosts from the domain --->
	<cfset filter = {
		domainID = domain.getDomainID(), 
		notIn = usedHosts
	} />
	
	<cfset servDomain.deleteHosts(user, filter) />
	
	<!--- Check to make sure there is a host defined for the domain --->
	<cfif not arrayLen(usedHosts)>
		<cfset host = servDomain.getHost( user, '' ) />
		
		<cfset host.setDomainID(domain.getDomainID()) />
		<cfset host.setHostname(domain.getDomain()) />
		<cfset host.setIsPrimary(true) />
		
		<cfset servDomain.setHosts( user, [ host ] ) />
	</cfif>
	
	<!--- Add a success message --->
	<cfset transport.theSession.managers.singleton.getSuccess().addMessages('The domain ''' & domain.getDomain() & ''' was successfully saved.') />
	
	<!--- Redirect --->
	<cfset theURL.setRedirect('_base', '/admin/domain/list') />
	<cfset theURL.removeRedirect('domain') />
	
	<cfset theURL.redirectRedirect() />
</cfif>