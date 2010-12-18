<cfset servContent = services.get('content', 'content') />
<cfset servDomain = services.get('content', 'domain') />

<!--- Check for existing domains --->
<cfset domains = servDomain.getDomains() />

<!--- If no domains redirect to the domain add page with message --->
<cfif domains.recordCount eq 0>
	<cfset message = transport.theSession.managers.singleton.getMessage() />
	
	<!--- TODO Use i18n --->
	<cfset message.addMessages('A domain is needed before adding content.') />
	
	<cfset theUrl.setRedirect('_base', '/admin/domain/add') />
	
	<cfset theURL.redirectRedirect() />
</cfif>

<!--- Check for form submission --->
<cfif cgi.request_method eq 'post'>
	<!--- Create new content for each title given in the domain --->
	<cfset numContent = 0 />
	
	<cfset user = transport.theSession.managers.singleton.getUser() />
	
	<!--- Find all titles and create content for each --->
	<cfloop list="#form.fieldnames#" index="i">
		<cfif left(i, 5) eq 'title' and trim(form[i]) neq ''>
			<cfset content = servContent.getContent( user, '' ) />
			
			<!--- Set the domainID --->
			<cfset content.setDomainID(form.domainID) />
			
			<!--- Set the title --->
			<cfset content.setTitle(form[i]) />
			
			<cfset servContent.setContent( user, content ) />
			
			<cfset numContent++ />
		</cfif>
	</cfloop>
	
	<!--- Add a success message --->
	<cfif numContent gt 1>
		<!--- TODO Use i18n --->
		<cfset session.managers.singleton.getSuccess().addMessages('Successfully added ' & numContent & ' new pages.') />
		<cfset theURL.setRedirect('_base', '/content/browse') />
	<cfelse>
		<cfset theURL.setRedirect('content', content.getContentID()) />
		<cfset theURL.setRedirect('_base', '/content/edit') />
	</cfif>
	
	<!--- Redirect --->
	<cfset theURL.removeRedirect('domain') />
	
	<cfset theURL.redirectRedirect() />
</cfif>
