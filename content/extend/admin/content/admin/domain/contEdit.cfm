<cfset viewDomain = transport.theApplication.factories.transient.getViewDomainForContent( transport ) />

<cfoutput>
	#viewDomain.edit(domain, form)#
</cfoutput>