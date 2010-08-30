<cfset viewContent = views.get('content', 'content') />

<!--- Check for existing types --->
<cfset types = servType.getTypes() />

<cfoutput>
	#viewContent.edit( content, types, form )#
</cfoutput>
