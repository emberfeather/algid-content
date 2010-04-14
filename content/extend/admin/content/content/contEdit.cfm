<cfset viewContent = transport.theApplication.factories.transient.getViewContentForContent( transport ) />

<!--- Check for existing types --->
<cfset types = servType.getTypes() />

<cfoutput>
	#viewContent.edit( content, types, form )#
</cfoutput>
