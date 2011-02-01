<cfset viewNavigation = views.get('content', 'navigation') />

<cfset currentLevel = 1 />

<cfset pathThemes = servTheme.getThemes({
	alongPath = currentPath.getPath(),
	orderBy = 'path',
	orderSort = 'desc',
	domain = transport.theCgi.server_name
}) />

<cfset currentThemeID = '' />

<cfloop query="pathThemes">
	<cfset currentThemeID = pathThemes.themeID.toString() />
	
	<cfif currentThemeID neq ''>
		<cfset currentLevel = 1 />
		<cfif pathThemes.path neq currentPath.getPath()>
			<cfset currentLevel += listLen('/' & right(currentPath.getPath(), len(currentPath.getPath()) - len(pathThemes.path)), '/') />
		</cfif>
		
		<cfbreak />
	</cfif>
</cfloop>

<cfif currentThemeID eq ''>
	<!--- TODO Default to the default theme and update the path --->
	No Theme for Path
	<cfabort />
</cfif>

<cfset themes = servTheme.getThemes() />

<cfset hiddenPaths = servPath.getPaths({
	navigationID = 'NULL',
	pathPrefix = currentPath.getPath(),
	notPath = currentPath.getPath(),
	oneLevelOnly = true
}) />

<cfset navigation = servNavigation.getNavigations({
	themeID = currentThemeID,
	level = currentLevel
}) />

<cfset paths = [] />

<cfloop query="navigation">
	<cfset arrayAppend(paths, servPath.getPaths({
		navigationID = navigation.navigationID.toString(),
		pathPrefix = currentPath.getPath(),
		notPath = currentPath.getPath(),
		oneLevelOnly = true,
		orderBy = 'orderBy'
	})) />
</cfloop>

<cfoutput>#viewNavigation.navigation(themes, currentPath, hiddenPaths, navigation, paths)#</cfoutput>
