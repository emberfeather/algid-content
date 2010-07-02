<cfset servContent = transport.theApplication.factories.transient.getServContentForContent(transport.theApplication.managers.singleton.getApplication().getDSUpdate(), transport) />
<cfset servType = transport.theApplication.factories.transient.getServTypeForContent(transport.theApplication.managers.singleton.getApplication().getDSUpdate(), transport) />

<!--- Retrieve the object --->
<cfset content = servContent.getContent( session.managers.singleton.getUser(), theURL.search('content') ) />

<cfif cgi.request_method eq 'post'>
	<!--- Process the form submission --->
	<cfset objectSerial.deserialize(form, content) />
	
	<!--- Find all paths --->
	<cfloop list="#form.fieldnames#" index="i">
		<cfif left(i, 4) eq 'path' and not right(i, 3) eq '_id' and trim(form[i]) neq ''>
			<!--- Check if we were provided an id to edit --->
				<!--- Get the path from the contentID/create a new path --->
				<cfset servContent.getPath( content, (structKeyExists(form, i & '_id') ? form[i & '_id'] : ''), form[i] ) />
		</cfif>
	</cfloop>
	
	<cfset user = session.managers.singleton.getUser() />
	
	<cfset servContent.setContent( user, content ) />
	
	<!--- Add a success message --->
	<!--- TODO use i18n --->
	<cfset session.managers.singleton.getSuccess().addMessages('The ''' & content.getTitle() & ''' content was successfully saved.') />
	
	<!--- Redirect --->
	<cfset theURL.setRedirect('_base', '/content/browse') />
	<cfset theURL.removeRedirect('content') />
	
	<cfset theURL.redirectRedirect() />
</cfif>

<cfset template.addScripts('../plugins/content/script/contentEdit.js') />
