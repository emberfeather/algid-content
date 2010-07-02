<cfcomponent extends="algid.inc.resource.base.event" output="false">
	<cffunction name="onSearch" access="public" returntype="void" output="false">
		<cfargument name="transport" type="struct" required="true" />
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="results" type="component" required="true" />
		<cfargument name="term" type="string" required="true" />
		
		<cfset var admin = '' />
		<cfset var app = '' />
		<cfset var filter = '' />
		<cfset var i = 0 />
		<cfset var i18n = arguments.transport.theApplication.managers.singleton.getI18N() />
		<cfset var locale = arguments.transport.theSession.managers.singleton.getSession().getLocale() />
		<cfset var navigation = '' />
		<cfset var result = '' />
		<cfset var results = '' />
		<cfset var servContent = '' />
		<cfset var servDomain = '' />
		<cfset var theURL = '' />
		
		<cfset app = arguments.transport.theApplication.managers.singleton.getApplication() />
		<cfset admin = arguments.transport.theApplication.managers.plugin.getAdmin() />
		<cfset theUrl = arguments.transport.theApplication.factories.transient.getUrlForAdmin('', { start = app.getPath() & admin.getPath() & '?' } ) />
		
		<!--- Use the search term to find the matches --->
		<cfset servContent = arguments.transport.theApplication.factories.transient.getServContentForContent(arguments.transport.theApplication.managers.singleton.getApplication().getDSUpdate(), arguments.transport) />
		
		<cfset filter = {
			'orderBy' = 'path',
			'search' = arguments.term
		} />
		
		<cfset results = servContent.getContents( filter ) />
		
		<cfset theUrl.setContent('_base', '/content/edit') />
		
		<!--- Add the found results to the main search results --->
		<cfloop query="results">
			<cfset theUrl.setContent('content', toString(results['contentID'])) />
			
			<cfset result = arguments.transport.theApplication.factories.transient.getModSearchResultForAdmin( i18n, locale ) />
			
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
			
			<cfset result = arguments.transport.theApplication.factories.transient.getModSearchResultForAdmin( i18n, locale ) />
			
			<cfset result.setTitle(results['path']) />
			<cfset result.setDescription(results['title']) />
			<cfset result.setCategory('Content') />
			<cfset result.setLink(theUrl.getContent(false)) />
			
			<cfset arguments.results.addResults(result) />
		</cfloop>
		
		<cfset servDomain = arguments.transport.theApplication.factories.transient.getServDomainForContent(arguments.transport.theApplication.managers.singleton.getApplication().getDSUpdate(), arguments.transport) />
		
		<cfset filter = {
			'search' = arguments.term
		} />
		
		<cfset results = servDomain.getDomains( filter ) />
		
		<cfset theUrl.setDomain('_base', '/admin/domain/edit') />
		
		<!--- Add the found results to the main search results --->
		<cfloop query="results">
			<cfset theUrl.setDomain('domain', toString(results['domainID'])) />
			
			<cfset result = arguments.transport.theApplication.factories.transient.getModSearchResultForAdmin( i18n, locale ) />
			
			<cfset result.setTitle(results['domain']) />
			<cfset result.setCategory('Domain') />
			<cfset result.setLink(theUrl.getDomain(false)) />
			
			<cfset arguments.results.addResults(result) />
		</cfloop>
	</cffunction>
</cfcomponent>