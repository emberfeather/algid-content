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
	<cfset locale = transport.theSession.managers.singleton.getSession().getLocale() />
	<cfset theURL = transport.theRequest.managers.singleton.getURL() />
	<cfset navigation = transport.theApplication.managers.singleton.getContentNavigation() />
	
	<!--- Create and store the services manager --->
	<cfset services = transport.theApplication.factories.transient.getManagerService(transport) />
	<cfset transport.theRequest.managers.singleton.setManagerService(services) />
	
	<!--- Create and store the view manager --->
	<cfset views = transport.theApplication.factories.transient.getManagerView(transport) />
	<cfset transport.theRequest.managers.singleton.setManagerView(views) />
	
	<!--- Create and store the model manager --->
	<cfset models = transport.theApplication.factories.transient.getManagerModel(transport, i18n, locale) />
	<cfset transport.theRequest.managers.singleton.setManagerModel(models) />
	
	<cfset servDomain = services.get('content', 'domain') />
	
	<!--- Redirect hostnames from secondary to primary --->
	<cfset primaryHostname = servDomain.getPrimaryHostname(transport.theCgi.server_name) />
	
	<cfif primaryHostname neq transport.theCgi.server_name>
		<cflocation url="http#(transport.theCgi.https eq 'on' ? 's' : '')#://#primaryHostname#:#transport.theCgi.server_port##theURL.get(false)#" addtoken="false" />
	</cfif>
	
	<!--- Check for a change to the number of records per page --->
	<cfif theURL.searchID('numPerPage')>
		<cfset transport.theSession.numPerPage = theURL.searchID('numPerPage') />
		
		<cfcookie name="numPerPage" value="#transport.theSession.numPerPage#" />
		
		<cfset theURL.remove('numPerPage') />
	</cfif>
	
	<cfset profiler.stop('startup') />
	
	<cfset profiler.start('template') />
	
	<!--- Create template object --->
	<cfset template = transport.theApplication.factories.transient.getTemplateForContent(
		transport.theCGI.server_name,
		navigation,
		theURL,
		i18n,
		transport.theSession.managers.singleton.getSession().getLocale()
	) />
	
	<!--- Add the navigation cache --->
	<cfset cacheManager = transport.theApplication.managers.plugin.getContent().getCache() />
	
	<cfif cacheManager.hasNavigation()>
		<cfset template.setNavigationCache(cacheManager.getNavigation()) />
	</cfif>
	
	<!--- Add the main jquery scripts with fallbacks --->
	<cfset template.addScript('https://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js', { condition = '!window.jQuery', script = '/algid/script/jquery-min.js' }) />
	<cfset template.addScript('https://ajax.googleapis.com/ajax/libs/jqueryui/1/jquery-ui.min.js', { condition = '!window.jQuery.ui', script = '/algid/script/jquery-ui-min.js' }) />
	
	<!--- Store in the singletons --->
	<cfset transport.theRequest.managers.singleton.setTemplate(template) />
	
	<!--- Include minified files for production --->
	<cfif transport.theApplication.managers.singleton.getApplication().isProduction()>
		<cfset template.addStyles('/cf-compendium/style/cf-compendium-min.css') />
		<cfset template.addScripts('/cf-compendium/script/jquery.cf-compendium-min.js') />
	<cfelse>
		<cfset template.addStyles('/cf-compendium/style/base.css', '/cf-compendium/style/form.css', '/cf-compendium/style/list.css', '/cf-compendium/style/datagrid.css', '/cf-compendium/style/code.css') />
		<cfset template.addScripts('/cf-compendium/script/jquery.base.js', '/cf-compendium/script/jquery.form.js', '/cf-compendium/script/jquery.list.js', '/cf-compendium/script/jquery.datagrid.js', '/cf-compendium/script/jquery.timeago.js', '/cf-compendium/script/jquery.cookie.js', '/cf-compendium/script/jquery.elastic.js') />
	</cfif>
	
	<cfset profiler.stop('template') />
	
	<cfset profiler.start('content') />
	
	<cfset servContent = services.get('content', 'content') />
	
	<cfset content = servContent.retrieveContent() />
	
	<cfif content.getIsError()>
		<!--- Add to the template levels so it appears on the page titles --->
		<cfset template.addLevel(content.getTitle(), content.getTitle(), '') />
	</cfif>
	
	<!--- Add the meta information to the template --->
	<cfif content.hasMeta()>
		<cfset metaInformation = content.getMeta() />
		
		<cfloop query="metaInformation">
			<cfset template.setMeta(metaInformation.name, metaInformation.value) />
		</cfloop>
	</cfif>
	
	<cfset template.setContent(content.getContentHtml()) />
	<cfset template.setTemplate(content.getTemplate()) />
	
	<cfset profiler.stop('content') />
	
	<cfset profiler.start('theme') />
	
	<!--- Determine which theme to use based upon the domain/path combination --->
	<cfset theme = transport.theApplication.managers.plugin.getContent().getDefaultTheme() />
	
	<cfset servTheme = services.get('content', 'theme') />
	
	<!--- Use the theme that is the closest to the current page --->
	<cfset filter = {
		keyAlongPathOrPath = ['', '*'],
		path = theUrl.search('_base'),
		domain = transport.theCgi.server_name,
		orderBy = 'path',
		orderSort = 'desc'
	} />
	
	<cfset themes = servTheme.getThemes(filter) />
	
	<cfif themes.recordCount gt 0>
		<cfset theme = themes.directory />
	</cfif>
</cfsilent>

<cfinclude template="/plugins/#theme#/template/#template.getTemplate()#.cfm" />

<cfset profiler.stop('theme') />
