<cfset servNavigation = services.get('content', 'navigation') />
<cfset servPath = services.get('content', 'path') />
<cfset servTheme = services.get('content', 'theme') />

<cfif cgi.request_method eq 'post'>
	<!--- Update the URL and redirect --->
	<cfloop list="#form.fieldnames#" index="field">
		<cfset theURL.set('', field, form[field]) />
	</cfloop>
	
	<cfset theURL.redirect() />
</cfif>

<!--- TODO minimized versions for production --->
<cfset template.addScripts('../plugins/content/script/navigation.js') />
<cfset template.addStyle('../plugins/content/style/navigation.css') />

<cfset basePath = theUrl.search('path') />

<cfif basePath eq ''>
	<cfset basePath = '/' />
</cfif>

<cfset paths = servPath.getPaths({ path = basePath }) />

<!--- Not a valid path --->
<cfif not len(paths.pathID.toString())>
	<cfthrow type="forbidden" message="Path was not found" detail="Could not find the '#basePath#' path" />
</cfif>

<cfset user = transport.theSession.managers.singleton.getUser() />
<cfset currentPath = servPath.getPath( user, paths.pathID.toString() ) />
