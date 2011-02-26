<cfcomponent extends="algid.inc.resource.base.event" output="false">
	<cffunction name="onSearch" access="public" returntype="void" output="false">
		<cfargument name="transport" type="struct" required="true" />
		<cfargument name="results" type="component" required="true" />
		<cfargument name="term" type="string" required="true" />
		
		<cfset var app = '' />
		<cfset var filter = '' />
		<cfset var i = 0 />
		<cfset var i18n = arguments.transport.theApplication.managers.singleton.getI18N() />
		<cfset var locale = arguments.transport.theSession.managers.singleton.getSession().getLocale() />
		<cfset var models = arguments.transport.theRequest.managers.singleton.getManagerModel() />
		<cfset var navigation = '' />
		<cfset var options = '' />
		<cfset var plugin = '' />
		<cfset var result = '' />
		<cfset var results = '' />
		<cfset var rewrite = '' />
		<cfset var servContent = '' />
		<cfset var servDomain = '' />
		<cfset var theURL = '' />
		
		<cfset app = arguments.transport.theApplication.managers.singleton.getApplication() />
		<cfset plugin = arguments.transport.theApplication.managers.plugin.getAdmin() />
		
		<cfset options = { start = app.getPath() & plugin.getPath() } />
		
		<cfset rewrite = plugin.getRewrite() />
		
		<cfif rewrite.isEnabled>
			<cfset options.rewriteBase = rewrite.base />
			
			<cfset theUrl = arguments.transport.theApplication.factories.transient.getUrlRewrite(arguments.transport.theUrl, options) />
		<cfelse>
			<cfset theUrl = arguments.transport.theApplication.factories.transient.getUrl(arguments.transport.theUrl, options) />
		</cfif>
		
		<!--- Use the search term to find the matches --->
		<cfset servContent = getService(arguments.transport, 'content', 'content') />
		
		<cfset filter = {
			'orderBy' = 'path',
			'search' = arguments.term
		} />
		
		<cfset results = servContent.getContents( filter ) />
		
		<cfset theUrl.setContent('_base', '/content/edit') />
		
		<!--- Add the found results to the main search results --->
		<cfloop query="results">
			<cfset theUrl.setContent('content', toString(results['contentID'])) />
			
			<cfset result = models.get('admin', 'searchResult') />
			
			<cfset result.setTitle(results['title']) />
			<cfset result.setDescription(results['path']) />
			<cfset result.setCategory('Content') />
			<cfset result.setLink(theUrl.getContent(false)) />
			
			<cfset arguments.results.addResults(result) />
		</cfloop>
		
		<cfset filter = {
			'orderBy' = 'path',
			'searchPath' = arguments.term
		} />
		
		<cfset results = servContent.getContents( filter ) />
		
		<!--- Add the found results to the main search results --->
		<cfloop query="results">
			<cfset theUrl.setContent('content', toString(results['contentID'])) />
			
			<cfset result = models.get('admin', 'searchResult') />
			
			<cfset result.setTitle(results['path']) />
			<cfset result.setDescription(results['title']) />
			<cfset result.setCategory('Content') />
			<cfset result.setLink(theUrl.getContent(false)) />
			
			<cfset arguments.results.addResults(result) />
		</cfloop>
		
		<cfset servDomain = getService(arguments.transport, 'content', 'domain') />
		
		<cfset filter = {
			'search' = arguments.term
		} />
		
		<cfset results = servDomain.getDomains( filter ) />
		
		<cfset theUrl.setDomain('_base', '/admin/domain/edit') />
		
		<!--- Add the found results to the main search results --->
		<cfloop query="results">
			<cfset theUrl.setDomain('domain', toString(results['domainID'])) />
			
			<cfset result = models.get('admin', 'searchResult') />
			
			<cfset result.setTitle(results['domain']) />
			<cfset result.setCategory('Domain') />
			<cfset result.setLink(theUrl.getDomain(false)) />
			
			<cfset arguments.results.addResults(result) />
		</cfloop>
	</cffunction>
</cfcomponent>
