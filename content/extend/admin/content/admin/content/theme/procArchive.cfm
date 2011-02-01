<cfset servTheme = services.get('content', 'theme') />

<cfif cgi.request_method eq 'post'>
	<!--- Update the URL and redirect --->
	<cfloop list="#form.fieldnames#" index="field">
		<cfset theURL.set('', field, form[field]) />
	</cfloop>
	
	<cfset theURL.redirect() />
</cfif>

<cfif theUrl.search('theme') neq ''>
	<cfset theme = servTheme.getTheme( transport.theSession.managers.singleton.getUser(), theUrl.search('theme')) />
	
	<cfset servTheme.archiveTheme( transport.theSession.managers.singleton.getUser(), theme ) />
	
	<!--- Redirect --->
	<cfset theURL.setRedirect('_base', '/admin/content/theme/list') />
	<cfset theURL.removeRedirect('theme') />
	
	<cfset theURL.redirectRedirect() />
</cfif>

<!--- Add a error message --->
<cfset transport.theSession.managers.singleton.getError().addMessages('No theme was given to be archived.') />

<!--- Redirect --->
<cfset theURL.setRedirect('_base', '/admin/content/theme/list') />
<cfset theURL.redirectRedirect() />
