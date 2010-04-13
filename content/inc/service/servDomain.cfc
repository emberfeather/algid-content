<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="archiveDomain" access="public" returntype="void" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="domain" type="component" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var observer = '' />
		<cfset var results = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('content', 'content') />
		
		<!--- TODO Check user permissions --->
		
		<!--- Before Archive Event --->
		<cfset observer.beforeArchive(variables.transport, arguments.currUser, arguments.content) />
		
		<!--- Archive the domain --->
		<cftransaction>
			<cfquery datasource="#variables.datasource.name#" result="results">
				UPDATE "#variables.datasource.prefix#content"."domain"
				SET
					"archivedOn" = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#" />
				WHERE
					"domainID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domain.getDomainID()#" />::uuid
			</cfquery>
		</cftransaction>
		
		<!--- After Archive Event --->
		<cfset observer.afterArchive(variables.transport, arguments.currUser, arguments.domain) />
	</cffunction>
	
	<cffunction name="getDomain" access="public" returntype="component" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="domainID" type="string" required="true" />
		
		<cfset var domain = '' />
		<cfset var i18n = '' />
		<cfset var objectSerial = '' />
		<cfset var results = '' />
		
		<cfset i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		
		<cfset domain = variables.transport.theApplication.factories.transient.getModDomainForContent( i18n, variables.transport.theSession.managers.singleton.getSession().getLocale() ) />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "domainID", "domain", "createdOn", "archivedOn"
			FROM "#variables.datasource.prefix#content"."domain"
			WHERE "domainID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domainID#" null="#arguments.domainID eq ''#" />::uuid
		</cfquery>
		
		<cfif results.recordCount>
			<cfset objectSerial = variables.transport.theApplication.managers.singleton.getObjectSerial() />
			
			<cfset objectSerial.deserialize(results, domain) />
		</cfif>
		
		<cfreturn domain />
	</cffunction>
	
	<cffunction name="getDomains" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var defaults = {
				isArchived = false,
				orderBy = 'domain',
				orderSort = 'asc'
			} />
		<cfset var results = '' />
		
		<!--- Expand the with defaults --->
		<cfset arguments.filter = extend(defaults, arguments.filter) />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "domainID", "domain", "createdOn", "archivedOn"
			FROM "#variables.datasource.prefix#content"."domain"
			WHERE 1=1
			
			<cfif structKeyExists(arguments.filter, 'search') and arguments.filter.search neq ''>
				and (
					"domain" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
				)
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'isArchived')>
				and "archivedOn" IS <cfif arguments.filter.isArchived>NOT</cfif> NULL
			</cfif>
			
			ORDER BY
			<cfswitch expression="#arguments.filter.orderBy#">
				<cfdefaultcase>
					"domain" #arguments.filter.orderSort#
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
	
	<cffunction name="hasDomain" access="public" returntype="boolean" output="false">
		<cfargument name="domain" type="string" required="true" />
		
		<cfset var results = '' />
		
		<cfset arguments.domain = trim(arguments.domain) />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "domainID"
			FROM "#variables.datasource.prefix#content"."domain"
			WHERE "domain" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domain#" />
				AND "archivedOn" IS NULL
		</cfquery>
		
		<cfreturn results.recordCount GT 0 />
	</cffunction>
	
	<cffunction name="setDomain" access="public" returntype="void" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="domain" type="component" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var observer = '' />
		<cfset var results = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('content', 'domain') />
		
		<!--- TODO Check user permissions --->
		
		<!--- Before Save Event --->
		<cfset observer.beforeSave(variables.transport, arguments.currUser, arguments.domain) />
		
		<cfif arguments.domain.getDomainID() eq ''>
			<!--- Check for archived domain --->
			<cfquery datasource="#variables.datasource.name#" name="results">
				SELECT "domain", "archivedOn"
				FROM "#variables.datasource.prefix#content"."domain"
				WHERE
					"domain" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domain.getDomain()#" />
			</cfquery>
			
			<!--- Check if we found an existing domain --->
			<cfif results.recordCount gt 0>
				<cfif results.archivedOn eq ''>
					<!--- Duplicate domain --->
					<cfthrow type="validation" message="Domain name already in use" detail="The '#arguments.domain.getDomain()#' domain already exists." />
				<cfelse>
					<!--- Unarchive the domain --->
					<cftransaction>
						<cfquery datasource="#variables.datasource.name#" result="results">
							UPDATE "#variables.datasource.prefix#content"."domain"
							SET
								"archivedOn" = NULL
							WHERE
								"domain" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domain.getDomain()#" />
						</cfquery>
					</cftransaction>
					
					<!--- After Update Event --->
					<cfset observer.afterUnarchive(variables.transport, arguments.currUser, arguments.domain) />
				</cfif>
			<cfelse>
				<!--- Insert as a new domain --->
				<!--- Create the new ID --->
				<cfset arguments.domain.setDomainID( createUUID() ) />
				
				<cftransaction>
					<cfquery datasource="#variables.datasource.name#" result="results">
						INSERT INTO "#variables.datasource.prefix#content"."domain"
						(
							"domainID",
							"domain"
						) VALUES (
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domain.getDomainID()#" />::uuid,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domain.getDomain()#" />
						)
					</cfquery>
				</cftransaction>
				
				<!--- After Create Event --->
				<cfset observer.afterCreate(variables.transport, arguments.currUser, arguments.domain) />
			</cfif>
		<cfelse>
			<cftransaction>
				<cfquery datasource="#variables.datasource.name#" result="results">
					UPDATE "#variables.datasource.prefix#content"."domain"
					SET
						"domain" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domain.getDomain()#" />,
						"archivedOn" = NULL
					WHERE
						"domainID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domain.getDomainID()#" />::uuid
				</cfquery>
			</cftransaction>
			
			<!--- After Update Event --->
			<cfset observer.afterUpdate(variables.transport, arguments.currUser, arguments.domain) />
		</cfif>
		
		<!--- After Save Event --->
		<cfset observer.afterSave(variables.transport, arguments.currUser, arguments.domain) />
	</cffunction>
</cfcomponent>