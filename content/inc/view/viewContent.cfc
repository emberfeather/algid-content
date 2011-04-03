<cfcomponent extends="algid.inc.resource.base.view" output="false">
	<cffunction name="add" access="public" returntype="string" output="false">
		<cfargument name="domains" type="query" required="true" />
		<cfargument name="request" type="struct" default="#{}#" />
		
		<cfset var element = '' />
		<cfset var hasMultiple = '' />
		<cfset var i = '' />
		<cfset var i18n = '' />
		<cfset var name = '' />
		<cfset var theForm = '' />
		<cfset var theUrl = '' />
		
		<cfset i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		<cfset theUrl = variables.transport.theRequest.managers.singleton.getUrl() />
		<cfset theForm = variables.transport.theApplication.factories.transient.getForm('addContent', i18n) />
		
		<!--- Add the resource bundle for the view --->
		<cfset theForm.addBundle('plugins/content/i18n/inc/view', 'viewContent') />
		
		<!--- Title --->
		<!--- TODO Use i18n for img title --->
		<cfset theForm.addElement('text', {
			class = 'allowDuplication',
			name = 'title',
			label = 'title',
			value = ( structKeyExists(arguments.request, 'title') ? arguments.request.title : '' )
		}) />
		
		<!--- Domain --->
		<cfif arguments.domains.recordCount GT 1>
			<!--- Select --->
			<cfset element = {
				name = "domainID",
				label = "domain",
				options = variables.transport.theApplication.factories.transient.getOptions()
			} />
			
			<!--- Create the options for the select --->
			<cfloop query="arguments.domains">
				<cfset element.options.addOption(arguments.domains.domain, arguments.domains.domainID.toString()) />
				
				<!--- Check for the current domain in the options --->
				<cfif arguments.domains.domain eq variables.transport.theCgi.server_name>
					<cfset element.value = arguments.domains.domainID.toString() />
				</cfif>
			</cfloop>
			
			<cfset theForm.addElement('select', element) />
		<cfelse>
			<!--- Hidden --->
			<cfset theForm.addElement('hidden', {
				name = "domainID",
				label = "domain",
				value = arguments.domains.domainID.toString()
			}) />
		</cfif>
		
		<cfreturn theForm.toHTML(theURL.get()) />
	</cffunction>
	
	<cffunction name="caching" access="public" returntype="string" output="false">
		<cfargument name="data" type="array" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset var datagrid = '' />
		<cfset var i18n = '' />
		
		<cfset arguments.options.theURL = variables.transport.theRequest.managers.singleton.getURL() />
		<cfset i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		<cfset datagrid = variables.transport.theApplication.factories.transient.getDatagrid(i18n, variables.transport.theSession.managers.singleton.getSession().getLocale()) />
		
		<!--- Add the resource bundle for the view --->
		<cfset datagrid.addBundle('plugins/content/i18n/inc/view', 'viewContent') />
		
		<cfset datagrid.addColumn({
			label = 'path'
		}) />
		
		<cfset datagrid.addColumn({
			class = 'phantom align-right',
			value = 'delete',
			link = {
				'path' = '__value',
				'_base' = '/admin/content/caching/delete'
			},
			linkClass = 'delete'
		}) />
		
		<cfreturn datagrid.toHTML( arguments.data, arguments.options ) />
	</cffunction>
	
	<cffunction name="edit" access="public" returntype="string" output="false">
		<cfargument name="content" type="component" required="true" />
		<cfargument name="paths" type="query" required="true" />
		<cfargument name="types" type="query" required="true" />
		<cfargument name="request" type="struct" default="#{}#" />
		
		<cfset var element = '' />
		<cfset var i18n = '' />
		<cfset var path = '' />
		<cfset var paths = '' />
		<cfset var theForm = '' />
		<cfset var theURL = '' />
		
		<cfset i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		<cfset theURL = variables.transport.theRequest.managers.singleton.getUrl() />
		<cfset theForm = variables.transport.theApplication.factories.transient.getForm('editContent', i18n) />
		
		<!--- Add the resource bundle for the view --->
		<cfset theForm.addBundle('plugins/content/i18n/inc/view', 'viewContent') />
		
		<!--- Title --->
		<cfset theForm.addElement('text', {
			name = "title",
			label = "title",
			required = true,
			value = ( structKeyExists(arguments.request, 'title') ? arguments.request.title : arguments.content.getTitle() )
		}) />
		
		<!--- Type --->
		<cfset element = {
			name = "typeID",
			label = "type",
			required = true,
			options = variables.transport.theApplication.factories.transient.getOptions(),
			value = ( structKeyExists(arguments.request, 'typeID') ? arguments.request.typeID : arguments.content.getTypeID() )
		} />
		
		<!--- Create the options for the select --->
		<cfloop query="arguments.types">
			<cfset element.options.addOption(arguments.types.type, arguments.types.typeID.toString()) />
		</cfloop>
		
		<cfset theForm.addElement('radio', element) />
		
		<!--- Content --->
		<cfset theForm.addElement('textarea', {
			name = "content",
			label = "content",
			value = ( structKeyExists(arguments.request, 'content') ? arguments.request.content : arguments.content.getContent() )
		}) />
		
		<!--- Paths --->
		<cfloop query="arguments.paths">
