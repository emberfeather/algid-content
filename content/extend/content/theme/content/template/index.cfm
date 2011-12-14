<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		
		<title><cfoutput>#template.getHTMltitle()#</cfoutput></title>
		
		<cfsilent>
			<cfset app = transport.theApplication.managers.singleton.getApplication() />
			<cfset api = transport.theApplication.managers.plugin.getApi() />
			<cfset isProduction = app.isProduction() />
			<cfset minFix = isProduction ? '-min' : '' />
			<cfset user = transport.theSession.managers.singleton.getUser() />
			
			<cfsavecontent variable="settings">
				<cfoutput>
					require([
						'jquery',
						'plugins/api/script/api'
					], function($) {
						$.api.defaults.url = '#app.getPath()##api.getPath()#';
					});
				</cfoutput>
			</cfsavecontent>
			
			<cfset template.addScripts(settings) />
		</cfsilent>
		
		<cfoutput>
			<cfif isProduction>
				<link rel="stylesheet" href="/cf-compendium/style/cf-compendium-min.css" />
				<link rel="stylesheet" href="/algid/style/algid-min.css" />
			<cfelse>
				<link rel="stylesheet" href="/cf-compendium/style/base.css" />
				<link rel="stylesheet" href="/cf-compendium/style/form.css" />
				<link rel="stylesheet" href="/cf-compendium/style/datagrid.css" />
				<link rel="stylesheet" href="/cf-compendium/style/detail.css" />
				<link rel="stylesheet" href="/cf-compendium/style/code.css" />
				<link rel="stylesheet" href="/algid/style/base.css" />
			</cfif>
			
			<link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1/themes/smoothness/jquery-ui.css" />
			<link rel="stylesheet" href="//fonts.googleapis.com/css?family=Philosopher&subset=latin" />
			<link rel="stylesheet" href="/algid/style/960/reset-min.css" />
			<link rel="stylesheet" href="/algid/style/960/960-min.css" />
			<link rel="stylesheet" href="#transport.theRequest.webRoot#plugins/content/extend/content/theme/content/style/styles#minFix#.css" />
			<link rel="stylesheet" href="#transport.theRequest.webRoot#plugins/content/extend/content/theme/content/style/print#minFix#.css" media="print" />
			
			#template.getStyles()#
		</cfoutput>
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
		
		<cfoutput>
			<script src="/cf-compendium/script/require-min.js"></script>
			<script>
				require.config({
					baseUrl: '#transport.theRequest.webRoot#',
					paths: {
						'async': '/cf-compendium/script/plugin/async',
						'goog': '/cf-compendium/script/plugin/goog',
						'jquery': '//ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min',
						'jqueryui': '//ajax.googleapis.com/ajax/libs/jqueryui/1.8/jquery-ui.min'
					}
				});
			</script>
			#template.getScripts()#
		</cfoutput>
	</body>
</html>
