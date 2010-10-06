<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="archiveTheme" access="public" returntype="void" output="false">
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
		
		<!--- Archive the theme --->
		<cftransaction>
			<cfquery datasource="#variables.datasource.name#">
				UPDATE "#variables.datasource.prefix#content"."theme"
				SET "archivedOn" = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" />
				WHERE "themeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.theme.getThemeID()#" />::uuid
			</cfquery>
		</cftransaction>
		
		<!--- After Archive Event --->
		<cfset observer.afterArchive(variables.transport, arguments.currUser, arguments.theme) />
	</cffunction>
<cfscript>
	private string function cleanPath( required string dirtyPath ) {
		var path = getModel('content', 'path');
		
		return path.cleanPath(arguments.dirtyPath);
	}
	
	private string function createPathList( required string path, string key = '' ) {
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
		<cfset var path = '' />
		<cfset var results = '' />
		<cfset var type = '' />
		
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
		<cfset var hasExtraJoins = '' />
		<cfset var i = '' />
		<cfset var pathPart = '' />
		<cfset var results = '' />
		
		<!--- Expand the with defaults --->
		<cfset arguments.filter = extend(defaults, arguments.filter) />
		
		<cfset hasExtraJoins = arguments.filter.domain neq '' or arguments.filter.alongPath neq '' or arguments.filter.path neq '' />
		
		<!--- Only sort on the path when there is a path to sort --->
		<cfif arguments.filter.orderBy eq 'path' and not hasExtraJoins>
			<cfset arguments.filter.orderBy = '' />
		</cfif>
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT t."themeID", t."theme", t."directory", t."levels", t."isPublic", t."archivedOn"<cfif hasExtraJoins>, p."path"</cfif>
			FROM "#variables.datasource.prefix#content"."theme" AS t
			
			<cfif hasExtraJoins>
				JOIN "#variables.datasource.prefix#content"."path" AS p
					ON t."themeID" = p."themeID"
				JOIN "#variables.datasource.prefix#content"."content" AS c
					ON c."contentID" = p."contentID"
				<cfif arguments.filter.domain neq ''>
					JOIN "#variables.datasource.prefix#content"."host" AS h
						ON c."domainID" = h."domainID"
							AND h."hostname" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.domain#" />
				</cfif>
			</cfif>
			
			WHERE 1=1
			
			<cfif structKeyExists(arguments.filter, 'search') and arguments.filter.search neq ''>
				AND (
					t."theme" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
					<cfif hasExtraJoins>
						OR p."path" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
					</cfif>
				)
			</cfif>
			
			<cfif hasExtraJoins>
				<!--- Check for path specific filters --->
				<cfif structKeyExists(arguments.filter, 'keyAlongPathOrPath')>
					<!--- Find a key that is along the path --->
					<cfparam name="arguments.filter.path" default="/" />
					
					<!--- Match a specific path or look for a key along the path --->
					AND (
						LOWER(p."path") = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(cleanPath(arguments.filter.path))#" />
						OR LOWER(p."path") IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(createPathList(cleanPath(arguments.filter.path), arguments.filter.keyAlongPathOrPath))#" list="true" />)
					)
				<cfelseif arguments.filter.alongPath neq ''>
					<!--- Find any theme along the path --->
					AND LOWER(p."path") IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(createPathList(cleanPath(arguments.filter.alongPath)))#" list="true" />)
				<cfelseif arguments.filter.path neq ''>
					<!--- Match a specific path --->
					AND LOWER(p."path") = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lcase(cleanPath(arguments.filter.path))#" />
				</cfif>
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'isArchived')>
				and t."archivedOn" IS <cfif arguments.filter.isArchived>NOT</cfif> NULL
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
	
	<cffunction name="readThemeFromDisk" access="private" returntype="component" output="false">
		<cfargument name="plugin" type="string" default="" />
		<cfargument name="themeKey" type="string" default="" />
		
		<cfset var allNavigation = [] />
		<cfset var currentNavigation = '' />
		<cfset var currentTheme = '' />
		<cfset var fileContent = '' />
		<cfset var i = '' />
		<cfset var j = '' />
		<cfset var level = '' />
		<cfset var placement = '' />
		<cfset var navigation = '' />
		<cfset var objectSerial = '' />
		<cfset var theme = '' />
		
		<cfset theme = getModel('content', 'theme') />
		
		<cfset objectSerial = variables.transport.theApplication.managers.singleton.getObjectSerial() />
		
		<cfset fileContent = deserializeJSON(fileRead('/plugins/' & arguments.plugin & '/extend/content/theme/' & arguments.themeKey & '/theme.json.cfm')) />
		
		<cfset fileContent.directory = arguments.plugin & '/extend/content/theme/' & arguments.themeKey />
		<cfset fileContent.levels = arrayLen(fileContent.navigation) />
		
		<!--- Retrieve the current theme for comparison --->
		<cfquery name="currentTheme" datasource="#variables.datasource.name#">
			SELECT t."themeID", t."archivedOn"
			FROM "#variables.datasource.prefix#content"."theme" AS t
			WHERE t."directory" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#fileContent.directory#" />
		</cfquery>
		
		<cfset fileContent.themeID = currentTheme.themeID.toString() />
		<cfset fileContent.archivedOn = currentTheme.archivedOn />
		
		<cfset objectSerial.deserialize(fileContent, theme) />
		
		<!--- Set some properties for extra use, not really part of the model --->
		<cfset theme.setPlugin(arguments.plugin) />
		<cfset theme.setThemeDirectory(arguments.themeKey) />
		
		<!--- Create objects out of the navigation information --->
		<cfloop from="1" to="#arrayLen(fileContent.navigation)#" index="i">
			<cfloop from="1" to="#arrayLen(fileContent.navigation[i])#" index="j">
				<cfset navigation = getModel('content', 'navigation') />
				
				<cfset fileContent.navigation[i][j].themeID = currentTheme.themeID.toString() />
				<cfset fileContent.navigation[i][j].level = i />
				
				<!--- Retrieve the current theme for comparison --->
				<cfif fileContent.navigation[i][j].themeID neq ''>
					<cfquery name="currentNavigation" datasource="#variables.datasource.name#">
						SELECT "navigationID"
						FROM "#variables.datasource.prefix#content"."navigation"
						WHERE "themeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#fileContent.navigation[i][j].themeID#" />::uuid
							AND "navigation" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#fileContent.navigation[i][j].navigation#" />
							AND "level" = <cfqueryparam cfsqltype="cf_sql_smallint" value="#fileContent.navigation[i][j].level#" />
					</cfquery>
					
					<cfset fileContent.navigation[i][j].navigationID = currentNavigation.navigationID />
				<cfelse>
					<cfset fileContent.navigation[i][j].navigationID = '' />
				</cfif>
				
				<cfset objectSerial.deserialize(fileContent.navigation[i][j], navigation) />
				
				<cfset arrayAppend(allNavigation, navigation) />
			</cfloop>
		</cfloop>
		
		<cfset theme.setNavigation(allNavigation) />
		
		<cfreturn theme />
	</cffunction>
	
	<cffunction name="readTheme" access="public" returntype="component" output="false">
		<cfargument name="plugin" type="string" default="" />
		<cfargument name="themeDirectory" type="string" default="" />
		
		<cfset var availablePlugins = '' />
		<cfset var currentPlugin = '' />
		
		<!--- Check that the plugin in active if filtering for a specific one --->
		<cfset availablePlugins = transport.theApplication.managers.singleton.getApplication().getPluginsBy(arguments.plugin) />
		
		<cfloop array="#availablePlugins#" index="currentPlugin">
			<cfreturn readThemeFromDisk(currentPlugin, arguments.themeDirectory) />
		</cfloop>
		
		<cfreturn getModel('content', 'theme') />
	</cffunction>
	
	<cffunction name="readThemes" access="public" returntype="array" output="false">
		<cfargument name="plugin" type="string" default="" />
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var availablePlugins = '' />
		<cfset var basePath = '' />
		<cfset var currentPlugin = '' />
		<cfset var currentThemes = '' />
		<cfset var fileContent = '' />
		<cfset var results = [] />
		<cfset var themes = '' />
		<cfset var theme = '' />
		<cfset var themePath = '' />
		
		<!--- Check that the plugin is active if filtering for a specific one --->
		<cfset availablePlugins = transport.theApplication.managers.singleton.getApplication().getPluginsBy(arguments.plugin) />
		
		<cfloop array="#availablePlugins#" index="currentPlugin">
			<cfset basePath = '/plugins/#currentPlugin#/extend/content/theme' />
			
			<cfif directoryExists(basePath)>
				<cfdirectory action="list" directory="#basePath#" type="dir" name="themes" />
				
				<cfloop query="themes">
					<cfset theme = readThemeFromDisk(currentPlugin, themes.name) />
					
					<!--- Check if we are filtering by archived status --->
					<cfif structKeyExists(arguments.filter, 'isArchived')
						and (
							(arguments.filter.isArchived eq true and theme.getArchivedOn() eq '')
							or (arguments.filter.isArchived eq false and theme.getArchivedOn() neq '')
						)>
						<cfbreak />
					</cfif>
					
					<!--- Check if we are filtering by existing status --->
					<cfif structKeyExists(arguments.filter, 'isExisting')
						and (
							(
								arguments.filter.isExisting eq true 
								and theme.getThemeID() eq ''
							) or (
								arguments.filter.isExisting eq false
								and theme.getThemeID() neq ''
								and theme.getArchivedOn() eq ''
							)
						)>
						<cfbreak />
					</cfif>
					
					<!--- Check if we are filtering by search term --->
					<cfif structKeyExists(arguments.filter, 'search')
						and not (
							reFindNoCase('.*' & arguments.filter.search & '.*', theme.getTheme())
							or reFindNoCase('.*' & arguments.filter.search & '.*', theme.getDirectory())
						)>
						<cfbreak />
					</cfif>
					
					<cfset arrayAppend(results, theme) />
				</cfloop>
			</cfif>
		</cfloop>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="setTheme" access="public" returntype="void" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="theme" type="component" required="true" />
		
		<cfset var i = '' />
		<cfset var isArchived = '' />
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
			<cfquery name="isArchived" datasource="#variables.datasource.name#">
				SELECT "archivedOn"
				FROM "#variables.datasource.prefix#content"."theme"
				WHERE "themeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.theme.getThemeID()#" />::uuid
			</cfquery>
			
			<cfif isArchived.archivedOn eq ''>
				<!--- Before Update Event --->
				<cfset observer.beforeUpdate(variables.transport, arguments.currUser, arguments.theme) />
			<cfelse>
				<!--- Before Unarchive Event --->
				<cfset observer.beforeUnarchive(variables.transport, arguments.currUser, arguments.theme) />
			</cfif>
			
			<cftransaction>
				<cfquery datasource="#variables.datasource.name#">
					UPDATE "#variables.datasource.prefix#content"."theme"
					SET
						"theme" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.theme.getTheme()#" />,
						"directory" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.theme.getDirectory()#" />,
						"levels" = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.theme.getLevels()#" />,
						"isPublic" = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.theme.getIsPublic()#" />::boolean,
						"archivedOn" = NULL
					WHERE
						"themeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.theme.getThemeID()#" />::uuid
				</cfquery>
			</cftransaction>
			
			<cfif isArchived.archivedOn eq ''>
				<!--- After Update Event --->
				<cfset observer.afterUpdate(variables.transport, arguments.currUser, arguments.theme) />
			<cfelse>
				<!--- After Unarchive Event --->
				<cfset observer.afterUnarchive(variables.transport, arguments.currUser, arguments.theme) />
			</cfif>
		<cfelse>
			<!--- Before Create Event --->
			<cfset observer.beforeCreate(variables.transport, arguments.currUser, arguments.theme) />
			
			<!--- Insert as a new record --->
			<!--- Create the new ID --->
			<cfset arguments.theme.setThemeID( createUUID() ) />
			
			<cftransaction>
				<cfquery datasource="#variables.datasource.name#">
					INSERT INTO "#variables.datasource.prefix#content"."theme" (
						"themeID",
						"theme",
						"directory",
						"levels",
						"isPublic"
					) VALUES (
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.theme.getThemeID()#" />::uuid,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.theme.getTheme()#" />,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.theme.getDirectory()#" />,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.theme.getLevels()#" />,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.theme.getIsPublic()#" />::boolean
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
