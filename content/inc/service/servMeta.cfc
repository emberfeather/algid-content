<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="deleteMeta" access="public" returntype="void" output="false">
		<cfargument name="meta" type="component" required="true" />
		
		<cfset local.observer = getPluginObserver('content', 'meta') />
		
		<cfset local.observer.beforeDelete(variables.transport, arguments.meta) />
		
		<cfquery datasource="#variables.datasource.name#">
			DELETE
			FROM "#variables.datasource.prefix#content"."meta"
			WHERE "metaID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.metaID#" null="#arguments.metaID eq ''#" />::uuid
		</cfquery>
		
		<cfset local.observer.afterDelete(variables.transport, arguments.meta) />
	</cffunction>
	
	<cffunction name="deleteMetas" access="public" returntype="void" output="false">
		<cfargument name="filter" type="struct" required="true" />
		
		<cfparam name="arguments.filter.contentID" default="" />
		
		<cfset local.observer = getPluginObserver('content', 'meta') />
		
		<cfset local.observer.beforeDeleteBulk(variables.transport, arguments.filter) />
		
		<cfquery datasource="#variables.datasource.name#">
			DELETE
			FROM "#variables.datasource.prefix#content"."meta"
			WHERE "contentID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.contentID#" null="#arguments.filter.contentID eq ''#" />::uuid
			
			<cfif structKeyExists(arguments.filter, 'in')>
				AND "metaID" IN (
					<cfloop from="1" to="#arrayLen(arguments.filter.in)#" index="local.i">
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.in[local.i]#" null="#arguments.filter.in[local.i] eq ''#" />::uuid<cfif local.i lt arrayLen(arguments.filter.in)>,</cfif>
					</cfloop>
				)
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'notIn')>
				AND "metaID" NOT IN (
					<cfloop from="1" to="#arrayLen(arguments.filter.notIn)#" index="local.i">
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.notIn[local.i]#" null="#arguments.filter.notIn[local.i] eq ''#" />::uuid<cfif local.i lt arrayLen(arguments.filter.notIn)>,</cfif>
					</cfloop>
				)
			</cfif>
		</cfquery>
		
		<cfset local.observer.afterDeleteBulk(variables.transport, arguments.filter) />
	</cffunction>
	
	<cffunction name="getMeta" access="public" returntype="component" output="false">
		<cfargument name="metaID" type="string" required="true" />
		
		<cfset local.meta = getModel('content', 'meta') />
		
		<cfif arguments.metaID neq ''>
			<cfquery name="local.results" datasource="#variables.datasource.name#">
				SELECT "metaID", "contentID", "name", "value"
				FROM "#variables.datasource.prefix#content"."meta"
				WHERE "metaID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.metaID#" null="#arguments.metaID eq ''#" />::uuid
			</cfquery>
			
			<cfif local.results.recordCount>
				<cfset local.modelSerial = variables.transport.theApplication.factories.transient.getModelSerial(variables.transport) />
				
				<cfset local.modelSerial.deserialize(local.results, local.meta) />
			</cfif>
		</cfif>
		
		<cfreturn local.meta />
	</cffunction>
	
	<cffunction name="getMetas" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset arguments.filter = extend({
			orderBy = 'name',
			orderSort = 'asc'
		}, arguments.filter) />
		
		<cfquery name="local.results" datasource="#variables.datasource.name#">
			SELECT DISTINCT "metaID", "contentID", "name", "value"
			FROM "#variables.datasource.prefix#content"."meta"
			WHERE 1=1
			
			<cfif structKeyExists(arguments.filter, 'search') and arguments.filter.search neq ''>
				AND (
					"name" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
				)
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'contentID') and arguments.filter.contentID neq ''>
				AND "contentID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.contentID#" />::uuid
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'in')>
				AND "metaID" IN (
					<cfloop from="1" to="#arrayLen(arguments.filter.in)#" index="local.i">
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.in[local.i]#" null="#arguments.filter.in[i] eq ''#" />::uuid<cfif i lt arrayLen(arguments.filter.in)>,</cfif>
					</cfloop>
				)
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'notIn')>
				AND "metaID" NOT IN (
					<cfloop from="1" to="#arrayLen(arguments.filter.notIn)#" index="local.i">
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.notIn[local.i]#" null="#arguments.filter.notIn[i] eq ''#" />::uuid<cfif i lt arrayLen(arguments.filter.notIn)>,</cfif>
					</cfloop>
				)
			</cfif>
			
			ORDER BY
			<cfswitch expression="#arguments.filter.orderBy#">
				<cfdefaultcase>
					"name" #arguments.filter.orderSort#
				</cfdefaultcase>
			</cfswitch>
			
			<cfif structKeyExists(arguments.filter, 'limit')>
				LIMIT <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.limit#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'offset')>
				OFFSET <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.offset#" />
			</cfif>
		</cfquery>
		
		<cfreturn local.results />
	</cffunction>
	
	<cffunction name="setMeta" access="public" returntype="void" output="false">
		<cfargument name="meta" type="component" required="true" />
		
		<cfset local.observer = getPluginObserver('content', 'meta') />
		
		<cfset scrub__model(arguments.meta) />
		<cfset validate__model(arguments.meta) />
		
		<cfset local.observer.beforeSave(variables.transport, arguments.meta) />
		
		<cfif arguments.meta.getMetaID() neq ''>
			<cfset local.observer.beforeUpdate(variables.transport, arguments.meta) />
			
			<cftransaction>
				<cfquery datasource="#variables.datasource.name#">
					UPDATE "#variables.datasource.prefix#content"."meta"
					SET
						"contentID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.meta.getContentID()#" null="#arguments.meta.getContentID() eq ''#" />::uuid,
						"name" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.meta.getName()#" />,
						"value" = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.meta.getValue()#" />
					WHERE
						"metaID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.meta.getMetaID()#" />::uuid
				</cfquery>
			</cftransaction>
			
			<cfset local.observer.afterUpdate(variables.transport, arguments.meta) />
		<cfelse>
			<cfset local.observer.beforeCreate(variables.transport, arguments.meta) />
			
			<!--- Insert as a new record --->
			<!--- Create the new ID --->
			<cfset arguments.meta.setMetaID( createUUID() ) />
			
			<cftransaction>
				<cfquery datasource="#variables.datasource.name#">
					INSERT INTO "#variables.datasource.prefix#content"."meta" (
						"metaID",
						"contentID",
						"name",
						"value"
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.meta.getMetaID()#" null="#arguments.meta.getMetaID() eq ''#" />::uuid,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.meta.getContentID()#" null="#arguments.meta.getContentID() eq ''#" />::uuid,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.meta.getName()#" />,
						<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.meta.getValue()#" />
					)
				</cfquery>
			</cftransaction>
			
			<cfset local.observer.afterCreate(variables.transport, arguments.meta) />
		</cfif>
		
		<cfset local.observer.afterSave(variables.transport, arguments.meta) />
	</cffunction>
</cfcomponent>
