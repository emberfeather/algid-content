<cfset servContent = services.get('content', 'content') />

<!--- Clear the cache --->
<cfset servContent.clearCache() />

<!--- Redirect --->
<cfset theURL.setRedirect('_base', '/admin/content/caching/list') />

<cfset theURL.redirectRedirect() />
