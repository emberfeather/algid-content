<cfcomponent extends="algid.inc.resource.base.view" output="false">
	<cffunction name="edit" access="public" returntype="string" output="false">
		<cfargument name="domain" type="component" required="true" />
		<cfargument name="request" type="struct" default="#{}#" />
		
		<cfset var i18n = '' />
		<cfset var theForm = '' />
		<cfset var theURL = '' />
		
		<cfset i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		<cfset theURL = variables.transport.theRequest.managers.singleton.getUrl() />
		<cfset theForm = variables.transport.theApplication.factories.transient.getFormStandard('addDomain', i18n) />
		
		<!--- Add the resource bundle for the view --->
		<cfset theForm.addBundle('plugins/content/i18n/inc/view', 'viewDomain') />
		
		<cfset theForm.addElement('text', {
				name = "domain",
				label = "domain",
				value = ( structKeyExists(arguments.request, 'domain') ? arguments.request.domain : arguments.domain.getDomain() )
			}) />
		
		<cfreturn theForm.toHTML(theURL.get()) />
	</cffunction>
	
	<cffunction name="filterActive" access="public" returntype="string" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var filterActive = '' />
		<cfset var options = '' />
		<cfset var results = '' />
		
		<cfset filterActive = variables.transport.theApplication.factories.transient.getFilterActive(variables.transport.theApplication.managers.singleton.getI18N()) />
		
		<!--- Add the resource bundle for the view --->
		<cfset filterActive.addBundle('plugins/content/i18n/inc/view', 'viewDomain') />
		
		<cfreturn filterActive.toHTML(arguments.filter, variables.transport.theRequest.managers.singleton.getURL(), 'search') />
	</cffunction>
	
	<cffunction name="filter" access="public" returntype="string" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var filter = '' />
		<cfset var options = '' />
		<cfset var results = '' />
		
		<cfset filter = variables.transport.theApplication.factories.transient.getFilterVertical(variables.transport.theApplication.managers.singleton.getI18N()) />
		
		<!--- Add the resource bundle for the view --->
		<cfset filter.addBundle('plugins/content/i18n/inc/view', 'viewDomain') />
		
		<!--- Search --->
		<cfset filter.addFilter('search') />
		
		<cfreturn filter.toHTML(variables.transport.theRequest.managers.singleton.getURL()) />
	</cffunction>
	
	<cffunction name="list" access="public" returntype="string" output="false">
		<cfargument name="data" type="any" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset var datagrid = '' />
		<cfset var i18n = '' />
		
		<cfset arguments.options.theURL = variables.transport.theRequest.managers.singleton.getURL() />
		<cfset i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		<cfset datagrid = variables.transport.theApplication.factories.transient.getDatagrid(i18n, variables.transport.locale) />
		
		<!--- Add the resource bundle for the view --->
		<cfset datagrid.addBundle('plugins/content/i18n/inc/view', 'viewDomain') />
		
		<cfset datagrid.addColumn({
				key = 'domain',
				label = 'domain'
			}) />
		
		<cfreturn datagrid.toHTML( arguments.data, arguments.options ) />
	</cffunction>
</cfcomponent>