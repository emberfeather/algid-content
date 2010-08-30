<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="archiveTheme" access="public" returntype="component" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="theme" type="component" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var observer = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('content', 'theme') />
		
		<!--- Get the event log from the transport --->
		<cfset eventLog = variables.transport.theApplication.managers.singleton.getEventLog() />
		
		<!--- TODO Check user Permissions --->
		
		<!--- Before Archive Event --->
		<cfset observer.beforeArchive(variables.transport, arguments.currUser, arguments.theme) />
		
		<!--- TODO Archive the content --->
		
		<!--- After Archive Event --->
		<cfset observer.afterArchive(variables.transport, arguments.currUser, arguments.theme) />
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
	<cffunction name="getTheme" access="public" returntype="component" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="themeID" type="string" required="true" />
		
		<cfset var theme = '' />
		<cfset var i = '' />
		<cfset var objectSerial = '' />
		<cfset var observer = '' />
		<cfset var path = '' />
		<cfset var results = '' />
		<cfset var type = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('content', 'theme') />
		
		<cfset theme = getModel('content', 'theme') />
		
		<cfif arguments.themeID neq ''>
			<cfquery name="results" datasource="#variables.datasource.name#">
				SELECT "themeID", "theme", "directory", "levels", "isPublic", "archivedOn"
				FROM "#variables.datasource.prefix#content"."theme"
				WHERE "themeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.themeID#" null="#arguments.themeID eq ''#" />::uuid
				
				<!--- TODO Check for user connection --->
			</cfquery>
			
			<cfif results.recordCount>
				<cfset objectSerial = variables.transport.theApplication.managers.singleton.getObjectSerial() />
				
				<cfset objectSerial.deserialize(results, theme) />
			</cfif>
		</cfif>
		
		<!--- After Read Event --->
		<cfset observer.afterRead(variables.transport, arguments.currUser, theme) />
		
		<cfreturn theme />
	</cffunction>
	
	<cffunction name="getThemes" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var defaults = {
				alongPath = '',
				domain = '',
				orderBy = 'theme',
				orderSort = 'asc',
				path = ''
			} />
		<cfset var i = '' />
		<cfset var pathPart = '' />
		<cfset var results = '' />
		
		<!--- Expand the with defaults --->
		<cfset arguments.filter = extend(defaults, arguments.filter) />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT t."themeID", p."path", t."theme", t."directory", t."levels", t."isPublic", t."archivedOn"
			FROM "#variables.datasource.prefix#content"."theme" AS t
			
			<cfif arguments.filter.domain neq '' or arguments.filter.alongPath neq '' or arguments.filter.path neq ''>
				JOIN "#variables.datasource.prefix#content"."path" AS p
					ON t."themeID" = p."themeID"
				JOIN "#variables.datasource.prefix#content"."content" AS c
					ON c."contentID" = p."contentID"
				JOIN "#variables.datasource.prefix#content"."domain" AS d
					ON c."domainID" = d."domainID"
						AND d."domain" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.domain#" />
			</cfif>
			
			WHERE 1=1
			
			<cfif structKeyExists(arguments.filter, 'search') and arguments.filter.search neq ''>
				AND (
					t."theme" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
					OR p."path" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
				)
			</cfif>
			
			<!--- Check for path specific filters --->
			<cfif arguments.filter.alongPath neq ''>
				<!--- Find any theme along the path --->
				AND LOWER(p."path") IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(createPathList(cleanPath(arguments.filter.alongPath)))#" list="true" />)
			<cfelseif arguments.filter.path neq ''>
				<!--- Match a specific path --->
				AND LOWER(p."path") = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(cleanPath(arguments.filter.path))#" />
			</cfif>
			
			ORDER BY
			<cfswitch expression="#arguments.filter.orderBy#">
				<cfcase value="path">
					p."path" #arguments.filter.orderSort#
				</cfcase>
				<cfdefaultcase>
					t."theme" #arguments.filter.orderSort#
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
	
	<cffunction name="setTheme" access="public" returntype="void" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="theme" type="component" required="true" />
		
		<cfset var i = '' />
		<cfset var observer = '' />
		<cfset var results = '' />
		<cfset var path = '' />
		<cfset var paths = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('content', 'theme') />
		
		<!--- TODO Check user permissions --->
		
		<!--- Before Save Event --->
		<cfset observer.beforeSave(variables.transport, arguments.currUser, arguments.theme) />
		
		<cfif arguments.theme.getThemeID() neq ''>
			<!--- Before Update Event --->
			<cfset observer.beforeUpdate(variables.transport, arguments.currUser, arguments.theme) />
			
			<cftransaction>
				<cfquery datasource="#variables.datasource.name#">
					UPDATE "#variables.datasource.prefix#content"."theme"
					SET
						"typeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.theme.getTypeID()#" null="#arguments.theme.getTypeID() eq ''#" />::uuid,
						"domainID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.theme.getDomainID()#" />::uuid,
						"title" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.theme.getTitle()#" />,
						"theme" = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.theme.getTheme()#" />,
						"updatedOn" = now(),
						"archivedOn" = NULL
					WHERE
						"themeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.theme.getThemeID()#" />::uuid
				</cfquery>
			</cftransaction>
			
			<!--- After Update Event --->
			<cfset observer.afterUpdate(variables.transport, arguments.currUser, arguments.theme) />
		<cfelse>
			<!--- Before Create Event --->
			<cfset observer.beforeCreate(variables.transport, arguments.currUser, arguments.theme) />
			
			<!--- Insert as a new domain --->
			<!--- Create the new ID --->
			<cfset arguments.theme.setThemeID( createUUID() ) />
			
			<cftransaction>
				<cfquery datasource="#variables.datasource.name#">
					INSERT INTO "#variables.datasource.prefix#content"."theme" (
						"themeID",
						"domainID",
						"title",
						"theme", 
						"updatedOn"
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.theme.getThemeID()#" />::uuid,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.theme.getDomainID()#" />::uuid,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.theme.getTitle()#" />,
						<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.theme.getTheme()#" />,
						now()
					)
				</cfquery>
			</cftransaction>
			
			<!--- After Create Event --->
			<cfset observer.afterCreate(variables.transport, arguments.currUser, arguments.theme) />
		</cfif>
		
		<!--- After Save Event --->
		<cfset observer.afterSave(variables.transport, arguments.currUser, arguments.theme) />
	</cffunction>
</cfcomponent>
