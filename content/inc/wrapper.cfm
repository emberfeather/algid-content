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
	<cfset template = transport.theApplication.factories.transient.getTemplateForContent(transport.theCGI.server_name, navigation, theURL, transport.theSession.managers.singleton.getSession().getLocale()) />
	
	<!--- Add the main jquery scripts with fallbacks --->
	<cfset template.addScript('https://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js', { condition = '!window.jQuery', script = '/algid/script/jquery-min.js' }) />
	<cfset template.addScript('https://ajax.googleapis.com/ajax/libs/jqueryui/1/jquery-ui.min.js', { condition = '!window.jQuery.ui', script = '/algid/script/jquery-ui-min.js' }) />
	
	<!--- Store in the singletons --->
	<cfset transport.theRequest.managers.singleton.setTemplate(template) />
	
	<!--- Include minified files for production --->
	<cfif transport.theApplication.managers.singleton.getApplication().isProduction()>
		<cfset template.addScripts('/cf-compendium/script/jquery.cf-compendium-min.js') />
		<cfset template.addStyles('/cf-compendium/style/cf-compendium-min.css') />
	<cfelse>
		<cfset template.addScripts('/cf-compendium/script/jquery.base.js', '/cf-compendium/script/jquery.form.js', '/cf-compendium/script/jquery.list.js', '/cf-compendium/script/jquery.datagrid.js', '/cf-compendium/script/jquery.timeago.js') />
		<cfset template.addStyles('/cf-compendium/style/base.css', '/cf-compendium/style/form.css', '/cf-compendium/style/list.css', '/cf-compendium/style/datagrid.css', '/cf-compendium/style/code.css') />
	</cfif>
	
	<cfset profiler.stop('template') />
	
	<cfset profiler.start('content') />
	
	<cfset servContent = services.get('content', 'content') />
	<cfset servPath = services.get('content', 'path') />
	
	<cfset filter = {
			domain = transport.theCgi.server_name,
			keyAlongPathOrPath = '*',
			path = lcase(theUrl.search('_base'))
		} />
	
	<!--- Use the plugin cache to pull the content from the cache first --->
	<cfset cacheContent = transport.theApplication.managers.plugin.getContent().getCache().getContent() />
	
	<cftry>
		<cfif cacheContent.has( filter.domain & filter.path )>
			<cfset content = cacheContent.get( filter.domain & filter.path ) />
			
			<cfset transport.theRequest.managers.singleton.setContent(content) />
		<cfelse>
			<!--- The content is not cached, retrieve it --->
			<cfset paths = servPath.getPaths( filter ) />
			
			<cfif paths.recordCount gt 0>
				<cfset content = servContent.getContent( transport.theSession.managers.singleton.getUser(), paths.contentID.toString() ) />
				
				<!--- Set the template --->
				<cfset content.setTemplate(paths.template) />
				
				<cfset transport.theRequest.managers.singleton.setContent(content) />
				
				<!--- Store the original path requested --->
				<cfset content.setPathExtra(filter.path, paths.path) />
				
				<!--- Trigger the before show event --->
				<cfset transport.theApplication.managers.plugin.getContent().getObserver().getContent().beforeDisplay(transport, content) />
				
				<!--- Check if the content should be cached --->
				<cfif content.getDoCaching()>
					<cfset cacheContent.put(filter.domain & filter.path, content) />
				</cfif>
			<cfelse>
				<cfheader statuscode="404" statustext="Content not found" />
				
				<cfset filter.keyAlongPath = '404' />
				
				<cfset paths = servPath.getPaths( filter ) />
				
				<cfif paths.recordCount gt 0>
					<!--- Use the cache for the error page --->
					<cfif cacheContent.has( filter.domain & paths.path )>
						<cfset content = cacheContent.get( filter.domain & paths.path ) />
						
						<cfset transport.theRequest.managers.singleton.setContent(content) />
					<cfelse>
						<cfset content = servContent.getContent( transport.theSession.managers.singleton.getUser(), paths.contentID.toString() ) />
						
						<!--- Set the template --->
						<cfset content.setTemplate(paths.template) />
						
						<cfset transport.theRequest.managers.singleton.setContent(content) />
						
						<!--- Store the original path requested --->
						<cfset content.setPathExtra(filter.path, paths.path) />
						
						<!--- Trigger the before show event --->
						<cfset transport.theApplication.managers.plugin.getContent().getObserver().getContent().beforeDisplay(transport, content) />
						
						<!--- Check if the content should be cached --->
						<cfif content.getDoCaching()>
							<cfset cacheContent.put(filter.domain & paths.path, content) />
						</cfif>
					</cfif>
				<cfelse>
					<cfset content = servContent.getContent( transport.theSession.managers.singleton.getUser(), '' ) />
					
					<cfset transport.theRequest.managers.singleton.setContent(content) />
					
					<!--- Page not found and no 404 page along the path --->
					<cfset content.setTitle('404 Not Found') />
					<cfset content.setContent('404... content not found!') />
				</cfif>
				
				<!--- Add to the template levels so it appears on the page titles --->
				<cfset template.addLevel(content.getTitle(), content.getTitle(), '') />
			</cfif>
		</cfif>
		
		<cfset template.setContent(content.getContentHtml()) />
		<cfset template.setTemplate(content.getTemplate()) />
		
		<cfcatch type="any">
			<cfheader statuscode="500" statustext="Internal Server Error" />
			
			<!--- Track the exception --->
			<cfif transport.theApplication.managers.singleton.getApplication().isProduction()>
				<cftry>
					<cfset errorLogger = transport.theApplication.managers.singleton.getErrorLog() />
					
					<cfset errorLogger.log(cfcatch) />
					
					<cfcatch type="any">
						<!--- Failed to log error, send report of unlogged error --->
						<!--- TODO Send Unlogged Error --->
					</cfcatch>
				</cftry>
			<cfelse>
				<!--- Dump out the error --->
				<cfdump var="#cfcatch#" />
				<cfabort />
			</cfif>
			
			<cfset filter.keyAlongPath = '500' />
			
			<!--- The content is not cached, retrieve it --->
			<cfset paths = servPath.getPaths( filter ) />
			
			<cfif paths.recordCount gt 0>
				<!--- Use the cache for the error page --->
				<cfif cacheContent.has( filter.domain & paths.path )>
					<cfset content = cacheContent.get( filter.domain & paths.path ) />
					
					<cfset transport.theRequest.managers.singleton.setContent(content) />
				<cfelse>
					<cfset content = servContent.getContent( transport.theSession.managers.singleton.getUser(), paths.contentID.toString() ) />
					
					<cfset transport.theRequest.managers.singleton.setContent(content) />
					
					<!--- Store the original path requested --->
					<cfset content.setPathExtra(filter.path, paths.path) />
					
					<!--- Trigger the before show event --->
					<cfset transport.theApplication.managers.plugin.getContent().getObserver().getContent().beforeDisplay(transport, content) />
					
					<!--- Check if the content should be cached --->
					<cfif content.getDoCaching()>
						<cfset cacheContent.put(filter.domain & paths.path, content) />
					</cfif>
				</cfif>
			<cfelse>
				<cfset content = servContent.getContent( transport.theSession.managers.singleton.getUser(), '' ) />
				
				<cfset transport.theRequest.managers.singleton.setContent(content) />
				
				<!--- Page not found and no 500 page along the path --->
				<cfset content.setTitle('500 Server Error') />
				<cfset content.setContent('500... Internal server error!') />
			</cfif>
			
			<cfset template.setContent(content.getContentHtml()) />
			
			<!--- Add to the template levels so it appears on the page titles --->
			<cfset template.addLevel(content.getTitle(), content.getTitle(), '') />
		</cfcatch>
	</cftry>
	
	<cfset profiler.stop('content') />
	
	<cfset profiler.start('theme') />
	
	<!--- Determine which theme to use based upon the domain/path combination --->
	<cfset theme = transport.theApplication.managers.plugin.getContent().getDefaultTheme() />
	
	<cfset servTheme = services.get('content', 'theme') />
	
	<!--- Use the theme that is the closest to the current page --->
	<cfset filter = {
			alongPath = theUrl.search('_base'),
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