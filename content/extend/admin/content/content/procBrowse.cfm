<cfset servContent = services.get('content', 'content') />
<cfset servDomain = services.get('content', 'domain') />
<cfset servType = services.get('content', 'type') />

<cfif cgi.request_method eq 'post'>
	<!--- Update the URL and redirect --->
	<cfloop list="#form.fieldnames#" index="field">
		<cfset theURL.set('', field, form[field]) />
	</cfloop>
	
	<cfset theURL.redirect() />
</cfif>
