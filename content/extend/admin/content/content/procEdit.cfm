<cfset servContent = services.get('content', 'content') />
<cfset servDomain = services.get('content', 'domain') />
<cfset servMeta = services.get('content', 'meta') />
<cfset servPath = services.get('content', 'path') />
<cfset servType = services.get('content', 'type') />

<!--- Retrieve the object --->
<cfset content = servContent.getContent( theURL.search('content') ) />

<cfif cgi.request_method eq 'post'>
	<cfset fields = listSort(form.fieldnames, 'text') />
	
	<!--- Process the form submission --->
	<cfset modelSerial.deserialize(form, content) />
	
	<cfset servContent.setContent( content ) />
	
	<!--- Find/Update all paths --->
	<cfset usedPaths = [] />
	
	<!--- Removed cached content --->
	<cfset domain = servDomain.getDomain(content.getDomainID()) />
	
	<cfloop list="#form.fieldnames#" index="i">
		<cfif left(i, 4) eq 'path' and not right(i, 3) eq '_id' and trim(form[i]) neq ''>
			<!--- Check if we were provided an id to edit --->
			<!--- Get the path from the contentID/create a new path --->
			<cfset path = servPath.getPath((structKeyExists(form, i & '_id') ? form[i & '_id'] : '')) />
			
			<cfset path.setPath(form[i]) />
			
			<cfif path.getPathID() eq ''>
				<cfset path.setContentID(content.getContentID()) />
				<cfset path.setTitle(content.getTitle()) />
			</cfif>
			
			<cfset servPath.setPath(path) />
			
			<cfset arrayAppend(usedPaths, path.getPathID()) />
			
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
	
	<cfset servPath.deletePaths(filter) />
	
	<!--- Handle Metadata --->
	
	<!--- Transform  --->
	<cfset fieldname = 'meta' />
	<cfset fieldnameLen = len(fieldname) />
	<cfset fieldnameExp = '(name)(-clone[0-9]*)?$' />
	
	<cfset metas = [] />
	
	<cfloop array="#[ '^meta[0-9]+', '^meta\..*[^0-9]$', '^meta\..*clone[0-9]+$' ]#" index="fieldExp">
		<cfloop list="#fields#" index="i">
			<cfif reFind(fieldExp, i) and refind(fieldnameExp, i) and trim(form[i]) neq ''>
				<cfset meta = servMeta.getMeta(form[reReplace(i, fieldnameExp, 'id\2')]) />
				
				<cfset modelSerial.deserialize({
					'name': form[i],
					'contentID': content.getContentId(),
					'value': form[reReplace(i, fieldnameExp, 'value\2')]
				}, meta) />
				
				<cfset servMeta.setMeta(meta) />
				
				<cfset arrayAppend(metas, meta.getMetaId()) />
			</cfif>
		</cfloop>
	</cfloop>
	
	<!--- Remove deleted metas --->
	<cfif arrayLen(metas)>
		<cfset servMeta.deleteMetas({
			contentId: content.getContentID(),
			notIn: metas
		}) />
	</cfif>
	
	<!--- Redirect --->
	<cfset theURL.setRedirect('_base', '/content/browse') />
	<cfset theURL.removeRedirect('content') />
	
	<cfset theURL.redirectRedirect() />
</cfif>

<cfset template.addScripts('../plugins/content/script/contentEdit.js') />