`			<cfset theForm.addElement('text', {
				class = 'allowDeletion',
				name = 'path' & arguments.paths.currentRow,
				label = 'path',
				value = arguments.paths.path
			}) />
			
`			<cfset theForm.addElement('hidden', {
				name = 'path' & arguments.paths.currentRow & '_id',
				value = arguments.paths.pathID.toString()
			}) />
		</cfloop>
		
		<cfset theForm.addElement('text', {
			class = 'allowDuplication allowDeletion',
			name = 'path',
			label = 'path',
			value = ( structKeyExists(arguments.request, 'path') ? arguments.request.path : '' )
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
		<cfset filterActive.addBundle('plugins/content/i18n/inc/view', 'viewContent') />
		
		<cfreturn filterActive.toHTML(arguments.filter, variables.transport.theRequest.managers.singleton.getURL(), 'search') />
	</cffunction>
	
	<cffunction name="filter" access="public" returntype="string" output="false">
		<cfargument name="params" type="struct" default="#{}#" />
		<cfargument name="domains" type="query" required="true" />
		<cfargument name="types" type="query" required="true" />
		
		<cfset var filterVertical = '' />
		<cfset var options = '' />
		<cfset var results = '' />
		
		<cfset filterVertical = variables.transport.theApplication.factories.transient.getFilterVertical(variables.transport.theApplication.managers.singleton.getI18N()) />
		
		<!--- Add the resource bundle for the view --->
		<cfset filterVertical.addBundle('plugins/content/i18n/inc/view', 'viewContent') />
		
		<!--- Search --->
		<cfset filterVertical.addFilter('search') />
		
		<!--- Domain --->
		<cfif arguments.domains.recordCount>
			<cfset options = variables.transport.theApplication.factories.transient.getOptions() />
			
			<cfloop query="arguments.domains">
				<cfset options.addOption(arguments.domains.domain, arguments.domains.domain) />
			</cfloop>
			
			<cfset filterVertical.addFilter('domain', options) />
		</cfif>
		
		<!--- Type --->
		<cfif arguments.types.recordCount>
			<cfset options = variables.transport.theApplication.factories.transient.getOptions() />
			
			<!--- TODO use i18n --->
			<cfset options.addOption('Any type', '') />
			
			<cfloop query="arguments.types">
				<cfset options.addOption(arguments.types.type, arguments.types.typeID.toString()) />
			</cfloop>
			
			<cfset filterVertical.addFilter('type', options) />
		</cfif>
		
		<cfreturn filterVertical.toHTML(variables.transport.theRequest.managers.singleton.getURL(), arguments.params) />
	</cffunction>
	
	<cffunction name="datagrid" access="public" returntype="string" output="false">
		<cfargument name="data" type="any" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset var app = '' />
		<cfset var datagrid = '' />
		<cfset var i18n = '' />
		<cfset var options = '' />
		<cfset var plugin = '' />
		<cfset var rewrite = '' />
		<cfset var theUrl = '' />
		
		<cfset arguments.options.theURL = variables.transport.theRequest.managers.singleton.getURL() />
		<cfset i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		<cfset datagrid = variables.transport.theApplication.factories.transient.getDatagrid(i18n, variables.transport.theSession.managers.singleton.getSession().getLocale()) />
		
		<!--- Create a content front-end url --->
		<cfset app = variables.transport.theApplication.managers.singleton.getApplication() />
		<cfset plugin = variables.transport.theApplication.managers.plugin.getContent() />
		
		<cfset options = { start = app.getPath() & plugin.getPath() } />
		
		<cfset rewrite = plugin.getRewrite() />
		
		<cfif rewrite.isEnabled>
			<cfset options.rewriteBase = rewrite.base />
			
			<cfset theUrl = variables.transport.theApplication.factories.transient.getUrlRewrite('', options) />
		<cfelse>
			<cfset theUrl = variables.transport.theApplication.factories.transient.getUrl('', options) />
		</cfif>
		
		<!--- Add the resource bundle for the view --->
		<cfset datagrid.addBundle('plugins/content/i18n/inc/view', 'viewContent') />
		
		<cfset datagrid.addColumn({
			key = 'path',
			label = 'path',
			link = {
				'_base' = 'path'
			},
			theUrl = theUrl
		}) />
		
		<cfset datagrid.addColumn({
			key = 'title',
			label = 'title'
		}) />
		
		<cfset datagrid.addColumn({
			key = 'type',
			label = 'type'
		}) />
		
		<cfset datagrid.addColumn({
			class = 'phantom align-right',
			value = [ 'delete', 'edit' ],
			link = [
				{
					'content' = 'contentID',
					'_base' = '/content/archive'
				},
				{
					'content' = 'contentID',
					'_base' = '/content/edit'
				}
			],
			linkClass = [ 'delete', '' ],
			title = 'title'
		}) />
		
		<cfreturn datagrid.toHTML( arguments.data, arguments.options ) />
	</cffunction>
</cfcomponent>
