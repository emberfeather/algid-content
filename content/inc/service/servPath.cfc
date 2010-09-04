<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="deletePath" access="public" returntype="void" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="path" type="component" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var observer = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('content', 'path') />
		
		<!--- Get the event log from the transport --->
		<cfset eventLog = variables.transport.theApplication.managers.singleton.getEventLog() />
		
		<!--- TODO Check user Permissions --->
		
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
		
		<!--- TODO Check user Permissions --->
		
		<!--- Before Delete Bulk Event --->
		<cfset observer.beforeDeleteBulk(variables.transport, arguments.currUser, arguments.filter) />
		
		<!--- Delete the path --->
		<cfquery datasource="#variables.datasource.name#">
			DELETE
			FROM "#variables.datasource.prefix#content"."path"
			WHERE "contentID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.contentID#" null="#arguments.filter.contentID eq ''#" />::uuid
			
			<cfif structKeyExists(arguments.filter, 'in')>
				AND "pathID" IN (
					<cfloop from="1" to="#listLen(arguments.filter.in)#" index="i">
						<cfset id = listGetAt(arguments.filter.in, i) />
						
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#id#" null="#id eq ''#" />::uuid<cfif i lt listLen(arguments.filter.in)>,</cfif>
					</cfloop>
				)
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'notIn')>
				AND "pathID" NOT IN (
					<cfloop from="1" to="#listLen(arguments.filter.notIn)#" index="i">
						<cfset id = listGetAt(arguments.filter.notIn, i) />
						
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#id#" null="#id eq ''#" />::uuid<cfif i lt listLen(arguments.filter.notIn)>,</cfif>
					</cfloop>
				)
			</cfif>
		</cfquery>
		
		<!--- After Delete Bulk Event --->
		<cfset observer.afterDeleteBulk(variables.transport, arguments.currUser, arguments.filter) />
	</cffunction>
<cfscript>
	/* required path */
	private string function cleanPath(string dirtyPath) {
		var path = getModel('content', 'path');
		
		return path.cleanPath(arguments.dirtyPath);
	}
	
	/* required path */
	private string function createPathList( string path, string key = '' ) {
		var pathList = '';
		var pathPart = '';
		var i = '';
		
		// If provided a key then prepend a slash so it can be added to the end of the pathPart
		if(arguments.key != '') {
			arguments.key = '/' & arguments.key;
		} else {
			// Handle the root path possibility
			pathList = listAppend(pathList, '/');
		}
		
		// Set the base path in the path list
		pathList = listAppend(pathList, arguments.key);
		
		// Make the list from each part of the provided path
		for( i = 1; i <= listLen(arguments.path, '/'); i++ ) {
			pathPart = listAppend(pathPart, listGetAt(arguments.path, i, '/'), '/');
			
			pathList = listAppend(pathList, '/' & pathPart & arguments.key);
		}
		
		return pathList;
	}
