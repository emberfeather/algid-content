<cfsilent>
	<cfset profiler = request.managers.singleton.getProfiler() />
	
	<cfset profiler.start('startup') />
	
	<!--- Setup a transport object to transport scopes --->
	<cfset transport = {
			theApplication = application,
			theCGI = cgi,
			theCookie = cookie,
			theForm = form,
			theRequest = request,
			theServer = server,
			theSession = session,
			theUrl = url
		} />
	
	<!--- Retrieve the objects --->
	<cfset i18n = transport.theApplication.managers.singleton.getI18N() />
	<cfset theURL = transport.theRequest.managers.singleton.getURL() />
	<cfset navigation = transport.theApplication.managers.singleton.getContentNavigation() />
	
	<!--- Check for a change to the number of records per page --->
	<cfif theURL.searchID('numPerPage')>
		<cfset session.numPerPage = theURL.searchID('numPerPage') />
		
		<cfcookie name="numPerPage" value="#session.numPerPage#" />
		
		<cfset theURL.remove('numPerPage') />
	</cfif>
	
	<cfset profiler.stop('startup') />
	
	<cfset profiler.start('template') />
	
	<!--- Create template object --->
	<cfset options = {
			scripts = [
				'https://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js'
			]
		} />
	
	<cfset template = transport.theApplication.factories.transient.getTemplateForContent(navigation, theURL, transport.theSession.managers.singleton.getSession().getLocale(), options) />
	
	<!--- Include minified files for production --->
	<cfset midfix = (transport.theApplication.managers.singleton.getApplication().getEnvironment() eq 'production' ? '-min' : '') />
	
	<!--- Add the scripts and styles --->
	<cfset template.addScripts('cf-compendium/script/form#midfix#.js', 'cf-compendium/script/list#midfix#.js', 'cf-compendium/script/jquery.datagrid#midfix#.js', 'cf-compendium/script/jquery.timeago#midfix#.js') />
	<cfset template.addStyles('cf-compendium/style/styles#midfix#.css', 'cf-compendium/style/form#midfix#.css', 'cf-compendium/style/list#midfix#.css', 'cf-compendium/style/datagrid#midfix#.css') />
	
	<cfset profiler.stop('template') />
	
	<cfset template.setContent('Coming some other time... content!!!') />
	
	<cfset profiler.start('theme') />
</cfsilent>

<!--- Include the theme --->
<cfinclude template="/plugins/#transport.theApplication.managers.plugin.getContent().getTheme()#/index.cfm" />

<cfset profiler.stop('theme') />