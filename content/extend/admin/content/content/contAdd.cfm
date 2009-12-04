<cfset viewContent = transport.theApplication.factories.transient.getViewContentForContent( transport ) />

<cfset domains = servDomain.getDomains() />

<cfoutput>
	#viewContent.add(domains, FORM)#
</cfoutput>