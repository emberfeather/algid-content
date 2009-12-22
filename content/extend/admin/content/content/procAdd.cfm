<cfset servDomain = transport.theApplication.factories.transient.getServDomainForContent(transport.theApplication.managers.singleton.getApplication().getDSUpdate(), transport) />



<!--- Check for form submission --->
<cfif cgi.request_method eq 'post'>
	<!--- TODO Create a new content object --->
</cfif>
