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
		<cfset transport.theSession.numPerPage = theURL.searchID('numPerPage') />
		
		<cfcookie name="numPerPage" value="#transport.theSession.numPerPage#" />
		
		<cfset theURL.remove('numPerPage') />
	</cfif>
	
	<cfset profiler.stop('startup') />
	
	<cfset profiler.start('template') />
	
	<!--- Create template object --->
	<cfset options = {
			scripts = [
				'https://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js',
				'https://ajax.googleapis.com/ajax/libs/jqueryui/1/jqueryui.min.js'
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
	
	<cfset profiler.start('content') />
	
	<cfset servContent = transport.theApplication.factories.transient.getServContentForContent(transport.theApplication.managers.singleton.getApplication().getDSUpdate(), transport) />
	
	<cfset filter = {
			domain = transport.theCgi.server_name,
			path = lcase(theUrl.search('_base'))
		} />
	
	<!--- Use the plugin cache to pull the content from the cache first --->
	<cfset cacheContent = transport.theApplication.managers.plugin.getContent().getCache().getContent() />
	
	<cfif cacheContent.has( filter.domain & filter.path )>
		<cfset content = cacheContent.get( filter.domain & filter.path ) />
	<cfelse>
		<!--- The content is not cached, retrieve it --->
		<cfset contents = servContent.getContents( filter ) />
		
		<cfif contents.recordCount eq 1>
			<cfset content = servContent.getContent( transport.theSession.managers.singleton.getUser(), contents.contentID.toString() ) />
			
			<!--- Put the content in the cache --->
			<cfset cacheContent.put(filter.domain & filter.path, content) />
		<cfelse>
			<cfset filter.keyAlongPath = '404' />
			<cfset filter.orderBy = 'path' />
			<cfset filter.orderSort = 'desc' />
			
			<cfset contents = servContent.getContents( filter ) />
			
			<cfif contents.recordCount gt 0>
				<!--- Use the cache for the error page --->
				<cfif cacheContent.has( filter.domain & contents.path )>
					<cfset content = cacheContent.get( filter.domain & contents.path ) />
				<cfelse>
					<cfset content = servContent.getContent( transport.theSession.managers.singleton.getUser(), contents.contentID.toString() ) />
					
					<!--- Put the error page in the cache --->
					<cfset cacheContent.put(filter.domain & contents.path, content) />
				</cfif>
			<cfelse>
				<cfset content = servContent.getContent( transport.theSession.managers.singleton.getUser(), '' ) />
				
				<!--- Page not found and no 404 page along the path --->
				<cfset content.setContent('404... content not found!') />
			</cfif>
		</cfif>
	</cfif>
	
	<cftry>
		<cfset template.setContent(content.getContent()) />
		
		<cfcatch type="any">
			<cfset filter.keyAlongPath = '500' />
			<cfset filter.orderBy = 'path' />
			<cfset filter.orderSort = 'desc' />
			<cfset filter.path = 'desc' />
			
			<cfset contents = servContent.getContents( filter ) />
			
			<cfif contents.recordCount gt 0>
				<!--- Use the cache for the error page --->
				<cfif cacheContent.has( filter.domain & contents.path )>
					<cfset content = cacheContent.get( filter.domain & contents.path ) />
				<cfelse>
					<cfset content = servContent.getContent( transport.theSession.managers.singleton.getUser(), contents.contentID.toString() ) />
					
					<!--- Put the error page in the cache --->
					<cfset cacheContent.put(filter.domain & contents.path, content) />
				</cfif>
			<cfelse>
				<cfset content = servContent.getContent( transport.theSession.managers.singleton.getUser(), '' ) />
				
				<cfset content.setContent('500... Internal server error!') />
			</cfif>
			
			<cfset template.setContent(content.getContent()) />
		</cfcatch>
	</cftry>
	
	<cfset profiler.stop('content') />
	
	<cfset profiler.start('theme') />
</cfsilent>

<!--- Include the theme --->
<cfinclude template="/plugins/#transport.theApplication.managers.plugin.getContent().getDefaultTheme()#/index.cfm" />

<cfset profiler.stop('theme') />