<cfset servContent = services.get('content', 'content') />

<!--- Retrieve the object --->
<cfset user = transport.theSession.managers.singleton.getUser() />
<cfset content = servContent.getContent( user, theURL.search('content') ) />

<cfset servContent.archiveContent( user, content ) />

<!--- Redirect --->
<cfset theURL.setRedirect('_base', '/content/browse') />
<cfset theURL.removeRedirect('content') />

<cfset theURL.redirectRedirect() />
