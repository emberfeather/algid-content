<cfset servTheme = services.get('content', 'theme') />
<cfset servNavigation = services.get('content', 'navigation') />

<cfif cgi.request_method eq 'post'>
	<!--- Update the URL and redirect --->
	<cfloop list="#form.fieldnames#" index="field">
		<cfset theURL.set('', field, form[field]) />
	</cfloop>
	
	<cfset theURL.redirect() />
</cfif>

<cfif theUrl.search('plugin') neq '' and theUrl.search('themeDirectory') neq ''>
	<cfset theme = servTheme.readTheme(theUrl.search('plugin'), theUrl.search('themeDirectory')) />
	
	<cfset servTheme.setTheme( transport.theSession.managers.singleton.getUser(), theme ) />
	
	<!--- Update the navigation --->
	<cfloop array="#theme.getNavigation()#" index="i">
		<cfset servNavigation.setNavigation(transport.theSession.managers.singleton.getUser(), i) />
	</cfloop>
	
	<!--- Add a success message --->
	<cfset transport.theSession.managers.singleton.getSuccess().addMessages('The theme ''' & theme.getTheme() & ''' was successfully saved.') />
	
	<!--- Redirect --->
	<cfset theURL.setRedirect('_base', '/admin/content/theme/list') />
	<cfset theURL.removeRedirect('plugin') />
	<cfset theURL.removeRedirect('themeDirectory') />
	
	<cfset theURL.redirectRedirect() />
</cfif>