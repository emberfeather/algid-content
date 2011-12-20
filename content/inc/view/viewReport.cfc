<cfcomponent extends="algid.inc.resource.base.view" output="false">
	<cffunction name="contentStats" access="public" returntype="string" output="false">
		<cfargument name="content" type="struct" required="true" />
		<cfargument name="domains" type="struct" required="true" />
		
		<cfset local.pluralize = variables.transport.theApplication.managers.singleton.getPluralize() />
		
		<cfset local.hasContentstats = arguments.content.new.total neq 0
				or arguments.content.archived.total neq 0
				or arguments.content.expired.total neq 0
				or arguments.content.updated.total neq 0 />
		
		<cfset local.hasDomainStats = arguments.domains.new.total neq 0
				or arguments.domains.archived.total neq 0 />
		
		<cfif not local.hasContentStats and not local.hasDomainStats>
			<cfreturn '' />
		</cfif>
		
		<cfsavecontent variable="local.html">
			<cfoutput>
				<dl>
					<cfif local.hasContentStats>
						<dt>Content Statistics</dt>
						
						<cfif arguments.content.new.total gt 0>
							<dd><strong>#local.pluralize.pluralize('piece', arguments.content.new.total)#</strong> of content created</dd>
						</cfif>
						<cfif arguments.content.updated.total gt 0>
							<dd><strong>#local.pluralize.pluralize('piece', arguments.content.updated.total)#</strong> of content updated</dd>
						</cfif>
						<cfif arguments.content.archived.total gt 0>
							<dd><strong>#local.pluralize.pluralize('piece', arguments.content.archived.total)#</strong> of content archived</dd>
						</cfif>
						<cfif arguments.content.expired.total gt 0>
							<dd><strong>#local.pluralize.pluralize('piece', arguments.content.expired.total)#</strong> of content expired</dd>
						</cfif>
					</cfif>
					
					<cfif local.hasDomainStats>
						<dt>Domain Statistics</dt>
						
						<cfif arguments.domains.new.total gt 0>
							<dd><strong>#local.pluralize.pluralize('domain', arguments.domains.new.total)#</strong> created</dd>
						</cfif>
						<cfif arguments.domains.archived.total gt 0>
							<dd><strong>#local.pluralize.pluralize('domain', arguments.domains.archived.total)#</strong> archived</dd>
						</cfif>
					</cfif>
				</dl>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn local.html  />
	</cffunction>
</cfcomponent>
