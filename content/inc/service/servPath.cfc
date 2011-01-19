<cfcomponent extends="algid.inc.resource.base.service" output="false">
<cfscript>
	public component function init( required struct transport ) {
		super.init(arguments.transport);
		
		variables.path = arguments.transport.theApplication.managers.singleton.getPathForContent();
		
		return this;
	}
</cfscript>
	<cffunction name="deletePath" access="public" returntype="void" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="path" type="component" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var observer = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('content', 'path') />
		
		<!--- Get the event log from the transport --->
		<cfset eventLog = variables.transport.theApplication.managers.singleton.getEventLog() />
		
		<!--- Before Delete Event --->
		<cfset observer.beforeDelete(variables.transport, arguments.currUser, arguments.path) />
		
		<!--- Delete the path --->
		<cfquery datasource="#variables.datasource.name#">
			DELETE
			FROM "#variables.datasource.prefix#content"."path"
			WHERE "pathID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pathID#" null="#arguments.pathID eq ''#" />::uuid
		</cfquery>
		
		<!--- After Delete Event --->
		<cfset observer.afterDelete(variables.transport, arguments.currUser, arguments.path) />
	</cffunction>
	
	<cffunction name="deletePaths" access="public" returntype="void" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="filter" type="struct" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var i = '' />
		<cfset var observer = '' />
		
		<cfparam name="arguments.filter.contentID" default="" />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('content', 'path') />
		
		<!--- Get the event log from the transport --->
		<cfset eventLog = variables.transport.theApplication.managers.singleton.getEventLog() />
		
		<!--- Before Delete Bulk Event --->
		<cfset observer.beforeDeleteBulk(variables.transport, arguments.currUser, arguments.filter) />
		
		<!--- Delete the path --->
		<cfquery datasource="#variables.datasource.name#">
			DELETE
			FROM "#variables.datasource.prefix#content"."path"
			WHERE "contentID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.contentID#" null="#arguments.filter.contentID eq ''#" />::uuid
			
			<cfif structKeyExists(arguments.filter, 'in')>
				AND "pathID" IN (
					<cfloop from="1" to="#arrayLen(arguments.filter.in)#" index="i">
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.in[i]#" null="#arguments.filter.in[i] eq ''#" />::uuid<cfif i lt arrayLen(arguments.filter.in)>,</cfif>
					</cfloop>
				)
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'notIn')>
				AND "pathID" NOT IN (
					<cfloop from="1" to="#arrayLen(arguments.filter.notIn)#" index="i">
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.notIn[i]#" null="#arguments.filter.notIn[i] eq ''#" />::uuid<cfif i lt arrayLen(arguments.filter.notIn)>,</cfif>
					</cfloop>
				)
			</cfif>
		</cfquery>
		
		<!--- After Delete Bulk Event --->
		<cfset observer.afterDeleteBulk(variables.transport, arguments.currUser, arguments.filter) />
	</cffunction>
	
	<cffunction name="getPath" access="public" returntype="component" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="pathID" type="string" required="true" />
		
		<cfset var i = '' />
		<cfset var modelSerial = '' />
		<cfset var observer = '' />
		<cfset var path = '' />
		<cfset var results = '' />
		<cfset var type = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('content', 'path') />
		
		<cfset path = getModel('content', 'path') />
		
		<cfif arguments.pathID neq ''>
			<cfquery name="results" datasource="#variables.datasource.name#">
				SELECT "pathID", "contentID", "themeID", "path", "isActive", "template"
				FROM "#variables.datasource.prefix#content"."path"
				WHERE "pathID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pathID#" null="#arguments.pathID eq ''#" />::uuid
			</cfquery>
			
			<cfif results.recordCount>
				<cfset modelSerial = variables.transport.theApplication.factories.transient.getModelSerial(variables.transport) />
				
				<cfset modelSerial.deserialize(results, path) />
			</cfif>
		</cfif>
		
		<cfreturn path />
	</cffunction>
	
	<cffunction name="getPaths" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var cleaned = '' />
		<cfset var defaults = {
			domain = variables.transport.theCgi.server_name,
			orderBy = 'title',
			orderSort = 'asc',
			isArchived = false,
			showNavigationFields = true
		} />
		<cfset var i = '' />
		<cfset var pathPart = '' />
		<cfset var results = '' />
		
		<!--- Expand the with defaults --->
		<cfset arguments.filter = extend(defaults, arguments.filter) />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT DISTINCT p."pathID", p."contentID", p."themeID", p."path", p."isActive", p."template", c."title" AS contentTitle<cfif arguments.filter.showNavigationFields>, bpn."navigationID", bpn."title", bpn."groupBy", bpn."orderBy"</cfif>
			FROM "#variables.datasource.prefix#content"."path" p
			JOIN "#variables.datasource.prefix#content"."content" c
				ON c."contentID" = p."contentID"
			JOIN "#variables.datasource.prefix#content"."host" h
				ON c."domainID" = h."domainID"
					AND h."hostname" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.domain#" />
			<!--- If there is a navigation ID given it means we want a full join --->
			<cfif structKeyExists(arguments.filter, 'navigationID') and arguments.filter.navigationID neq '' and arguments.filter.navigationID neq 'NULL'>
				JOIN "#variables.datasource.prefix#content"."bPath2Navigation" bpn
					ON p."pathID" = bpn."pathID"
					AND bpn."navigationID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.navigationID#" />::uuid
			<cfelse>
				LEFT JOIN "#variables.datasource.prefix#content"."bPath2Navigation" bpn
					ON p."pathID" = bpn."pathID"
			</cfif>
			WHERE 1=1
			
			<cfif structKeyExists(arguments.filter, 'search') and arguments.filter.search neq ''>
				AND (
					bpn."title" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
					OR p."path" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
				)
			</cfif>
			
			<!--- Check if we want to find a key in the path --->
			<cfif structKeyExists(arguments.filter, 'pathKey')>
				AND (
					p."path" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%/#arguments.filter.pathKey#" />
					OR p."path" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%/#arguments.filter.pathKey#/%" />
					OR p."path" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.pathKey#/%" />
				)
			</cfif>
			
			<!--- Check for path specific filters --->
			<cfif structKeyExists(arguments.filter, 'keyAlongPathOrPath')>
				<!--- Find a key that is along the path --->
				<cfparam name="arguments.filter.path" default="/" />
				
				<!--- Match a specific path or look for a key along the path --->
				AND (
					LOWER(p."path") = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(variables.path.clean(arguments.filter.path))#" />
					OR LOWER(p."path") IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(variables.path.createList(variables.path.clean(arguments.filter.path), arguments.filter.keyAlongPathOrPath))#" list="true" />)
				)
			<cfelseif structKeyExists(arguments.filter, 'keyAlongPath')>
				<!--- Find a key that is along the path --->
				<cfparam name="arguments.filter.path" default="/" />
				
				AND LOWER(p."path") IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(variables.path.createList(variables.path.clean(arguments.filter.path), arguments.filter.keyAlongPath))#" list="true" />)
			<cfelseif structKeyExists(arguments.filter, 'alongPath')>
				<!--- Find any path along the path --->
				AND LOWER(p."path") IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(variables.path.createList(variables.path.clean(arguments.filter.alongPath)))#" list="true" />)
			<cfelseif structKeyExists(arguments.filter, 'searchPath')>
				<!--- Match a specific path --->
				AND LOWER(p."path") LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#lcase(arguments.filter.searchPath)#%" />
			<cfelseif structKeyExists(arguments.filter, 'pathPrefix')>
				<cfset cleaned = variables.path.clean(arguments.filter.pathPrefix) />
				
				<cfif cleaned NEQ '/'>
					<cfset cleaned &= '/' />
				</cfif>
				
				<!--- Match a specific path --->
				AND LOWER(p."path") LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(cleaned)#%" />
				
				<!--- Restrict to only the level that is prefixed but allow for wildcard paths --->
				<cfif structKeyExists(arguments.filter, 'oneLevelOnly') and arguments.filter.oneLevelOnly eq true>
					AND (
						LOWER(p."path") NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(cleaned)#%/%" />
						OR (
							LOWER(p."path") LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(cleaned)#%/*" />
							AND LOWER(p."path") NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(cleaned)#%/%/*" />
						)
					)
				</cfif>
			<cfelseif structKeyExists(arguments.filter, 'path')>
				<!--- Match a specific path --->
				AND LOWER(p."path") = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(variables.path.clean(arguments.filter.path))#" />
			</cfif>
			
			<!--- Handle looking for missing navigation --->
			<cfif structKeyExists(arguments.filter, 'navigationID') and arguments.filter.navigationID neq '' and arguments.filter.navigationID eq 'NULL'>
				AND bpn."navigationID" IS NULL
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'notPath') and arguments.filter.notPath neq ''>
				AND p."path" <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#variables.path.clean(arguments.filter.notPath)#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'contentID') and arguments.filter.contentID neq ''>
				AND p."contentID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.contentID#" />::uuid
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'in')>
				AND p."pathID" NOT IN (
					<cfloop from="1" to="#arrayLen(arguments.filter.in)#" index="i">
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.in[i]#" null="#arguments.filter.in[i] eq ''#" />::uuid<cfif i lt arrayLen(arguments.filter.in)>,</cfif>
					</cfloop>
				)
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'notIn')>
				AND p."pathID" NOT IN (
					<cfloop from="1" to="#arrayLen(arguments.filter.notIn)#" index="i">
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.notIn[i]#" null="#arguments.filter.notIn[i] eq ''#" />::uuid<cfif i lt arrayLen(arguments.filter.notIn)>,</cfif>
					</cfloop>
				)
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'isArchived')>
				AND c."archivedOn" IS <cfif arguments.filter.isArchived>NOT</cfif> NULL
			</cfif>
			
			ORDER BY
			<cfswitch expression="#arguments.filter.orderBy#">
				<cfcase value="orderBy">
					bpn."orderBy" #arguments.filter.orderSort#,
					c."title" ASC
				</cfcase>
				<cfcase value="updatedOn">
					c."updatedOn" #arguments.filter.orderSort#,
					c."title" ASC
				</cfcase>
				<cfcase value="title">
					bpn."title" #arguments.filter.orderSort#
				</cfcase>
				<cfcase value="path">
					p."path" #arguments.filter.orderSort#
				</cfcase>
				<cfdefaultcase>
					p."path" #arguments.filter.orderSort#
				</cfdefaultcase>
			</cfswitch>
			
			<cfif structKeyExists(arguments.filter, 'limit')>
				LIMIT <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.limit#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'offset')>
				OFFSET <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.offset#" />
			</cfif>
		</cfquery>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="setPath" access="public" returntype="void" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="path" type="component" required="true" />
		
		<cfset var i = '' />
		<cfset var isLevelChanged = false />
		<cfset var observer = '' />
		<cfset var results = '' />
		<cfset var path = '' />
		<cfset var paths = '' />
		<cfset var results = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('content', 'path') />
		
		<!--- Before Save Event --->
		<cfset observer.beforeSave(variables.transport, arguments.currUser, arguments.path) />
		
		<!--- Make sure that the path is unique to this domain --->
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "pathID"
			FROM "#variables.datasource.prefix#content"."path"
			WHERE "contentID" <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path.getContentID()#" />::uuid
				AND "path" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path.getPath()#" />
				AND "contentID" IN (
					SELECT "contentID"
					FROM "#variables.datasource.prefix#content"."content"
					WHERE "domainID" IN (
						SELECT "domainID"
						FROM "#variables.datasource.prefix#content"."content"
						WHERE "contentID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path.getContentID()#" />::uuid
					)
				)
		</cfquery>
		
		<cfif results.recordCount>
			<cfthrow type="validation" message="The '#arguments.path.getPath()#' path is already in use" detail="The '#arguments.path.getPath()#' path is already in use for the domain" />
		</cfif>
		
		<cfif arguments.path.getPathID() neq ''>
			<!--- Before Update Event --->
			<cfset observer.beforeUpdate(variables.transport, arguments.currUser, arguments.path) />
			
			<!--- Check if the path changes levels --->
			<cfquery name="results" datasource="#variables.datasource.name#">
				SELECT "path"
				FROM "#variables.datasource.prefix#content"."path"
				WHERE
					"pathID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path.getPathID()#" />::uuid
			</cfquery>
			
			<cfif results.recordCount>
				<cfset isLevelChanged = variables.path.getLevel( results.path ) != variables.path.getLevel( arguments.path.getPath() ) />
			</cfif>
			
			<cftransaction>
				<cfif isLevelChanged>
					<cfquery datasource="#variables.datasource.name#">
						DELETE
						FROM "#variables.datasource.prefix#content"."bPath2Navigation"
						WHERE
							"pathID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path.getPathID()#" />::uuid
					</cfquery>
				</cfif>
				
				<cfquery datasource="#variables.datasource.name#">
					UPDATE "#variables.datasource.prefix#content"."path"
					SET
						"contentID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path.getContentID()#" null="#arguments.path.getContentID() eq ''#" />::uuid,
						"themeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path.getThemeID()#" null="#arguments.path.getThemeID() eq ''#" />::uuid,
						"path" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path.getPath()#" />,
						"isActive" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path.getIsActive()#" />::bit,
						"template" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path.getTemplate()#" null="#arguments.path.getTemplate() eq ''#" />
					WHERE
						"pathID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path.getPathID()#" />::uuid
				</cfquery>
			</cftransaction>
			
			<!--- After Update Event --->
			<cfset observer.afterUpdate(variables.transport, arguments.currUser, arguments.path) />
		<cfelse>
			<!--- Before Create Event --->
			<cfset observer.beforeCreate(variables.transport, arguments.currUser, arguments.path) />
			
			<!--- Insert as a new record --->
			<!--- Create the new ID --->
			<cfset arguments.path.setPathID( createUUID() ) />
			
			<cftransaction>
				<cfquery datasource="#variables.datasource.name#">
					INSERT INTO "#variables.datasource.prefix#content"."path" (
						"pathID",
						"contentID",
						"themeID",
						"path",
						"isActive",
						"template"
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path.getPathID()#" null="#arguments.path.getPathID() eq ''#" />::uuid,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path.getContentID()#" null="#arguments.path.getContentID() eq ''#" />::uuid,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path.getThemeID()#" null="#arguments.path.getThemeID() eq ''#" />::uuid,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path.getPath()#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path.getIsActive()#" />::bit,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path.getTemplate()#" null="#arguments.path.getTemplate() eq ''#" />
					)
				</cfquery>
			</cftransaction>
			
			<!--- After Create Event --->
			<cfset observer.afterCreate(variables.transport, arguments.currUser, arguments.path) />
		</cfif>
		
		<!--- After Save Event --->
		<cfset observer.afterSave(variables.transport, arguments.currUser, arguments.path) />
	</cffunction>
</cfcomponent>
