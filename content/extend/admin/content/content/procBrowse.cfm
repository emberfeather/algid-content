<cfset servContent = transport.theApplication.factories.transient.getServContentForContent(application.app.getDSUpdate(), transport) />

<cfif CGI.ReqUEST_METHOD eq 'post'>
	<!--- Update the URL and redirect --->
	<cfloop list="#ForM.fieldnames#" index="field">
		<cfset theURL.set('', field, ForM[field]) />
	</cfloop>
	
	<cflocation url="#theURL.get('', false)#" addtoken="false" />
</cfif>