<cfset viewDomain = views.get('content', 'domain') />

<!--- Check for existing paths --->
<cfset filter = {
	domainID = domain.getDomainID()
} />

<cfset hosts = servDomain.getHosts(filter) />

<cfoutput>
	#viewDomain.edit(domain, hosts)#
</cfoutput>