</cfscript>
	
	<cffunction name="getPath" access="public" returntype="component" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="pathID" type="string" required="true" />
		
		<cfset var i = '' />
		<cfset var objectSerial = '' />
		<cfset var observer = '' />
		<cfset var path = '' />
		<cfset var results = '' />
		<cfset var type = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('content', 'path') />
		
		<cfset path = getModel('content', 'path') />
		
		<cfif arguments.pathID neq ''>
			<cfquery name="results" datasource="#variables.datasource.name#">
				SELECT "pathID", "contentID", "themeID", "navigationID", "title", "path", "groupBy", "orderBy", "isActive", "template"
				FROM "#variables.datasource.prefix#content"."path"
				WHERE "pathID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pathID#" null="#arguments.pathID eq ''#" />::uuid
				
				<!--- TODO Check for user connection --->
			</cfquery>
			
			<cfif results.recordCount>
				<cfset objectSerial = variables.transport.theApplication.managers.singleton.getObjectSerial() />
				
				<cfset objectSerial.deserialize(results, path) />
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
				orderSort = 'asc'
			} />
		<cfset var i = '' />
		<cfset var pathPart = '' />
		<cfset var results = '' />
		
		<!--- Expand the with defaults --->
		<cfset arguments.filter = extend(defaults, arguments.filter) />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT p."pathID", p."contentID", p."themeID", p."navigationID", p."path", p."title", p."groupBy", p."orderBy", p."isActive", p."template"
			FROM "#variables.datasource.prefix#content"."path" p
			JOIN "#variables.datasource.prefix#content"."content" c
				ON c."contentID" = p."contentID"
			JOIN "#variables.datasource.prefix#content"."domain" d
				ON c."domainID" = d."domainID"
					AND d."domain" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.domain#" />
			WHERE 1=1
			
			<cfif structKeyExists(arguments.filter, 'search') and arguments.filter.search neq ''>
				AND (
					p."title" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
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
					LOWER(p."path") = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(cleanPath(arguments.filter.path))#" />
					OR LOWER(p."path") IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(createPathList(cleanPath(arguments.filter.path), arguments.filter.keyAlongPathOrPath))#" list="true" />)
				)
			<cfelseif structKeyExists(arguments.filter, 'keyAlongPath')>
				<!--- Find a key that is along the path --->
				<cfparam name="arguments.filter.path" default="/" />
				
				AND LOWER(p."path") IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(createPathList(cleanPath(arguments.filter.path), arguments.filter.keyAlongPath))#" list="true" />)
			<cfelseif structKeyExists(arguments.filter, 'alongPath')>
				<!--- Find any path along the path --->
				AND LOWER(p."path") IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(createPathList(cleanPath(arguments.filter.alongPath)))#" list="true" />)
			<cfelseif structKeyExists(arguments.filter, 'searchPath')>
				<!--- Match a specific path --->
				AND LOWER(p."path") LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#lcase(arguments.filter.searchPath)#%" />
			<cfelseif structKeyExists(arguments.filter, 'pathPrefix')>
				<cfset cleaned = cleanPath(arguments.filter.pathPrefix) />
				
				<cfif cleaned NEQ '/'>
					<cfset cleaned &= '/' />
				</cfif>
				
				<!--- Match a specific path --->
				AND LOWER(p."path") LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(cleaned)#%" />
				
				<!--- Restrict to only the level that is prefixed --->
				<cfif structKeyExists(arguments.filter, 'oneLevelOnly') and arguments.filter.oneLevelOnly eq true>
					AND LOWER(p."path") NOT LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#cleaned#%/%" />
				</cfif>
			<cfelseif structKeyExists(arguments.filter, 'path')>
				<!--- Match a specific path --->
				AND LOWER(p."path") = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(cleanPath(arguments.filter.path))#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'notPath') and arguments.filter.notPath neq ''>
				AND p."path" <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#cleanPath(arguments.filter.notPath)#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'contentID') and arguments.filter.contentID neq ''>
				AND p."contentID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.contentID#" />::uuid
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'navigationID') and arguments.filter.navigationID neq ''>
				AND p."navigationID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.navigationID#" />::uuid
			</cfif>
			
			ORDER BY
			<cfswitch expression="#arguments.filter.orderBy#">
				<cfcase value="updatedOn">
					c."updatedOn" #arguments.filter.orderSort#,
					c."title" ASC
				</cfcase>
				<cfcase value="title">
					p."title" #arguments.filter.orderSort#
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
		<cfset var observer = '' />
		<cfset var results = '' />
		<cfset var path = '' />
		<cfset var paths = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('content', 'path') />
		
		<!--- TODO Check user permissions --->
		
		<!--- Before Save Event --->
		<cfset observer.beforeSave(variables.transport, arguments.currUser, arguments.path) />
		
		<cfif arguments.path.getPathID() neq ''>
			<!--- Before Update Event --->
			<cfset observer.beforeUpdate(variables.transport, arguments.currUser, arguments.path) />
			
			<cftransaction>
				<cfquery datasource="#variables.datasource.name#">
					UPDATE "#variables.datasource.prefix#content"."path"
					SET
						"contentID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path.getContentID()#" null="#arguments.path.getContentID() eq ''#" />::uuid,
						"themeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path.getThemeID()#" null="#arguments.path.getThemeID() eq ''#" />::uuid,
						"navigationID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path.getNavigationID()#" null="#arguments.path.getNavigationID() eq ''#" />::uuid,
						"title" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path.getTitle()#" />,
						"path" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path.getPath()#" />,
						"groupBy" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path.getGroupBy()#" null="#arguments.path.getGroupBy() eq ''#" />,
						"orderBy" = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.path.getOrderBy()#" />,
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
			
			<!--- Insert as a new domain --->
			<!--- Create the new ID --->
			<cfset arguments.path.setPathID( createUUID() ) />
			
			<cftransaction>
				<cfquery datasource="#variables.datasource.name#">
					INSERT INTO "#variables.datasource.prefix#content"."path" (
						"pathID",
						"contentID",
						"themeID",
						"navigationID",
						"title",
						"path",
						"groupBy",
						"orderBy",
						"isActive",
						"template"
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path.getPathID()#" null="#arguments.path.getPathID() eq ''#" />::uuid,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path.getContentID()#" null="#arguments.path.getContentID() eq ''#" />::uuid,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path.getThemeID()#" null="#arguments.path.getThemeID() eq ''#" />::uuid,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path.getNavigationID()#" null="#arguments.path.getNavigationID() eq ''#" />::uuid,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path.getTitle()#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path.getPath()#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.path.getGroupBy()#" null="#arguments.path.getGroupBy() eq ''#" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.path.getOrderBy()#" />,
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
