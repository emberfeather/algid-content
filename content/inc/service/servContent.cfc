<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="archiveContent" access="public" returntype="component" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="content" type="component" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var observer = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('content', 'content') />
		
		<!--- Get the event log from the transport --->
		<cfset eventLog = variables.transport.theApplication.managers.singleton.getEventLog() />
		
		<!--- TODO Check user Permissions --->
		
		<!--- Before Archive Event --->
		<cfset observer.beforeArchive(variables.transport, arguments.currUser, arguments.content) />
		
		<!--- TODO Archive the content --->
		
		<!--- After Archive Event --->
		<cfset observer.afterArchive(variables.transport, arguments.currUser, arguments.content) />
	</cffunction>
<cfscript>
	/* required path */
	private string function cleanPath(string dirtyPath) {
		var i18n = variables.transport.theApplication.managers.singleton.getI18N();
		var path = variables.transport.theApplication.factories.transient.getModPathForContent( i18n, variables.transport.theSession.managers.singleton.getSession().getLocale() );
		
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
	
	<cffunction name="getContent" access="public" returntype="component" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="contentID" type="string" required="true" />
		
		<cfset var content = '' />
		<cfset var i = '' />
		<cfset var i18n = '' />
		<cfset var locale = '' />
		<cfset var objectSerial = '' />
		<cfset var path = '' />
		<cfset var results = '' />
		
		<cfset i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		<cfset locale = variables.transport.theSession.managers.singleton.getSession().getLocale() />
		
		<cfset content = variables.transport.theApplication.factories.transient.getModContentForContent( i18n, locale ) />
		
		<cfif arguments.contentID neq ''>
			<cfquery name="results" datasource="#variables.datasource.name#">
				SELECT "contentID", "domainID", "typeID", "title", "content", "createdOn", "updatedOn", "expiresOn", "archivedOn"
				FROM "#variables.datasource.prefix#content"."content"
				WHERE "contentID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#" null="#arguments.contentID eq ''#" />::uuid
				
				<!--- TODO Check for user connection --->
			</cfquery>
			
			<cfif results.recordCount>
				<cfset objectSerial = variables.transport.theApplication.managers.singleton.getObjectSerial() />
				
				<cfset objectSerial.deserialize(results, content) />
				
				<!--- Retrieve the content paths --->
				<cfquery name="results" datasource="#variables.datasource.name#">
					SELECT "contentID", "pathID", "path", "title", "groupBy", "orderBy", "isActive", "navigationID", "themeID"
					FROM "#variables.datasource.prefix#content"."path"
					WHERE "contentID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#" null="#arguments.contentID eq ''#" />::uuid
					ORDER BY "path" ASC
				</cfquery>
				
				<cfloop query="results">
					<cfset path = variables.transport.theApplication.factories.transient.getModPathForContent( i18n, locale ) />
					
					<cfloop list="#structKeyList(results)#" index="i">
						<cfinvoke component="#path#" method="set#i#">
							<cfinvokeargument name="value" value="#results[i]#" />
						</cfinvoke>
					</cfloop>
					
					<cfset content.addPaths(path) />
				</cfloop>
			</cfif>
		</cfif>
		
		<cfreturn content />
	</cffunction>
	
	<cffunction name="getContents" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
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
			SELECT c."contentID", p."path", p."title" AS navTitle, t."type", c."title", c."createdOn", c."updatedOn", c."archivedOn", c."content"
			FROM "#variables.datasource.prefix#content"."content" AS c
			LEFT JOIN "#variables.datasource.prefix#content"."path" AS p
				ON c."contentID" = p."contentID"
			LEFT JOIN "#variables.datasource.prefix#content"."type" AS t
				ON c."typeID" = t."typeID"
			JOIN "#variables.datasource.prefix#content"."domain" AS d
				ON c."domainID" = d."domainID"
					AND d."domain" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.domain#" />
			WHERE 1=1
			
			<cfif structKeyExists(arguments.filter, 'search') and arguments.filter.search neq ''>
				AND (
					p."title" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
					OR c."title" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
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
			<cfif structKeyExists(arguments.filter, 'keyAlongPath')>
				<!--- Find a key that is along the path --->
				<cfparam name="arguments.filter.path" default="/" />
				
				AND p."path" IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#createPathList(cleanPath(arguments.filter.path), arguments.filter.keyAlongPath)#" list="true" />)
			<cfelseif structKeyExists(arguments.filter, 'alongPath')>
				<!--- Find any content along the path --->
				AND p."path" IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#createPathList(cleanPath(arguments.filter.alongPath))#" list="true" />)
			<cfelseif structKeyExists(arguments.filter, 'path')>
				<!--- Match a specific path --->
				AND p."path" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cleanPath(arguments.filter.path)#" />
			</cfif>
			
			ORDER BY
			<cfswitch expression="#arguments.filter.orderBy#">
				<cfcase value="updatedOn">
					c."updatedOn" #arguments.filter.orderSort#,
					c."title" ASC
				</cfcase>
				<cfcase value="navTitle">
					p."title" #arguments.filter.orderSort#,
					c."title" #arguments.filter.orderSort#
				</cfcase>
				<cfcase value="path">
					p."path" #arguments.filter.orderSort#
				</cfcase>
				<cfdefaultcase>
					p."path" #arguments.filter.orderSort#,
					c."title" #arguments.filter.orderSort#
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
	
	<cffunction name="getPath" access="public" returntype="component" output="false">
		<cfargument name="content" type="component" required="true" />
		<cfargument name="identifier" type="string" required="true" />
		
		<cfset var i18n = '' />
		<cfset var path = '' />
		<cfset var paths = '' />
		
		<!--- Retrieve the paths from the content --->
		<cfset paths = arguments.content.getPaths() />
		
		<!--- Check for an id match --->
		<cfloop array="#paths#" index="path">
			<cfif path.getPathID() eq identifier>
				<!--- Mark as used --->
				<!--- TODO figure out a better way of doing this... --->
				<cfset path.set__isUsed(true) />
				
				<cfreturn path />
			</cfif>
		</cfloop>
		
		<!--- Check for existing path with same path --->
		<cfloop array="#paths#" index="path">
			<cfif path.getPath() eq identifier>
				<!--- Mark as used --->
				<!--- TODO figure out a better way of doing this... --->
				<cfset path.set__isUsed(true) />
				
				<cfreturn path />
			</cfif>
		</cfloop>
		
		<!--- Not found so create a new path --->
		<cfset i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		
		<cfset path = variables.transport.theApplication.factories.transient.getModPathForContent( i18n, variables.transport.theSession.managers.singleton.getSession().getLocale() ) />
		
		<!--- Set the contentID and default title --->
		<cfset path.setContentID(arguments.content.getContentID()) />
		<cfset path.setPath(identifier) />
		<cfset path.setTitle(arguments.content.getTitle()) />
		
		<!--- Add to the content object --->
		<cfset arguments.content.addPaths(path) />
		
		<cfreturn path />
	</cffunction>
	
	<cffunction name="publishContent" access="public" returntype="void" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="content" type="component" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var observer = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('content', 'content') />
		
		<!--- TODO Check for user permission --->
		
		<!--- Before Publish Event --->
		<cfset observer.beforePublish(variables.transport, arguments.currUser, arguments.content) />
		
		<!--- TODO Publish the content --->
		
		<!--- After Publish Event --->
		<cfset observer.afterPublish(variables.transport, arguments.currUser, arguments.content) />
	</cffunction>
	
	<cffunction name="setContent" access="public" returntype="void" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="content" type="component" required="true" />
		
		<cfset var i = '' />
		<cfset var observer = '' />
		<cfset var results = '' />
		<cfset var path = '' />
		<cfset var paths = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('content', 'content') />
		
		<!--- TODO Check user permissions --->
		
		<!--- Retrieve the paths from the content --->
		<cfset paths = arguments.content.getPaths() />
		
		<!--- Before Save Event --->
		<cfset observer.beforeSave(variables.transport, arguments.currUser, arguments.content) />
		
		<cfif arguments.content.getContentID() neq ''>
			<!--- Before Update Event --->
			<cfset observer.beforeUpdate(variables.transport, arguments.currUser, arguments.content) />
			
			<cftransaction>
				<cfquery datasource="#variables.datasource.name#">
					UPDATE "#variables.datasource.prefix#content"."content"
					SET
						"typeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.content.getTypeID()#" null="#arguments.content.getTypeID() eq ''#" />::uuid,
						"domainID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.content.getDomainID()#" />::uuid,
						"title" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.content.getTitle()#" />,
						"content" = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.content.getContent()#" />,
						"updatedOn" = now(),
						"archivedOn" = NULL
					WHERE
						"contentID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.content.getContentID()#" />::uuid
				</cfquery>
			</cftransaction>
			
			<!--- After Update Event --->
			<cfset observer.afterUpdate(variables.transport, arguments.currUser, arguments.content) />
		<cfelse>
			<!--- Before Create Event --->
			<cfset observer.beforeCreate(variables.transport, arguments.currUser, arguments.content) />
			
			<!--- Insert as a new domain --->
			<!--- Create the new ID --->
			<cfset arguments.content.setContentID( createUUID() ) />
			
			<cftransaction>
				<cfquery datasource="#variables.datasource.name#">
					INSERT INTO "#variables.datasource.prefix#content"."content" (
						"contentID",
						"domainID",
						"title",
						"content"
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.content.getContentID()#" />::uuid,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.content.getDomainID()#" />::uuid,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.content.getTitle()#" />,
						<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.content.getContent()#" />
					)
				</cfquery>
			</cftransaction>
			
			<!--- After Create Event --->
			<cfset observer.afterCreate(variables.transport, arguments.currUser, arguments.content) />
		</cfif>
		
		<!--- Save the paths --->
		<cftransaction>
			<cfloop array="#paths#" index="path">
				<cfif path.getPathID() neq ''>
					<!--- Check if not used --->
					<!--- TODO figure out a better way of doing this... --->
					<cfif not path.has__isUsed()>
						<cfquery datasource="#variables.datasource.name#">
							DELETE
							FROM "#variables.datasource.prefix#content"."path"
							WHERE "pathID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#path.getPathID()#" />::uuid
						</cfquery>
					<cfelse>
						<cfquery datasource="#variables.datasource.name#">
							UPDATE "#variables.datasource.prefix#content"."path"
							SET
								"navigationID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#path.getNavigationID()#" null="#path.getNavigationID() eq ''#" />::uuid,
								"themeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#path.getThemeID()#" null="#path.getThemeID() eq ''#" />::uuid,
								"path" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#path.getPath()#" />,
								"title" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#path.getTitle()#" />,
								"groupBy" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#path.getGroupBy()#" maxlength="100" />,
								"orderBy" = <cfqueryparam cfsqltype="cf_sql_integer" value="#path.getOrderBy()#" />,
								"isActive" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#path.getIsActive()#" />::bit
							WHERE "pathID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#path.getPathID()#" />::uuid
						</cfquery>
					</cfif>
				<cfelse>
					<!--- Insert as a new path --->
					<!--- Create the new ID --->
					<cfset path.setPathID( createUUID() ) />
					
					<cfquery datasource="#variables.datasource.name#">
						INSERT INTO "#variables.datasource.prefix#content"."path" (
							"pathID",
							"contentID",
							"navigationID",
							"themeID",
							"path",
							"title",
							"groupBy",
							"orderBy",
							"isActive"
						) VALUES (
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#path.getPathID()#" />::uuid,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#path.getContentID()#" />::uuid,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#path.getNavigationID()#" null="#path.getNavigationID() eq ''#" />::uuid,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#path.getThemeID()#" null="#path.getThemeID() eq ''#" />::uuid,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#path.getPath()#" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#path.getTitle()#" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#path.getGroupBy()#" maxlength="100" />,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#path.getOrderBy()#" />,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#path.getIsActive()#" />::bit
						)
					</cfquery>
				</cfif>
			</cfloop>
		</cftransaction>
		
		<!--- After Save Event --->
		<cfset observer.afterSave(variables.transport, arguments.currUser, arguments.content) />
	</cffunction>
</cfcomponent>
