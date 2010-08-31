<cfset servTheme = services.get('content', 'theme') />

<cfset allThemes = servTheme.readThemes() />

<!--- TODO Remove --->
<cfloop array="#allThemes#" index="i">
	<cfset i.print() />
</cfloop>
<cfabort />
