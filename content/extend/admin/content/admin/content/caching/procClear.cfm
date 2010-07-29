<cfset servContent = service.get('content', 'content') />

<!--- Clear the cache --->
<cfset servContent.clearCache() />

<!--- Add a success message --->
<!--- TODO Use i18n --->
<cfset session.managers.singleton.getSuccess().addMessages('Cleared the content cache successfully.') />

<!--- Redirect --->
<cfset theURL.setRedirect('_base', '/admin/content/caching/list') />

<cfset theURL.redirectRedirect() />
