<cfcomponent extends="algid.inc.resource.base.view" output="false">
	<cffunction name="add" access="public" returntype="string" output="false">
		<cfargument name="domains" type="query" required="true" />
		<cfargument name="request" type="struct" default="#{}#" />
		
		<cfset var element = '' />
		<cfset var i18n = '' />
		<cfset var theForm = '' />
		<cfset var theURL = '' />
		
		<cfset i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		<cfset theURL = variables.transport.theRequest.managers.singleton.getUrl() />
		<cfset theForm = variables.transport.theApplication.factories.transient.getFormStandard('addContent', i18n) />
		
		<!--- Add the resource bundle for the view --->
		<cfset theForm.addBundle('plugins/content/i18n/inc/view', 'viewContent') />
		
		<cfset theForm.addElement('text', {
				name = "title",
				label = "title",
				value = ( structKeyExists(arguments.request, 'title') ? arguments.request.title : '' )
			}) />
		
		<!--- Select --->
		<cfset element = {
				name = "domainID",
				label = "domain",
				options = variables.transport.theApplication.factories.transient.getOptions()
			} />
		
		<cfloop query="arguments.domains">
			<cfset element.options.addOption(arguments.domains.domain, arguments.domains.domainID) />
		</cfloop>
		
		<cfset theForm.addElement('select', element) />
		
		<cfreturn theForm.toHTML(theURL.get()) />
	</cffunction>
	
	<cffunction name="edit" access="public" returntype="string" output="false">
		<cfargument name="content" type="component" required="true" />
		<cfargument name="request" type="struct" default="#{}#" />
		
		<cfset var html = '' />
		
		<cfsavecontent variable="html">
			<cfoutput>
				<p>
					Form for editing content (#arguments.content.getContentID()#).
				</p>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn html />
	</cffunction>
	
	<cffunction name="filterActive" access="public" returntype="string" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var filterActive = '' />
		<cfset var options = '' />
		<cfset var results = '' />
		
		<cfset filterActive = variables.transport.theApplication.factories.transient.getFilterActive(variables.transport.theApplication.managers.singleton.getI18N()) />
		
		<!--- Add the resource bundle for the view --->
		<cfset filterActive.addBundle('plugins/content/i18n/inc/view', 'viewContent') />
		
		<cfreturn filterActive.toHTML(arguments.filter, variables.transport.theRequest.managers.singleton.getURL(), 'search') />
	</cffunction>
	
	<cffunction name="filter" access="public" returntype="string" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var filter = '' />
		<cfset var options = '' />
		<cfset var results = '' />
		
		<cfset filter = variables.transport.theApplication.factories.transient.getFilterVertical(variables.transport.theApplication.managers.singleton.getI18N()) />
		
		<!--- Add the resource bundle for the view --->
		<cfset filter.addBundle('plugins/content/i18n/inc/view', 'viewContent') />
		
		<!--- Search --->
		<cfset filter.addFilter('search') />
		
		<cfreturn filter.toHTML(variables.transport.theRequest.managers.singleton.getURL()) />
	</cffunction>
	
	<cffunction name="datagrid" access="public" returntype="string" output="false">
		<cfargument name="data" type="any" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset var datagrid = '' />
		<cfset var i18n = '' />
		
		<cfset arguments.options.theURL = variables.transport.theRequest.managers.singleton.getURL() />
		<cfset i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		<cfset datagrid = variables.transport.theApplication.factories.transient.getDatagrid(i18n, variables.transport.theSession.managers.singleton.getSession().getLocale()) />
		
		<!--- Add the resource bundle for the view --->
		<cfset datagrid.addBundle('plugins/content/i18n/inc/view', 'viewContent') />
		
		<cfset datagrid.addColumn({
				key = 'path',
				label = 'path'
			}) />
		
		<cfset datagrid.addColumn({
				key = 'title',
				label = 'title'
			}) />
		
		<cfset datagrid.addColumn({
				key = 'type',
				label = 'type'
			}) />
		
		<cfreturn datagrid.toHTML( arguments.data, arguments.options ) />
	</cffunction>
</cfcomponent>