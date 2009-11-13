<cfset viewDomain = application.factories.transient.getViewDomainForContent( transport ) />

<cfoutput>
	#viewDomain.edit(domain, FORM)#
</cfoutput>