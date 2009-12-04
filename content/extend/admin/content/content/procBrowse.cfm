<cfset servContent = transport.theApplication.factories.transient.getServContentForContent(application.app.getDSUpdate(), transport) />

<cfif CGI.REQUEST_METHOD EQ 'post'>
	<!--- Update the URL and redirect --->
	<cfloop list="#FORM.fieldnames#" index="field">
		<cfset theURL.set('', field, FORM[field]) />
	</cfloop>
	
	<cflocation url="#theURL.get('', false)#" addtoken="false" />
</cfif>