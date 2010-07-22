<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="archiveDomain" access="public" returntype="void" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="domain" type="component" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var observer = '' />
		<cfset var results = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('content', 'domain') />
		
		<!--- TODO Check user permissions --->
		
		<!--- Before Archive Event --->
		<cfset observer.beforeArchive(variables.transport, arguments.currUser, arguments.domain) />
		
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
		<cfset var host = '' />
		<cfset var i18n = '' />
		<cfset var objectSerial = '' />
		<cfset var results = '' />
		
		<cfset i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		<cfset locale = variables.transport.theSession.managers.singleton.getSession().getLocale() />
		
		<cfset domain = variables.transport.theApplication.factories.transient.getModDomainForContent( i18n, variables.transport.theSession.managers.singleton.getSession().getLocale() ) />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "domainID", "domain", "createdOn", "archivedOn"
			FROM "#variables.datasource.prefix#content"."domain"
			WHERE "domainID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domainID#" null="#arguments.domainID eq ''#" />::uuid
		</cfquery>
		
		<cfif results.recordCount>
			<cfset objectSerial = variables.transport.theApplication.managers.singleton.getObjectSerial() />
			
			<cfset objectSerial.deserialize(results, domain) />
			
			<!--- Retrieve the domain hosts --->
			<cfquery name="results" datasource="#variables.datasource.name#">
				SELECT "hostID", "domainID", "hostname", "hasSSL"
				FROM "#variables.datasource.prefix#content"."host"
				WHERE "domainID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.domainID#" />::uuid
				ORDER BY "host" ASC
			</cfquery>
			
			<cfloop query="results">
				<cfset host = variables.transport.theApplication.factories.transient.getModHostForContent( i18n, locale ) />
				
				<cfloop list="#structKeyList(results)#" index="i">
					<cfinvoke component="#host#" method="set#i#">
						<cfinvokeargument name="value" value="#results[i]#" />
					</cfinvoke>
				</cfloop>
				
				<cfset domain.addHosts(host) />
			</cfloop>
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
	
	<cffunction name="getHosts" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var defaults = {
				orderBy = 'hostname',
				orderSort = 'asc'
			} />
		<cfset var results = '' />
		
		<!--- Expand the with defaults --->
		<cfset arguments.filter = extend(defaults, arguments.filter) />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "hostID", "domainID", "hostname", "isPrimary", "hasSSL"
			FROM "#variables.datasource.prefix#content"."host"
			WHERE 1=1
			
			<cfif structKeyExists(arguments.filter, 'domainID') and arguments.filter.domainID neq ''>
				and "domainID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.domainID#" />::uuid
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'hostname') and arguments.filter.hostname neq ''>
				and "hostname" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.hostname#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'search') and arguments.filter.search neq ''>
				and "hostname" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
			</cfif>
			
			ORDER BY
			<cfswitch expression="#arguments.filter.orderBy#">
				<cfdefaultcase>
					"hostname" #arguments.filter.orderSort#
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
	
	<cffunction name="getPrimaryHostname" access="public" returntype="string" output="false">
		<cfargument name="hostname" type="string" required="true" />
		
		<cfset var results = '' />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT "hostname"
			FROM "#variables.datasource.prefix#content"."host"
			WHERE "isPrimary" = <cfqueryparam cfsqltype="cf_sql_bit" value="true" />::boolean
				AND "domainID" IN (
					SELECT "domainID"
					FROM "#variables.datasource.prefix#content"."host"
					WHERE "hostname" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.hostname#" />
				)
			ORDER BY "hostname" ASC
		</cfquery>
		
		<cfif results.recordCount gt 0>
			<cfreturn results.hostname />
		</cfif>
		
		<cfreturn arguments.hostname />
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
	
	<cffunction name="setHosts" access="public" returntype="void" output="false">
		<cfargument name="currUser" type="component" required="true" />
		<cfargument name="hosts" type="array" required="true" />
		
		<cfset var eventLog = '' />
		<cfset var host = '' />
		<cfset var observer = '' />
		<cfset var results = '' />
		
		<!--- Get the event observer --->
		<cfset observer = getPluginObserver('content', 'host') />
		
		<!--- TODO Check user permissions --->
		
		<!--- Before Save Event --->
		<cfset observer.beforeSave(variables.transport, arguments.currUser, arguments.hosts) />
		
		<cfloop array="#arguments.hosts#" index="host">
			<cfif host.getHostID() eq ''>
				<!--- Check for archived hostname --->
				<cfquery datasource="#variables.datasource.name#" name="results">
					SELECT "hostname"
					FROM "#variables.datasource.prefix#content"."host"
					WHERE
						"hostname" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#host.getHostname()#" />
				</cfquery>
				
				<!--- Check if we found an existing hostname --->
				<cfif results.recordCount gt 0>
					<!--- Duplicate hostname --->
					<cfthrow type="validation" message="Hostname name already in use" detail="The '#host.getHostname()#' hostname already exists." />
				<cfelse>
					<!--- Insert as a new hostname --->
					<!--- Create the new ID --->
					<cfset host.setHostID( createUUID() ) />
					
					<!--- Before Create Event --->
					<cfset observer.beforeCreate(variables.transport, arguments.currUser, host) />
					
					<cftransaction>
						<cfquery datasource="#variables.datasource.name#" result="results">
							INSERT INTO "#variables.datasource.prefix#content"."host"
							(
								"hostID",
								"domainID",
								"hostname",
								"isPrimary",
								"hasSSL"
							) VALUES (
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#host.getHostID()#" />::uuid,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#host.getDomainID()#" />::uuid,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#host.getHostname()#" />,
								<cfqueryparam cfsqltype="cf_sql_bit" value="#host.getIsPrimary()#" />::boolean,
								<cfqueryparam cfsqltype="cf_sql_bit" value="#host.getHasSSL()#" />::boolean
							)
						</cfquery>
					</cftransaction>
					
					<!--- After Create Event --->
					<cfset observer.afterCreate(variables.transport, arguments.currUser, host) />
				</cfif>
			<cfelse>
				<!--- Before Update Event --->
				<cfset observer.beforeUpdate(variables.transport, arguments.currUser, host) />
				
				<cftransaction>
					<cfquery datasource="#variables.datasource.name#" result="results">
						UPDATE "#variables.datasource.prefix#content"."host"
						SET
							"domainID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#host.getDomainID()#" />::uuid,
							"hostname" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#host.getHostname()#" />,
							"isPrimary" = <cfqueryparam cfsqltype="cf_sql_bit" value="#host.getIsPrimary()#" />::boolean,
							"hasSSL" = <cfqueryparam cfsqltype="cf_sql_bit" value="#host.getHasSSL()#" />::boolean
						WHERE
							"hostID" = <cfqueryparam cfsqltype="cf_sql_varchar" value="#host.getHostID()#" />::uuid
					</cfquery>
				</cftransaction>
				
				<!--- After Update Event --->
				<cfset observer.afterUpdate(variables.transport, arguments.currUser, host) />
			</cfif>
		</cfloop>
		
		<!--- After Save Event --->
		<cfset observer.afterSave(variables.transport, arguments.currUser, arguments.hosts) />
	</cffunction>
</cfcomponent>
