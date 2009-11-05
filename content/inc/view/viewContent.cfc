<cfcomponent extends="algid.inc.resource.base.view" output="false">
	<cffunction name="list" access="public" returntype="string" output="false">
		<cfargument name="data" type="any" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset var datagrid = '' />
		<cfset var i18n = '' />
		
		<cfset i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		<cfset datagrid = variables.transport.theApplication.factories.transient.getDatagrid(i18n, variables.transport.locale) />
		
		<cfset datagrid.addColumn({
				key = 'path',
				label = 'Path'
			}) />
		
		<cfset datagrid.addColumn({
				key = 'title',
				label = 'Title'
			}) />
		
		<cfset datagrid.addColumn({
				key = 'type',
				label = 'Type'
			}) />
		
		<cfreturn datagrid.toHTML( arguments.data, arguments.options ) />
	</cffunction>
</cfcomponent>