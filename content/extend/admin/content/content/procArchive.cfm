<cfset servContent = services.get('content', 'content') />

<!--- Retrieve the object --->
<cfset user = transport.theSession.managers.singleton.getUser() />
<cfset content = servContent.getContent( user, theURL.search('content') ) />

<cfset servContent.archiveContent( user, content ) />

<!--- Add a success message --->
<cfset session.managers.singleton.getSuccess().addMessages('The ''' & content.getTitle() & ''' content was successfully archived.') />

<!--- Redirect --->
<cfset theURL.setRedirect('_base', '/content/browse') />
<cfset theURL.removeRedirect('content') />

<cfset theURL.redirectRedirect() />
