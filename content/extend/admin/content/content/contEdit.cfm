<cfset viewContent = views.get('content', 'content') />

<!--- Check for existing paths --->
<cfset filter = {
	contentID: content.getContentID(),
	domainID: content.getDomainID(),
	orderBy: 'path',
	showNavigationFields: false
} />

<cfset paths = servPath.getPaths(filter) />

<!--- Check for existing metas --->
<cfset metas = servMeta.getMetas({
	contentID: content.getContentID()
}) />

<cfoutput>
	#viewContent.edit( content, paths, metas )#
</cfoutput>
