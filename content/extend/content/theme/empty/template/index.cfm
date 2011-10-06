<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		
		<title><cfoutput>#template.getHTMltitle()#</cfoutput></title>
	</head>
	<body>
		<h2><cfoutput>#template.getPageTitle()#</cfoutput></h2>
		
		<!--- Show any messages, errors, warnings, or successes --->
		<cfset messages = session.managers.singleton.getError() />
		
		<cfoutput>#messages.toHTML()#</cfoutput>
		
		<cfset messages = session.managers.singleton.getWarning() />
		
		<cfoutput>#messages.toHTML()#</cfoutput>
		
		<cfset messages = session.managers.singleton.getSuccess() />
		
		<cfoutput>#messages.toHTML()#</cfoutput>
		
		<cfset messages = session.managers.singleton.getMessage() />
		
		<cfoutput>#messages.toHTML()#</cfoutput>
		
		<!--- Output the main content --->
		<cfoutput>#template.getContent()#</cfoutput>
	</body>
</html>
