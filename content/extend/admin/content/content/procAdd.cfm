<cfset servDomain = transport.theApplication.factories.transient.getServDomainForContent(transport.theApplication.managers.singleton.getApplication().getDSUpdate(), transport) />

<!--- Check for existing domains --->
<cfset domains = servDomain.getDomains() />

<!--- If no domains redirect to the domain add page with message --->
<cfif domains.recordCount eq 0>
	<cfset message = transport.theSession.managers.singleton.getMessage() />
	
	<!--- TODO Use i18n for message --->
	<cfset message.addMessages('A domain is needed before adding content.') />
	
	<cfset theUrl.setRedirect('_base', '.admin.domain.add') />
	
	<cflocation url="#theUrl.getRedirect(false)#" addtoken="false" />
</cfif>

<!--- Check for form submission --->
<cfif cgi.request_method eq 'post'>
	<!--- TODO Create a new content object --->
</cfif>
