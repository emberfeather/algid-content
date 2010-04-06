<cfset servContent = transport.theApplication.factories.transient.getServContentForContent(transport.theApplication.managers.singleton.getApplication().getDSUpdate(), transport) />

<cfset path = theUrl.search('path') />

<!--- Clear the cache --->
<cfset servContent.deleteCacheKey( path ) />

<!--- Add a success message --->
<!--- TODO Use i18n --->
<cfset session.managers.singleton.getSuccess().addMessages('Deleted the content cache ''' & path & ''' key successfully.') />

<!--- Redirect --->
<cfset theURL.setRedirect('_base', '/admin/content/caching/list') />

<cfset theURL.redirectRedirect() />