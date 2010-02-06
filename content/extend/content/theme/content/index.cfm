<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		
		<title><cfoutput>#template.getHTMltitle()#</cfoutput></title>
		
		<!--- Include minified files for production --->
		<cfset midfix = (transport.theApplication.managers.singleton.getApplication().isProduction() ? '-min' : '') />
		
		<cfset template.addStyles('plugins/admin/style/960/reset#midfix#.css', 'plugins/admin/style/960/960#midfix#.css"', 'plugins/content/extend/content/theme/content/style/styles#midfix#.css') />
		<cfset template.addStyle('plugins/content/extend/content/theme/content/style/print#midfix#.css', 'print') />
		
		<cfset template.addScripts('plugins/content/extend/content/theme/content/script/content#midfix#.js') />
		
		<cfoutput>#template.getStyles()#</cfoutput>
	</head>
	<body>
		<div class="container_12">
			<div class="grid_12">
				<h2><cfoutput>#template.getPageTitle()#</cfoutput></h2>
			</div>
			
			<div class="grid_12">
				<!--- Show any messages, errors, warnings, or successes --->
				<cfset messages = session.managers.singleton.getError() />
				
				<cfoutput>#messages.toHTML()#</cfoutput>
				
				<cfset messages = session.managers.singleton.getWarning() />
				
				<cfoutput>#messages.toHTML()#</cfoutput>
				
				<cfset messages = session.managers.singleton.getSuccess() />
				
				<cfoutput>#messages.toHTML()#</cfoutput>
				
				<cfset messages = session.managers.singleton.getMessage() />
				
				<cfoutput>#messages.toHTML()#</cfoutput>
				
				<div class="clear"><!-- clear --></div>
			</div>
			
			<div class="grid_12">
				<!--- Output the main content --->
				<cfoutput>#template.getContent()#</cfoutput>
			</div>
			
			<div class="grid_12 align-center">
				Powered by <a href="http://code.google.com/p/algid/" title="Algid CFML Framework">Algid</a>.
			</div>
			
			<div class="clear"><!-- clear --></div>
		</div>
		
		<cfoutput>#template.getScripts()#</cfoutput>
	</body>
</html>