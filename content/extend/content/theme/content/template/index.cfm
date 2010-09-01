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
			<div class="grid_12 no-print">
				<cfset options = {
						navClasses = ['menu horizontal float-right']
					} />
				
				<cfoutput>#template.getNavigation(transport.theCgi.server_name, 2, 'action', options, session.managers.singleton.getUser())#</cfoutput>
				
				<cfset options = {
						navClasses = ['menu horizontal']
					} />
				
				<cfoutput>#template.getNavigation(transport.theCgi.server_name, 1, 'main', options, session.managers.singleton.getUser())#</cfoutput>
				
				<div class="clear"><!-- clear --></div>
			</div>
			
			<div class="clear"><!-- clear --></div>
			
			<div id="breadcrumb" class="grid_12 no-print">
				<cfoutput>#template.getBreadcrumb()#</cfoutput>
				
				<div class="clear"><!-- clear --></div>
			</div>
			
			<div class="grid_12 no-print">
				<cfset showingNavigation = false />
				<cfset navLevel = template.getLevel() />
				
				<cfif navLevel gt 1>
					<cfset options = {
							navClasses = ['submenu horizontal float-right']
						} />
					
					<cfset subNav = trim(template.getNavigation( transport.theCgi.server_name, navLevel + 1, 'action', options, session.managers.singleton.getUser())) />
					
					<cfset showingNavigation = showingNavigation or subNav neq '' />
					
					<cfoutput>#subNav#</cfoutput>
				</cfif>
				
				<cfset options = {
						navClasses = ['submenu horizontal']
					} />
				
				<cfset subNav = trim(template.getNavigation( transport.theCgi.server_name, navLevel + 1, 'main', options, session.managers.singleton.getUser())) />
				
				<cfset showingNavigation = showingNavigation or subNav neq '' />
				
				<cfoutput>#subNav#</cfoutput>
				
				<!--- If there is not any navigation showing then show the actions for the current level --->
				<cfif navLevel gt 1 and not showingNavigation>
					<cfif navLevel gt 2>
						<cfset options = {
								navClasses = ['submenu horizontal float-right']
							} />
						
						<cfoutput>#template.getNavigation( transport.theCgi.server_name, navLevel, 'action', options, session.managers.singleton.getUser())#</cfoutput>
					</cfif>
					
					<cfset options = {
							navClasses = ['submenu horizontal']
						} />
					
					<cfoutput>#template.getNavigation( transport.theCgi.server_name, navLevel, 'main', options, session.managers.singleton.getUser())#</cfoutput>
				</cfif>
				
				<div class="clear"><!-- clear --></div>
			</div>
			
			<div class="grid_12">
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
				
				<div class="clear"><!-- clear --></div>
			</div>
			
			<div class="grid_12">
				<!--- Output the main content --->
				<cfoutput>#template.getContent()#</cfoutput>
			</div>
			
			<!--- TODO Remove --->
			<div class="grid_12 align-center">
				<cfoutput>#createUUID()#</cfoutput>
			</div>
			
			<div class="clear"><!-- clear --></div>
		</div>
		
		<cfoutput>#template.getScripts()#</cfoutput>
	</body>
</html>
