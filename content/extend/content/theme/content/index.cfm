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
			<cfinclude template="partial.cfm" />
			
			<div class="grid_12 align-center">
				Powered by <a href="http://github.com/Zoramite/algid" title="Algid CFML Framework">Algid</a>.
			</div>
			
			<div class="clear"><!-- clear --></div>
		</div>
		
		<cfoutput>#template.getScripts()#</cfoutput>
	</body>
</html>
