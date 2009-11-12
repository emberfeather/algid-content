<cfset viewContent = application.factories.transient.getViewContentForContent( transport ) />

<cfset domains = servDomain.getDomains() />

<cfoutput>
	#viewContent.add(domains, FORM)#
</cfoutput>