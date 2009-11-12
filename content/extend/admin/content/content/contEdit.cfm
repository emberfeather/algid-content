<cfset viewContent = application.factories.transient.getViewContentForContent( transport ) />

<cfoutput>
	#viewContent.edit( content )#
</cfoutput>