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
				'https://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js'
			]
		} />
	
	<cfset template = transport.theApplication.factories.transient.getTemplateForContent(navigation, theURL, transport.theSession.managers.singleton.getSession().getLocale(), options) />
	
	<!--- Include minified files for production --->
	<cfif transport.theApplication.managers.singleton.getApplication().isProduction()>
		<cfset template.addScripts('/cf-compendium/script/jquery.cf-compendium-min.js') />
		<cfset template.addStyles('/cf-compendium/style/cf-compendium-min.css') />
	<cfelse>
		<cfset template.addScripts('/cf-compendium/script/jquery.base.js', '/cf-compendium/script/jquery.form.js', '/cf-compendium/script/jquery.list.js', '/cf-compendium/script/jquery.datagrid.js', '/cf-compendium/script/jquery.timeago.js') />
		<cfset template.addStyles('/cf-compendium/style/base.css', '/cf-compendium/style/form.css', '/cf-compendium/style/list.css', '/cf-compendium/style/datagrid.css', '/cf-compendium/style/code.css') />
	</cfif>
	
	<cfset profiler.stop('template') />
	
	<cfset template.setContent('Coming some other time... content!!!') />
	
	<cfset profiler.start('theme') />
</cfsilent>

<!--- Include the theme --->
<cfinclude template="/plugins/#transport.theApplication.managers.plugin.getContent().getDefaultTheme()#/index.cfm" />

<cfset profiler.stop('theme') />