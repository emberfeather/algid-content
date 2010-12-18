<cfset servTheme = services.get('content', 'theme') />
<cfset servNavigation = services.get('content', 'navigation') />

<cfif cgi.request_method eq 'post'>
	<!--- Update the URL and redirect --->
	<cfloop list="#form.fieldnames#" index="field">
		<cfset theURL.set('', field, form[field]) />
	</cfloop>
	
	<cfset theURL.redirect() />
</cfif>

<cfif theUrl.search('theme') neq ''>
	<cfset theme = servTheme.getTheme( transport.theSession.managers.singleton.getUser(), theUrl.search('theme')) />
	
	<!--- Reread the theme from the file system --->
	<cfset theme = servTheme.readTheme( theme.getPlugin(), theme.getThemeKey() ) />
	
	<cfset servTheme.setTheme( transport.theSession.managers.singleton.getUser(), theme ) />
	
	<!--- Update the navigation --->
	<cfloop array="#theme.getNavigation()#" index="i">
		<cfset servNavigation.setNavigation(transport.theSession.managers.singleton.getUser(), i) />
	</cfloop>
	
	<!--- Add a success message --->
	<cfset transport.theSession.managers.singleton.getSuccess().addMessages('The theme ''' & theme.getTheme() & ''' was successfully updated.') />
	
	<!--- Redirect --->
	<cfset theURL.setRedirect('_base', '/admin/content/theme/list') />
	<cfset theURL.removeRedirect('theme') />
	
	<cfset theURL.redirectRedirect() />
</cfif>

<!--- Add a error message --->
<cfset transport.theSession.managers.singleton.getError().addMessages('No theme was given to be updated.') />

<!--- Redirect --->
<cfset theURL.setRedirect('_base', '/admin/content/theme/list') />

<cfset theURL.redirectRedirect() />
