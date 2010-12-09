<cfset servContent = services.get('content', 'content') />
<cfset servDomain = services.get('content', 'domain') />
<cfset servPath = services.get('content', 'path') />
<cfset servType = services.get('content', 'type') />

<!--- Retrieve the object --->
<cfset content = servContent.getContent( session.managers.singleton.getUser(), theURL.search('content') ) />

<cfif cgi.request_method eq 'post'>
	<!--- Process the form submission --->
	<cfset modelSerial.deserialize(form, content) />
	
	<cfset user = transport.theSession.managers.singleton.getUser() />
	
	<cfset servContent.setContent( user, content ) />
	
	<!--- Find/Update all paths --->
	<cfset usedPaths = '' />
	
	<!--- Removed cached content --->
	<cfset domain = servDomain.getDomain(user, content.getDomainID()) />
	
	<cfloop list="#form.fieldnames#" index="i">
		<cfif left(i, 4) eq 'path' and not right(i, 3) eq '_id' and trim(form[i]) neq ''>
			<!--- Check if we were provided an id to edit --->
			<!--- Get the path from the contentID/create a new path --->
			<cfset path = servPath.getPath(user, (structKeyExists(form, i & '_id') ? form[i & '_id'] : '')) />
			
			<cfset path.setPath(form[i]) />
			
			<cfif path.getPathID() eq ''>
				<cfset path.setContentID(content.getContentID()) />
				<cfset path.setTitle(content.getTitle()) />
			</cfif>
			
			<cfset servPath.setPath(user, path) />
			
			<cfset usedPaths = listAppend(usedPaths, path.getPathID()) />
			
			<!--- Remove from content cache --->
			<cfset servContent.deleteCacheKey( domain.getDomain() & path.getPath() ) />
		</cfif>
	</cfloop>
	
	<!--- Remove any unused paths from the content --->
	<cfset filter = {
		contentID = content.getContentID(), 
		notIn = usedPaths
	} />
	
	<cfset deletedPaths = servPath.getPaths(filter) />
	
	<!--- Remove Deleted Paths From Cache --->
	<cfloop query="deletedPaths">
		<cfset servContent.deleteCacheKey( domain.getDomain() & deletedPaths.path ) />
	</cfloop>
	
	<cfset servPath.deletePaths(user, filter) />
	
	<!--- Add a success message --->
	<!--- TODO use i18n --->
	<cfset session.managers.singleton.getSuccess().addMessages('The ''' & content.getTitle() & ''' content was successfully saved.') />
	
	<!--- Redirect --->
	<cfset theURL.setRedirect('_base', '/content/browse') />
	<cfset theURL.removeRedirect('content') />
	
	<cfset theURL.redirectRedirect() />
</cfif>

<cfset template.addScripts('../plugins/content/script/contentEdit.js') />
