<cfset viewContent = transport.theApplication.factories.transient.getViewContentForContent( transport ) />

<cfoutput>
	#viewContent.edit( content )#
</cfoutput>