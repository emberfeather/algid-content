<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="archiveType" access="public" returntype="void" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="type" type="component" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var observer = '' />
		<cfset var results = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('content', 'type') />
		
		<!--- TODO Check user permissions --->
		
		<!--- Before Archive Event --->
		<cfset observer.beforeArchive(variables.transport, arguments.currUser, arguments.type) />
		
		<!--- Archive the type --->
		<cftransaction>
			<cfquery datasource="#variables.datasource.name#" result="results">
				UPDATE "#variables.datasource.prefix#content"."type"
				SET
					"archivedOn" = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" />
				WHERE
					"typeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type.getTypeID()#" />::uuid
			</cfquery>
		</cftransaction>
		
		<!--- After Archive Event --->
		<cfset observer.afterArchive(variables.transport, arguments.currUser, arguments.type) />
	</cffunction>
	
	<cffunction name="getType" access="public" returntype="component" output="false">
		<cfargument name="typeID" type="string" required="true" />
		
		<cfset var type = '' />
		<cfset var modelSerial = '' />
		<cfset var results = '' />
		
		<cfset type = getModel('content', 'type') />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "typeID", "type", "archivedOn"
			FROM "#variables.datasource.prefix#content"."type"
			WHERE "typeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.typeID#" null="#arguments.typeID eq ''#" />::uuid
		</cfquery>
		
		<cfif results.recordCount>
			<cfset modelSerial = variables.transport.theApplication.factories.transient.getModelSerial(variables.transport) />
			
			<cfset modelSerial.deserialize(results, type) />
		</cfif>
		
		<cfreturn type />
	</cffunction>
	
	<cffunction name="getTypes" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var defaults = {
				isArchived = false,
				orderBy = 'type',
				orderSort = 'asc'
			} />
		<cfset var results = '' />
		
		<!--- Expand the with defaults --->
		<cfset arguments.filter = extend(defaults, arguments.filter) />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "typeID", "type", "archivedOn"
			FROM "#variables.datasource.prefix#content"."type"
			WHERE 1=1
			
			<cfif structKeyExists(arguments.filter, 'search') and arguments.filter.search neq ''>
				and (
					"type" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
				)
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'isArchived')>
				and "archivedOn" IS <cfif arguments.filter.isArchived>NOT</cfif> NULL
			</cfif>
			
			ORDER BY
			<cfswitch expression="#arguments.filter.orderBy#">
				<cfdefaultcase>
					"type" #arguments.filter.orderSort#
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
	
	<cffunction name="hasType" access="public" returntype="boolean" output="false">
		<cfargument name="type" type="string" required="true" />
		
		<cfset var results = '' />
		
		<cfset arguments.type = trim(arguments.type) />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "typeID"
			FROM "#variables.datasource.prefix#content"."type"
			WHERE "type" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#" />
				AND "archivedOn" IS NULL
		</cfquery>
		
		<cfreturn results.recordCount GT 0 />
	</cffunction>
	
	<cffunction name="setType" access="public" returntype="void" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="type" type="component" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var observer = '' />
		<cfset var results = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('content', 'type') />
		
		<!--- TODO Check user permissions --->
		
		<!--- Before Save Event --->
		<cfset observer.beforeSave(variables.transport, arguments.currUser, arguments.type) />
		
		<cfif arguments.type.getTypeID() eq ''>
			<!--- Check for archived type --->
			<cfquery datasource="#variables.datasource.name#" name="results">
				SELECT "type", "archivedOn"
				FROM "#variables.datasource.prefix#content"."type"
				WHERE
					"type" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type.getType()#" />
			</cfquery>
			
			<!--- Check if we found an existing type --->
			<cfif results.recordCount gt 0>
				<cfif results.archivedOn eq ''>
					<!--- Duplicate type --->
					<cfthrow type="validation" message="Type name already in use" detail="The '#arguments.type.getType()#' type already exists." />
				<cfelse>
					<!--- Unarchive the type --->
					<cftransaction>
						<cfquery datasource="#variables.datasource.name#" result="results">
							UPDATE "#variables.datasource.prefix#content"."type"
							SET
								"archivedOn" = NULL
							WHERE
								"type" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type.getType()#" />
						</cfquery>
					</cftransaction>
					
					<!--- After Update Event --->
					<cfset observer.afterUnarchive(variables.transport, arguments.currUser, arguments.type) />
				</cfif>
			<cfelse>
				<!--- Insert as a new type --->
				<!--- Create the new ID --->
				<cfset arguments.type.setTypeID( createUUID() ) />
				
				<cftransaction>
					<cfquery datasource="#variables.datasource.name#" result="results">
						INSERT INTO "#variables.datasource.prefix#content"."type"
						(
							"typeID",
							"type"
						) VALUES (
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type.getTypeID()#" />::uuid,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type.getType()#" />
						)
					</cfquery>
				</cftransaction>
				
				<!--- After Create Event --->
				<cfset observer.afterCreate(variables.transport, arguments.currUser, arguments.type) />
			</cfif>
		<cfelse>
			<cftransaction>
				<cfquery datasource="#variables.datasource.name#" result="results">
					UPDATE "#variables.datasource.prefix#content"."type"
					SET
						"type" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type.getType()#" />,
						"archivedOn" = NULL
					WHERE
						"typeID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type.getTypeID()#" />::uuid
				</cfquery>
			</cftransaction>
			
			<!--- After Update Event --->
			<cfset observer.afterUpdate(variables.transport, arguments.currUser, arguments.type) />
		</cfif>
		
		<!--- After Save Event --->
		<cfset observer.afterSave(variables.transport, arguments.currUser, arguments.type) />
	</cffunction>
</cfcomponent>