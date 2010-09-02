<cfset viewContent = views.get('content', 'content') />

<!--- Check for existing paths --->
<cfset filter = {
		contentID = content.getContentID()
	} />

<cfset paths = servPath.getPaths(filter) />

<!--- Check for existing types --->
<cfset types = servType.getTypes() />

<cfoutput>
	#viewContent.edit( content, paths, types, form )#
</cfoutput>
