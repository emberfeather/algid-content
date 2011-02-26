<cfset servContent = services.get('content', 'content') />

<!--- Retrieve the object --->
<cfset content = servContent.getContent( theURL.search('content') ) />

<cfset servContent.archiveContent( content ) />

<!--- Redirect --->
<cfset theURL.setRedirect('_base', '/content/browse') />
<cfset theURL.removeRedirect('content') />

<cfset theURL.redirectRedirect() />
