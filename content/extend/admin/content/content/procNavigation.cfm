<cfset servNavigation = services.get('content', 'navigation') />
<cfset servPath = services.get('content', 'path') />
<cfset servTheme = services.get('content', 'theme') />

<cfif cgi.request_method eq 'post'>
	<!--- TODO handle the submission --->
	
	<!--- Add a success message --->
	<!--- TODO use i18n --->
	<cfset session.managers.singleton.getSuccess().addMessages('The navigation for the ''' & ''' path was successfully saved.') />
</cfif>

<!--- TODO minimized versions for production --->
<cfset template.addScripts('../plugins/content/script/navigation.js') />
<cfset template.addStyle('../plugins/content/style/navigation.css') />
