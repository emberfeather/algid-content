<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		
		<title><cfoutput>#template.getHTMltitle()#</cfoutput></title>
		
		<cfsilent>
			<cfset user = transport.theSession.managers.singleton.getUser() />
			
			<!--- Include minified files for production --->
			<cfif transport.theApplication.managers.singleton.getApplication().isProduction()>
				<cfset template.addStyles('/cf-compendium/style/cf-compendium-min.css') />
				<cfset template.addScripts('/cf-compendium/script/jquery.cf-compendium-min.js') />
				<cfset midfix = '-min' />
			<cfelse>
				<cfset template.addStyles('/cf-compendium/style/base.css', '/cf-compendium/style/form.css', '/cf-compendium/style/list.css', '/cf-compendium/style/datagrid.css', '/cf-compendium/style/code.css', '/cf-compendium/style/chosen.css') />
				<cfset template.addScripts('/cf-compendium/script/jquery.base.js', '/cf-compendium/script/jquery.form.js', '/cf-compendium/script/jquery.list.js', '/cf-compendium/script/jquery.datagrid.js', '/cf-compendium/script/jquery.timeago.js', '/cf-compendium/script/jquery.cookie.js', '/cf-compendium/script/jquery-ui.timepicker-addon.js', '/cf-compendium/script/jquery.chosen-min.js', '/cf-compendium/script/jquery.elastic.js') />
				<cfset midfix = '' />
			</cfif>
			
			<cfset template.addStyles(
				'/algid/style/960/reset#midfix#.css',
				'/algid/style/960/960#midfix#.css',
				transport.theRequest.webRoot & 'plugins/content/extend/content/theme/content/style/styles#midfix#.css'
			) />
			
			<cfset template.addStyle(transport.theRequest.webRoot & 'plugins/content/extend/content/theme/content/style/print#midfix#.css', 'print') />
			
			<cfset template.addScripts(transport.theRequest.webRoot & 'plugins/content/extend/content/theme/content/script/content#midfix#.js') />
		</cfsilent>
		
		<cfoutput>#template.getStyles()#</cfoutput>
	</head>
	<body>
		<div class="container_12 respect-float">
			<div class="grid_12 no-print respect-float">
				<cfset options = {
					navClasses = ['menu horizontal float-right']
				} />
				
				<cfoutput>#template.getNavigation(transport.theCgi.server_name, themeLevel + 2, 'action', options, user)#</cfoutput>
				
				<cfset options = {
					navClasses = ['menu horizontal']
				} />
				
				<cfoutput>#template.getNavigation(transport.theCgi.server_name, themeLevel + 1, 'main', options, user)#</cfoutput>
			</div>
			
			<div id="breadcrumb" class="grid_12 no-print respect-float">
				<cfoutput>#template.getBreadcrumb()#</cfoutput>
			</div>
			
			<cfset showingNavigation = false />
			<cfset navLevel = template.getCurrentLevel() />
			
			<cfif navLevel gt 0>
				<div class="grid_12 no-print respect-float">
					<cfif navLevel gt 1>
						<cfset options = {
							navClasses = ['submenu horizontal float-right']
						} />
						
						<cfset subNav = trim(template.getNavigation( transport.theCgi.server_name, themeLevel + navLevel + 1, 'action', options, user)) />
						
						<cfset showingNavigation = showingNavigation or subNav neq '' />
						
						<cfoutput>#subNav#</cfoutput>
					</cfif>
					
					<cfset options = {
						navClasses = ['submenu horizontal']
					} />
					
					<cfset subNav = trim(template.getNavigation( transport.theCgi.server_name, themeLevel + navLevel + 1, 'main', options, user)) />
					
					<cfset showingNavigation = showingNavigation or subNav neq '' />
					
					<cfoutput>#subNav#</cfoutput>
					
					<!--- If there is not any navigation showing then show the actions for the current level --->
					<cfif navLevel gt 1 and not showingNavigation>
						<cfif navLevel gt 2>
							<cfset options = {
								navClasses = ['submenu horizontal float-right']
							} />
							
							<cfoutput>#template.getNavigation( transport.theCgi.server_name, themeLevel + navLevel, 'action', options, user)#</cfoutput>
						</cfif>
						
						<cfset options = {
							navClasses = ['submenu horizontal']
						} />
						
						<cfoutput>#template.getNavigation( transport.theCgi.server_name, themeLevel + navLevel, 'main', options, user)#</cfoutput>
					</cfif>
				</div>
			</cfif>
			
			<div class="grid_12 respect-float">
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
			</div>
			
			<div class="grid_12">
				<!--- Output the main content --->
				<cfoutput>#template.getContent()#</cfoutput>
			</div>
		</div>
		
		<cfoutput>#template.getScripts()#</cfoutput>
	</body>
</html>
