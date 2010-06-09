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
		<cfset var theURL = '' />
		
		<cfset app = arguments.transport.theApplication.managers.singleton.getApplication() />
		<cfset admin = arguments.transport.theApplication.managers.plugin.getAdmin() />
		<cfset theUrl = arguments.transport.theApplication.factories.transient.getUrlForAdmin('', { start = app.getPath() & admin.getPath() & '?' } ) />
		
		<!--- Use the search term to find the matches --->
		<cfset servContent = arguments.transport.theApplication.factories.transient.getServContentForContent(transport.theApplication.managers.singleton.getApplication().getDSUpdate(), transport) />
		
		<cfset filter = {
			'orderBy' = 'path',
			'search' = arguments.term
		} />
		
		<cfset results = servContent.getContents( filter ) />
		
		<cfset theUrl.setSearch('_base', '/content/edit') />
		
		<!--- Add the found results to the main search results --->
		<cfloop query="results">
			<cfset theUrl.setSearch('content', toString(results['contentID'])) />
			
			<cfset result = arguments.transport.theApplication.factories.transient.getModSearchResultForAdmin( i18n, locale ) />
			
			<cfset result.setTitle(results['title']) />
			<cfset result.setDescription(results['path']) />
			<cfset result.setCategory('Content') />
			<cfset result.setLink(theUrl.getSearch(false)) />
			
			<cfset arguments.results.addResults(result) />
		</cfloop>
		
		<cfset filter = {
			'orderBy' = 'path',
			'searchPath' = arguments.term
		} />
		
		<cfset results = servContent.getContents( filter ) />
		
		<!--- Add the found results to the main search results --->
		<cfloop query="results">
			<cfset theUrl.setSearch('content', toString(results['contentID'])) />
			
			<cfset result = arguments.transport.theApplication.factories.transient.getModSearchResultForAdmin( i18n, locale ) />
			
			<cfset result.setTitle(results['path']) />
			<cfset result.setDescription(results['title']) />
			<cfset result.setCategory('Content') />
			<cfset result.setLink(theUrl.getSearch(false)) />
			
			<cfset arguments.results.addResults(result) />
		</cfloop>
	</cffunction>
</cfcomponent>
