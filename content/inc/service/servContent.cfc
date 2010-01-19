<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="deleteContent" access="public" returntype="component" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="content" type="component" required="true" />
		
		<cfset var eventLog = '' />
		
		<!--- Get the event log from the transport --->
		<cfset eventLog = variables.transport.theApplication.managers.singleton.getEventLog() />
		
		<!--- TODO Check user Permissions --->
		
		<!--- TODO Archive the content --->
		
		<cfset eventLog.logEvent('content', 'contentArchive', 'Archived the ''' & arguments.content.getTitle() & ''' content.', arguments.currUser.getUserID(), arguments.content.getContentID()) />
	</cffunction>
	
	<cffunction name="getContent" access="public" returntype="component" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="contentID" type="string" required="true" />
		
		<cfset var content = '' />
		<cfset var i18n = '' />
		<cfset var objectSerial = '' />
		<cfset var results = '' />
		
		<cfset i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		
		<cfset content = variables.transport.theApplication.factories.transient.getModContentForContent( i18n, variables.transport.theSession.managers.singleton.getSession().getLocale() ) />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "contentID", "domainID", "typeID", "title", "content", "createdOn", "updatedOn", "expiresOn", "archivedOn"
			FROM "#variables.datasource.prefix#content"."content"
			WHERE "contentID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contentID#" null="#arguments.contentID eq ''#" />::uuid
			
			<!--- TODO Check for user connection --->
		</cfquery>
		
		<cfif results.recordCount>
			<cfset objectSerial = variables.transport.theApplication.managers.singleton.getObjectSerial() />
			
			<cfset objectSerial.deserialize(results, content) />
		</cfif>
		
		<cfreturn content />
	</cffunction>
	
	<cffunction name="getContents" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var defaults = {
				domain = CGI.SERVER_NAME,
				orderBy = 'title',
				orderSort = 'asc'
			} />
		<cfset var results = '' />
		
		<!--- Expand the with defaults --->
		<cfset arguments.filter = extend(defaults, arguments.filter) />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT p."path", p."title" AS navTitle, t."type", c."title", c."createdOn", c."updatedOn", c."archivedOn"
			FROM "#variables.datasource.prefix#content"."content" AS c
			LEFT JOIN "#variables.datasource.prefix#content"."path" AS p
				ON c."contentID" = p."contentID"
			JOIN "#variables.datasource.prefix#content"."type" AS t
				ON c."typeID" = t."typeID"
			JOIN "#variables.datasource.prefix#content"."domain" AS d
				ON c."domainID" = d."domainID"
					and d."domain" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.domain#" />
			WHERE 1=1
			
			<cfif structKeyExists(arguments.filter, 'search') and arguments.filter.search neq ''>
				and (
					p."title" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
					or c."title" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
					or p."path" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
				)
			</cfif>
			
			ORDER BY
			<cfswitch expression="#arguments.filter.orderBy#">
				<cfcase value="updatedOn">
					p."path" #arguments.filter.orderSort#
				</cfcase>
				<cfcase value="updatedOn">
					c."updatedOn" #arguments.filter.orderSort#,
					c."title" ASC
				</cfcase>
				<cfdefaultcase>
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
	
	<cffunction name="publishContent" access="public" returntype="void" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="content" type="component" required="true" />
		
		<cfset var eventLog = '' />
		
		<!--- Get the event log from the transport --->
		<cfset eventLog = variables.transport.theApplication.managers.singleton.getEventLog() />
		
		<!--- TODO Check for user permission --->
		
		<!--- TODO Check if publishing the content --->
		<cfset eventLog.logEvent('content', 'contentPublish', 'Published the ''' & arguments.content.getTitle() & ''' content.', arguments.currUser.getUserID(), arguments.content.getContentID()) />
	</cffunction>
	
	<cffunction name="setContent" access="public" returntype="void" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="content" type="component" required="true" />
		
		<cfset var eventLog = '' />
		
		<!--- Get the event log from the transport --->
		<cfset eventLog = variables.transport.theApplication.managers.singleton.getEventLog() />
		
		<!--- TODO Check user permissions --->
		
		<cfif arguments.content.getContentID()>
			<cfset eventLog.logEvent('content', 'contentUpdate', 'Updated the ''' & arguments.content.getTitle() & ''' content.', arguments.currUser.getUserID(), arguments.content.getContentID()) />
		<cfelse>
			<cfset eventLog.logEvent('content', 'contentCreate', 'Created the ''' & arguments.content.getTitle() & ''' content.', arguments.currUser.getUserID(), arguments.content.getContentID()) />
		</cfif>
		
		<!--- TODO Check if publishing the content --->
	</cffunction>
</cfcomponent>