<cfset servContent = services.get('content', 'content') />

<cfset path = theUrl.search('path') />

<!--- Clear the cache --->
<cfset servContent.deleteCacheKey( path ) />

<!--- Redirect --->
<cfset theURL.setRedirect('_base', '/admin/content/caching/list') />

<cfset theURL.redirectRedirect() />
